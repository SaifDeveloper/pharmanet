
'use strict';

const FabricCAServices = require('fabric-ca-client');
const { Wallets } = require('fabric-network');
const fs = require('fs');
const path = require('path');

async function main() {
    
        // load the network configuration
        const ccpPath_manufacturer = path.resolve(__dirname, '..', 'network', 'organizations', 'peerOrganizations', 'manufacturer.pharma.net', 'connection-manufacturer.json');
        const ccpPath_distributor = path.resolve(__dirname, '..', 'network', 'organizations', 'peerOrganizations', 'distributor.pharma.net', 'connection-distributor.json');
        const ccpPath_retailer = path.resolve(__dirname, '..', 'network', 'organizations', 'peerOrganizations', 'retailer.pharma.net', 'connection-retailer.json');
        const ccpPath_consumer = path.resolve(__dirname, '..', 'network', 'organizations', 'peerOrganizations', 'consumer.pharma.net', 'connection-consumer.json');
        const ccpPath_transporter = path.resolve(__dirname, '..', 'network', 'organizations', 'peerOrganizations', 'transporter.pharma.net', 'connection-transporter.json');

        await enrolAdmin(ccpPath_manufacturer,'ca-manufacturer','ManufacturerMSP');
        await enrolAdmin(ccpPath_distributor,'ca-distributor','DistributorMSP');
        await enrolAdmin(ccpPath_retailer,'ca-retailer','RetailerMSP');
        await enrolAdmin(ccpPath_consumer,'ca-consumer','ConsumerMSP');
        await enrolAdmin(ccpPath_transporter,'ca-transporter','TransporterMSP');

}


async function enrolAdmin(ccpPath,caName,msp){
    try {
    const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

        // Create a new CA client for interacting with the CA.
        const caInfo = ccp.certificateAuthorities[caName];
        const caTLSCACerts = caInfo.tlsCACerts.pem;
        const ca = new FabricCAServices(caInfo.url, { trustedRoots: caTLSCACerts, verify: false }, caInfo.caName);

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        //Fetch Org Name from connection Profile
        const org = ccp.client.organization;
        const org_admin = org+"_admin"

        // Check to see if we've already enrolled the admin user.
        const identity = await wallet.get(org_admin);
        if (identity) {
            console.log('An identity for the admin user "admin" already exists in the wallet');
            return;
        }

        // Enroll the admin user, and import the new identity into the wallet.
        const enrollment = await ca.enroll({ enrollmentID: 'admin', enrollmentSecret: 'adminpw' });
        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: msp,
            type: 'X.509',
        };
        await wallet.put(org_admin, x509Identity);
        console.log(`Successfully enrolled admin user "admin" and imported it into the wallet for ${msp}`);

    } catch (error) {
        console.error(`Failed to enroll admin user "admin": ${error}`);
        process.exit(1);
    }
}



main();
