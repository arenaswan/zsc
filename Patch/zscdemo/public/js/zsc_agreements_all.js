/*
Copyright (c) 2018 ZSC Dev Team
*/

//class zscWallet
function ZSCAgreementAll(nm, abi, adr) {
    this.userName = nm;
    this.userType;
    this.allAgrNos = 0;
    this.allAgrNames = [];
    this.allAgrStatus = [];
    this.itemTags = [];
    this.account = web3.eth.accounts[0];
    this.contractAdr = adr;
    this.contractAbi = JSON.parse(abi);
    this.gasPrice = bF_getGasPrice();
    this.gasLimit = bF_getGasLimit(700);
}

ZSCAgreementAll.prototype.getUserName = function() {return this.userName;}

ZSCAgreementAll.prototype.setUserType = function(type) {this.userType = type;}

ZSCAgreementAll.prototype.resetAllItemTags = function(gm) {
    for (var i = 0; i < gm.agrNos; ++i) {
        gm.itemTags[i] = false;
    }
}

ZSCAgreementAll.prototype.checkAllItemTags = function(gm) {
    for (var i = 0; i < gm.agrNos; ++i) {
        if (gm.itemTags[i] == false) {
            return false;
        }
    }
    return true;
}

ZSCAgreementAll.prototype.loadAllAgreements = function(func) {
    var gm = this;
    var callBack = func;
    var myControlApi = web3.eth.contract(gm.contractAbi).at(gm.contractAdr);
    
    gm.numAllAgreements(gm, function(gm) {
       if (gm.agrNos == 0) {
            callBack();
        } else {
            gm.resetAllItemTags(gm);
            for (var i = 0; i < gm.allAgrNos; ++i) {
                gm.getAllAgreementNameByIndex(gm, i, function(gm, index) {
                    gm.getAllAgreementStatus(gm, index, function(gm, index) {
                        if (gm.checkAllItemTags(gm) == true) {
                            callBack();
                        }
                    });
                });
            }
        }
    });
}
