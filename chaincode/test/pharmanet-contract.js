/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { ChaincodeStub, ClientIdentity } = require('fabric-shim');
const { PharmanetContract } = require('..');
const winston = require('winston');

const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');
const sinon = require('sinon');
const sinonChai = require('sinon-chai');

chai.should();
chai.use(chaiAsPromised);
chai.use(sinonChai);

class TestContext {

    constructor() {
        this.stub = sinon.createStubInstance(ChaincodeStub);
        this.clientIdentity = sinon.createStubInstance(ClientIdentity);
        this.logger = {
            getLogger: sinon.stub().returns(sinon.createStubInstance(winston.createLogger().constructor)),
            setLevel: sinon.stub(),
        };
    }

}

describe('PharmanetContract', () => {

    let contract;
    let ctx;

    beforeEach(() => {
        contract = new PharmanetContract();
        ctx = new TestContext();
        ctx.stub.getState.withArgs('1001').resolves(Buffer.from('{"value":"pharmanet 1001 value"}'));
        ctx.stub.getState.withArgs('1002').resolves(Buffer.from('{"value":"pharmanet 1002 value"}'));
    });

    describe('#pharmanetExists', () => {

        it('should return true for a pharmanet', async () => {
            await contract.pharmanetExists(ctx, '1001').should.eventually.be.true;
        });

        it('should return false for a pharmanet that does not exist', async () => {
            await contract.pharmanetExists(ctx, '1003').should.eventually.be.false;
        });

    });

    describe('#createPharmanet', () => {

        it('should create a pharmanet', async () => {
            await contract.createPharmanet(ctx, '1003', 'pharmanet 1003 value');
            ctx.stub.putState.should.have.been.calledOnceWithExactly('1003', Buffer.from('{"value":"pharmanet 1003 value"}'));
        });

        it('should throw an error for a pharmanet that already exists', async () => {
            await contract.createPharmanet(ctx, '1001', 'myvalue').should.be.rejectedWith(/The pharmanet 1001 already exists/);
        });

    });

    describe('#readPharmanet', () => {

        it('should return a pharmanet', async () => {
            await contract.readPharmanet(ctx, '1001').should.eventually.deep.equal({ value: 'pharmanet 1001 value' });
        });

        it('should throw an error for a pharmanet that does not exist', async () => {
            await contract.readPharmanet(ctx, '1003').should.be.rejectedWith(/The pharmanet 1003 does not exist/);
        });

    });

    describe('#updatePharmanet', () => {

        it('should update a pharmanet', async () => {
            await contract.updatePharmanet(ctx, '1001', 'pharmanet 1001 new value');
            ctx.stub.putState.should.have.been.calledOnceWithExactly('1001', Buffer.from('{"value":"pharmanet 1001 new value"}'));
        });

        it('should throw an error for a pharmanet that does not exist', async () => {
            await contract.updatePharmanet(ctx, '1003', 'pharmanet 1003 new value').should.be.rejectedWith(/The pharmanet 1003 does not exist/);
        });

    });

    describe('#deletePharmanet', () => {

        it('should delete a pharmanet', async () => {
            await contract.deletePharmanet(ctx, '1001');
            ctx.stub.deleteState.should.have.been.calledOnceWithExactly('1001');
        });

        it('should throw an error for a pharmanet that does not exist', async () => {
            await contract.deletePharmanet(ctx, '1003').should.be.rejectedWith(/The pharmanet 1003 does not exist/);
        });

    });

});
