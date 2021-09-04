"use strict";

/**
 * This is a Node.JS application to register a new manufacturer on the network.
 */

 const { Gateway, Wallets } = require('fabric-network');
 const fs = require('fs');
 const path = require('path');

async function main(nameOfOrg, drugName, serialNo) {
  try {
    let dirName;
    let connectionProfile;
    let admin_id;
    // load the network configuration
    if(nameOfOrg === "manufacturer"){
      dirName = "manufacturer.pharma.net";
      connectionProfile = "connection-manufacturer.json";
      admin_id = "manufacturer_admin";
    }else if(nameOfOrg === "distributor"){
      dirName = "distributor.pharma.net";
      connectionProfile = "connection-distributor.json";
      admin_id = "distributor_admin";
    }else if(nameOfOrg === "retailer"){
      dirName = "retailer.pharma.net";
      connectionProfile = "connection-retailer.json";
      admin_id = "retailer_admin";
    }else if(nameOfOrg === "consumer"){
      dirName = "consumer.pharma.net";
      connectionProfile = "connection-consumer.json";
      admin_id = "consumer_admin";
    }else if(nameOfOrg === "transporter"){
      dirName = "transporter.pharma.net";
      connectionProfile = "connection-transporter.json";
      admin_id = "transporter_admin";
    }else{
      throw "Org does not exists!";
    }


    const ccpPath = path.resolve(__dirname, '..', 'network', 'organizations', 'peerOrganizations', dirName, connectionProfile);
    let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

    // Create a new file system based wallet for managing identities.
    const walletPath = path.join(process.cwd(), 'wallet');
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Wallet path: ${walletPath}`);

    // Check to see if we've already enrolled the user.
    const identity = await wallet.get(admin_id);
    if (!identity) {
        console.log('An identity for the user "admin" does not exist in the wallet');
        console.log('Run the registerUser.js application before retrying');
        return;
    }

    // Create a new gateway for connecting to our peer node.
    const gateway = new Gateway();
    await gateway.connect(ccp, { wallet, identity: admin_id, discovery: { enabled: true, asLocalhost: true } });

    // Get the network (channel) our contract is deployed to.
    const network = await gateway.getNetwork('pharmachannel');

    // Get the contract from the network.
    const contract = network.getContract('pharmanet');

    // Submit the specified transaction.
    const currentStateBuffer = await contract.submitTransaction("viewDrugCurrentState", drugName, serialNo);
    console.log('Transaction has been submitted');
    // console.log("shipmentBuffer: ",shipmentBuffer);
    let currentState = JSON.parse(currentStateBuffer.toString());

    let response = JSON.parse(JSON.stringify(currentState).replace(/\\u0000/g,''));
    console.log("response: ",response);

    // Disconnect from the gateway.
    await gateway.disconnect();

    return response;

} catch (error) {
    console.error(`Failed to submit transaction: ${error}`);
    throw error;
    // process.exit(1);
}
}


module.exports.execute = main;
//"registerCompany",companyCRN, companyName, location, organisationRole;
