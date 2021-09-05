# pharmanet

<h1>Network Bootstrap</h1>

cd network

`./network.sh up createChannel -s couchdb -ca`

<h1>Deploy Chaincode</h1>

`./network.sh deployCC -ccn pharmanet -ccp ../chaincode -ccv 1 -ccs 1 -ccl javascript`

<h1>Enroll Admin Identities</h1>

`cd application`

`node enrollAdmin.js`

<h1>Start the client application</h1>

`npm start`