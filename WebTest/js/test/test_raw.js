
import Transaction from '../common/transaction_raw.js';
import Output from '../common/output.js';
import ZSCRaw from '../zsc/zsc_raw.js';

//private member
const contractName = Symbol('contractName');
const compiledJson = Symbol('compiledJson');
const abi = Symbol('abi');
const contractAddress = Symbol('contractAddress');
const deployFunc = Symbol('deployFunc');

export default class TestRaw {

    constructor() {
        this[contractName] = '';
        this[compiledJson] = '';
        this[abi] = '';
        this[contractAddress] = '';
    }

    setContractName(name) {
        this[contractName] = name;
    }

    setCompiledJson(data) {
        this[compiledJson] = JSON.parse(data);
    }

    [deployFunc](caller, address) {
        console.log('TestRaw.deployFunc()');
        caller[contractAddress] = address;
    }

    deploy() {
        console.log('TestRaw.deploy()');
        let name = '';
        let byteCode = '';
        let parameter = '';
        let deploy;

        for (name in this[compiledJson].contracts) {
            if (name.indexOf(this[contractName]) > 0)
                break;
            //console.log(contractName);
        }

        byteCode = '0x' + this[compiledJson].contracts[name].bin;
        this[abi] = JSON.parse(this[compiledJson].contracts[name].abi);
        parameter = 'tester';

        transaction = new Transaction();
        if('undefined' != typeof transaction) {
            //transaction.do("deploy", data, result, null);
        }
    }

    set() {
        console.log('TestRaw.set()');
        let zsc = new ZSCRaw(this[abi], this[contractAddress]);
        
        // zsc.set(1, "(1) hello");
        // zsc.set(2, "(2) hello");
        // zsc.set(3, "(3) hello");
        // zsc.set(4, "(4) hello");
        // zsc.set(5, "(5) hello");
        
        // should make sure that nonce is not the same
        zsc.setRaw(1, "(1) hello", function(status) {
            if ("0x1" == status) {
                zsc.setRaw(2, "(2) hello", function(status) {
                    if ("0x1" == status) {
                        zsc.setRaw(3, "(3) hello", function(status) {
                            if ("0x1" == status) {
                                zsc.setRaw(4, "(4) hello", function(status) {
                                    if ("0x1" == status) {
                                        zsc.setRaw(5, "(5) hello", null);
                                    }
                                });
                            }
                        });
                    }
                });
            }
        });
    }

    get() {
        console.log('TestRaw.get()');
        let zsc = new ZSCRaw(this[abi], this[contractAddress]);
        zsc.get(4);
    }

    do(operation) {
        console.log('TestRaw.do(%s)', operation);
        switch(operation) {
            case 'Deploy':
                this.deploy();
                break;
            case 'Set':
                this.set();
                break;
            case 'Get':
                this.get();
                break;
            default:
                Output(window.outputElement, 'small', 'red', 'Operation Error!');
                break;
        }
    }
}