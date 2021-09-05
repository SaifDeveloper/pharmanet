#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s/\${MSP}/$6/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=manufacturer
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/manufacturer.pharma.net/tlsca/tlsca.manufacturer.pharma.net-cert.pem
CAPEM=organizations/peerOrganizations/manufacturer.pharma.net/ca/ca.manufacturer.pharma.net-cert.pem
MSP=ManufacturerMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/manufacturer.pharma.net/connection-manufacturer.json
# echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/manufacturer.pharma.net/connection-manufacturer.yaml

ORG=distributor
P0PORT=9051
CAPORT=8054
MSP=DistributorMSP
PEERPEM=organizations/peerOrganizations/distributor.pharma.net/tlsca/tlsca.distributor.pharma.net-cert.pem
CAPEM=organizations/peerOrganizations/distributor.pharma.net/ca/ca.distributor.pharma.net-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/distributor.pharma.net/connection-distributor.json
# echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/distributor.pharma.net/connection-distributor.yaml

ORG=retailer
P0PORT=11051
CAPORT=9054
MSP=RetailerMSP
PEERPEM=organizations/peerOrganizations/retailer.pharma.net/tlsca/tlsca.retailer.pharma.net-cert.pem
CAPEM=organizations/peerOrganizations/retailer.pharma.net/ca/ca.retailer.pharma.net-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/retailer.pharma.net/connection-retailer.json
# echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/retailer.pharma.net/connection-retailer.yaml

ORG=consumer
P0PORT=13051
CAPORT=10054
MSP=ConsumerMSP
PEERPEM=organizations/peerOrganizations/consumer.pharma.net/tlsca/tlsca.consumer.pharma.net-cert.pem
CAPEM=organizations/peerOrganizations/consumer.pharma.net/ca/ca.consumer.pharma.net-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/consumer.pharma.net/connection-consumer.json
# echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/consumer.pharma.net/connection-consumer.yaml

ORG=transporter
P0PORT=15051
CAPORT=11054
MSP=TransporterMSP
PEERPEM=organizations/peerOrganizations/transporter.pharma.net/tlsca/tlsca.transporter.pharma.net-cert.pem
CAPEM=organizations/peerOrganizations/transporter.pharma.net/ca/ca.transporter.pharma.net-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/transporter.pharma.net/connection-transporter.json
# echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $MSP)" > organizations/peerOrganizations/transporter.pharma.net/connection-transporter.yaml
