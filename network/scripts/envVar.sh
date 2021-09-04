#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/pharma.net/orderers/orderer.pharma.net/msp/tlscacerts/tlsca.pharma.net-cert.pem
export PEER0_MANUFACTURER_CA=${PWD}/organizations/peerOrganizations/manufacturer.pharma.net/peers/peer0.manufacturer.pharma.net/tls/ca.crt
export PEER0_DISTRIBUTOR_CA=${PWD}/organizations/peerOrganizations/distributor.pharma.net/peers/peer0.distributor.pharma.net/tls/ca.crt
export PEER0_RETAILER_CA=${PWD}/organizations/peerOrganizations/retailer.pharma.net/peers/peer0.retailer.pharma.net/tls/ca.crt
export PEER0_CONSUMER_CA=${PWD}/organizations/peerOrganizations/consumer.pharma.net/peers/peer0.consumer.pharma.net/tls/ca.crt
export PEER0_TRANSPORTER_CA=${PWD}/organizations/peerOrganizations/transporter.pharma.net/peers/peer0.transporter.pharma.net/tls/ca.crt
export PEER1_MANUFACTURER_CA=${PWD}/organizations/peerOrganizations/manufacturer.pharma.net/peers/peer1.manufacturer.pharma.net/tls/ca.crt
export PEER1_DISTRIBUTOR_CA=${PWD}/organizations/peerOrganizations/distributor.pharma.net/peers/peer1.distributor.pharma.net/tls/ca.crt
export PEER1_RETAILER_CA=${PWD}/organizations/peerOrganizations/retailer.pharma.net/peers/peer1.retailer.pharma.net/tls/ca.crt
export PEER1_CONSUMER_CA=${PWD}/organizations/peerOrganizations/consumer.pharma.net/peers/peer1.consumer.pharma.net/tls/ca.crt
export PEER1_TRANSPORTER_CA=${PWD}/organizations/peerOrganizations/transporter.pharma.net/peers/peer1.transporter.pharma.net/tls/ca.crt

export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.pharma.net/peers/peer0.org3.pharma.net/tls/ca.crt

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="ManufacturerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MANUFACTURER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/manufacturer.pharma.net/users/Admin@manufacturer.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="DistributorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_DISTRIBUTOR_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/distributor.pharma.net/users/Admin@distributor.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:9051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="RetailerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RETAILER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/retailer.pharma.net/users/Admin@retailer.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:11051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="ConsumerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CONSUMER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/consumer.pharma.net/users/Admin@consumer.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:13051
  elif [ $USING_ORG -eq 5 ]; then
    export CORE_PEER_LOCALMSPID="TransporterMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_TRANSPORTER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/transporter.pharma.net/users/Admin@transporter.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:15051

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.pharma.net/users/Admin@org3.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:11051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

setGlobalsOrgPeer() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
    USING_PEER=$2
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG} peer ${USING_PEER}"
  if [ $USING_ORG -eq 1 ] && [ $USING_PEER -eq 0 ]; then
    export CORE_PEER_LOCALMSPID="ManufacturerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MANUFACTURER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/manufacturer.pharma.net/users/Admin@manufacturer.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 2 ] && [ $USING_PEER -eq 0 ]; then
    export CORE_PEER_LOCALMSPID="DistributorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_DISTRIBUTOR_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/distributor.pharma.net/users/Admin@distributor.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:9051
  elif [ $USING_ORG -eq 3 ] && [ $USING_PEER -eq 0 ]; then
    export CORE_PEER_LOCALMSPID="RetailerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RETAILER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/retailer.pharma.net/users/Admin@retailer.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:11051
  elif [ $USING_ORG -eq 4 ] && [ $USING_PEER -eq 0 ]; then
    export CORE_PEER_LOCALMSPID="ConsumerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CONSUMER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/consumer.pharma.net/users/Admin@consumer.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:13051
  elif [ $USING_ORG -eq 5 ] && [ $USING_PEER -eq 0 ]; then
    export CORE_PEER_LOCALMSPID="TransporterMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_TRANSPORTER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/transporter.pharma.net/users/Admin@transporter.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:15051
  elif [ $USING_ORG -eq 1 ] && [ $USING_PEER -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="ManufacturerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_MANUFACTURER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/manufacturer.pharma.net/users/Admin@manufacturer.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:8051
  elif [ $USING_ORG -eq 2 ] && [ $USING_PEER -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="DistributorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_DISTRIBUTOR_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/distributor.pharma.net/users/Admin@distributor.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:10051
  elif [ $USING_ORG -eq 3 ] && [ $USING_PEER -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="RetailerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_RETAILER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/retailer.pharma.net/users/Admin@retailer.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:12051
  elif [ $USING_ORG -eq 4 ] && [ $USING_PEER -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="ConsumerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_CONSUMER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/consumer.pharma.net/users/Admin@consumer.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:14051
  elif [ $USING_ORG -eq 5 ] && [ $USING_PEER -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="TransporterMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_TRANSPORTER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/transporter.pharma.net/users/Admin@transporter.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:16051

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.pharma.net/users/Admin@org3.pharma.net/msp
    export CORE_PEER_ADDRESS=localhost:11051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}


# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.manufacturer.pharma.net:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.distributor.pharma.net:9051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.retailer.pharma.net:11051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_ADDRESS=peer0.consumer.pharma.net:13051
  elif [ $USING_ORG -eq 5 ]; then
    export CORE_PEER_ADDRESS=peer0.transporter.pharma.net:15051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
# parsePeerConnectionParameters() {
#   PEER_CONN_PARMS=""
#   PEERS=""
#   while [ "$#" -gt 0 ]; do
#     setGlobals $1
#     PEER="peer0.org$1"
#     ## Set peer addresses
#     PEERS="$PEERS $PEER"
#     PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
#     ## Set path to TLS certificate
#     TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
#     PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
#     # shift by one to get to the next organization
#     shift
#   done
#   # remove leading space for output
#   PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
# }

parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    ORG="$1"
    setGlobals $1
    if [ $ORG == "1" ]; then
      echo "===============INSIDE IF" " " $ORG
      PEER="peer0.manufacturer"
      PEER0_ORG1_CA=$PEER0_MANUFACTURER_CA
    elif [ $ORG == "2" ]; then
      echo "===============INSIDE ELSE" " " $ORG
      PEER="peer0.distributor"
      PEER0_ORG2_CA=$PEER0_DISTRIBUTOR_CA
    elif [ $ORG == "3" ]; then
      echo "===============INSIDE ELSE" " " $ORG
      PEER="peer0.retailer"
      PEER0_ORG3_CA=$PEER0_RETAILER_CA
    elif [ $ORG == "4" ]; then
      echo "===============INSIDE ELSE" " " $ORG
      PEER="peer0.consumer"
      PEER0_ORG4_CA=$PEER0_CONSUMER_CA
    elif [ $ORG == "5" ]; then
      echo "===============INSIDE ELSE" " " $ORG
      PEER="peer0.transporter"
      PEER0_ORG5_CA=$PEER0_TRANSPORTER_CA
    # elif [ $ORG == "3" ]; then
    #   echo "===============INSIDE ELSE" " " $ORG
    #   PEER="peer0.org3"
    #   PEER0_ORG3_CA=$PEER0_ORG3_CA
    else
      errorln "ORG Unknown"
    fi
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
