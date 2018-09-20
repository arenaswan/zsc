/*
 Copyright (c) 2018 ZSC Dev Team
*/

import Output from './output.js';

//private member
//private function

export default class Receipt {
    constructor() {}

    getReceipt(hash, tryTimes, timeout, func) {
        let handler = this;
        let status  = "Try to get status again!";
        let string = "";

        // if (undefined == hash) {
        //     string = `[TransactionHash]:${hash}</br>[Status]:${status}`;
        //     Output(window.outputElement, 'small', 'red', string);
        //     return;
        // }

        web3.eth.getTransactionReceipt(hash, function(error, result) {
            if (null != result) {
                if ("0x1" == result.status) {
                    status  = "succeeded";
                } else {
                    status  = "failure";
                }
                string = `[TransactionHash]:${hash}</br>[Status]:${status}`;
                Output(window.outputElement, 'small', 'red', string);
                if (null != func) {
                    func(result.status);
                }
            } else {
                tryTimes ++;
                string = `[TransactionHash]:${hash}</br>[Status]:${status}</br>[Try]:${tryTimes}(times)`;
                Output(window.outputElement, 'small', 'red', string);
                setTimeout(function() {
                    handler.getReceipt(hash, tryTimes, timeout, func);
                }, timeout);
            }
        });
    }
}