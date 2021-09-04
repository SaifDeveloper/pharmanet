#!/bin/bash

# imports  
. scripts/envVar.sh
. scripts/utils.sh

CHANNEL_NAME="$1"
DELAY="$2"
MAX_RETRY="$3"
VERBOSE="$4"
: ${CHANNEL_NAME:="pharmachannel"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}

if [ ! -d "channel-artifacts" ]; then
	mkdir channel-artifacts
fi

createChannelTx() {
	set -x
	configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
	res=$?
	{ set +x; } 2>/dev/null
  verifyResult $res "Failed to generate channel configuration transaction..."
}

createChannel() {
	setGlobals 1
	# Poll in case the raft leader is not set yet
	local rc=1
	local COUNTER=1
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
		sleep $DELAY
		set -x
		peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.pharma.net -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock $BLOCKFILE --tls --cafile $ORDERER_CA >&log.txt
		res=$?
		{ set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "Channel creation failed"
}

# joinChannel ORG
joinChannel() {
  FABRIC_CFG_PATH=$PWD/../config/
  ORG=$1
  PEER=$2
  setGlobalsOrgPeer $ORG $PEER
	local rc=1
	local COUNTER=1
	## Sometimes Join takes time, hence retry
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
    sleep $DELAY
    set -x
    peer channel join -b $BLOCKFILE >&log.txt
    res=$?
    { set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "After $MAX_RETRY attempts, peer0.org${ORG} has failed to join channel '$CHANNEL_NAME' "
}

setAnchorPeer() {
  ORG=$1
  docker exec cli ./scripts/setAnchorPeer.sh $ORG $CHANNEL_NAME 
}

FABRIC_CFG_PATH=${PWD}/configtx

## Create channeltx
infoln "Generating channel create transaction '${CHANNEL_NAME}.tx'"
createChannelTx

FABRIC_CFG_PATH=$PWD/../config/
BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"

## Create channel
infoln "Creating channel ${CHANNEL_NAME}"
createChannel
successln "Channel '$CHANNEL_NAME' created"

## Join all the peers to the channel
infoln "Joining manufacturer peer0 to the channel..."
joinChannel 1 0
infoln "Joining distributor peer0 to the channel..."
joinChannel 2 0
infoln "Joining retailer peer0 to the channel..."
joinChannel 3 0
infoln "Joining consumer peer0 to the channel..."
joinChannel 4 0
infoln "Joining transporter peer0 to the channel..."
joinChannel 5 0

infoln "Joining manufacturer peer1 to the channel..."
joinChannel 1 1
infoln "Joining distributor peer1 to the channel..."
joinChannel 2 1
infoln "Joining retailer peer1 to the channel..."
joinChannel 3 1
infoln "Joining consumer peer1 to the channel..."
joinChannel 4 1
infoln "Joining transporter peer1 to the channel..."
joinChannel 5 1

## Set the anchor peers for each org in the channel
infoln "Setting anchor peer for manufacturer..."
setAnchorPeer 1
infoln "Setting anchor peer for distributor..."
setAnchorPeer 2
infoln "Setting anchor peer for retailer..."
setAnchorPeer 3
infoln "Setting anchor peer for consumer..."
setAnchorPeer 4
infoln "Setting anchor peer for transporter..."
setAnchorPeer 5

successln "Channel '$CHANNEL_NAME' joined"
