/*
Copyright (c) 2018 ZSC Dev Team
*/

function ZSCWalletMangement(controlApiAdr, controlApiAbi, tokenManagerAdr, tokenManagerAbi) {
    this.tokenNos = 0;
    this.tokenNames = [];
    this.tokenStatus = [];
    this.tokenSymbols = [];
    this.tokenDecimals = [];
    this.tokenAdrs = [];
    this.account = web3.eth.accounts[0];
    this.myControlApi = web3.eth.contract(controlApiAbi).at(controlApiAdr);
    this.myTokenManager= web3.eth.contract(tokenManagerAbi).at(tokenManagerAdr);
    this.gasPrice = cC_getGasPrice(20);
    this.gasLimit = cC_getGasLimit(700);
}

ZSCWalletMangement.prototype.addTokenContractInfo = function(nameId, symbolId, decimalsId, adrId, hashId, func) {
    var tokenName    =  document.getElementById(nameId).value;
    var tokenSymbol  =  document.getElementById(symbolId).value;
    var decimals     =  document.getElementById(decimalsId).value;
    var tokenAddress =  document.getElementById(adrId).value;

    var callback = func;
    var gm = this;

    gm.myTokenManager.addToken(tokenName, tokenSymbol, decimals, tokenAddress,
        {from: gm.account, gasPrice: gm.gasPrice, gas: gm.gasLimit},
        function(error, result){ 
            if(!error) cC_showHashResultTest(hashId, result, callback);
            else console.log("error: " + error);
        });
}  

ZSCWalletMangement.prototype.loadErcTokenContracts = function(func) {
    var callback = func;
    var gm = this;
    
    gm.numErcTokens(function() {
        for (var i = 0; i < gm.tokenNos; ++i) {
            gm.loadErcTokenContractInfoByIndex(i, function(index){
                if (index == gm.tokenNos - 1) {
                    func();
                }
            });
        }
    });
}

ZSCWalletMangement.prototype.numErcTokens = function(func) {
    var callback = func;
    var gm = this;
    gm.myTokenManager.numOfTokens(
        {from: gm.account},
        function(error, result){ 
            if(!error) {
                gm.tokenNos = result.toString(10); ;
                func();
            } else {
                console.log("error: " + error);
            }
        });
}

ZSCWalletMangement.prototype.loadErcTokenContractInfoByIndex = function(index, func) {
    this.myControlApi.getTokenContractInfoByIndex(i,
        {from: this.account},
        function(error, result){ 
            if(!error) {
                this.parserTokenContractInfoByIndex(result, index);
                func(index);
            } else {
                console.log("error: " + error);
            }
        });
}


/*
"info?name=", "symbol=", "decimals=", "adr=",     
*/
ZSCWalletMangement.prototype.parserTokenContractInfoByIndex = function(urlinfo, index) {
    var found1 = urlinfo.indexOf("?");
    var found2 = urlinfo.indexOf("=");

    if (found1 == -1 || found2 == -1) return false;

    var len = urlinfo.length;
    var offset = urlinfo.indexOf("?");
    var newsidinfo = urlinfo.substr(offset,len)
    var newsids = newsidinfo.split("&");

    var namInfo      = newsids[0];
    var statusInfo   = newsids[1];
    var symbolInfo   = newsids[2];
    var decimalsInfo = newsids[3];
    var addressInfo  = newsids[4];

    this.tokenNames[index]    = namInfo.split("=")[1];
    this.tokenStatus[index]   = statusInfo.split("=")[1];
    this.tokenSymbols[index]  = symbolInfo.split("=")[1];
    this.tokenDecimals[index] = decimalsInfo.split("=")[1];
    this.tokenAdrs[index]     = addressInfo.split("=")[1];

    return true;
}


ZSCWalletMangement.prototype.loadWalletManagementHtml = function(elementId) {
    var text = '<table align="center" style="width:800px;min-height:30px">'
    text += '<tr>'
    text += '   <td><text>Name</text></td> <td><text>Actived</text></td>  <td><text>Sysmbol</text></td>  <td><text>Decimals</text></td>  <td><text>Address</text></td> '
    text += '</tr>'

    for (var i = 0; i < this.userNos; ++i) {
        var name = this.userName[i];
        var hashId = this.userName[i] + "Hash"
        text += '<tr>'
        text += '   <td><text>' + this.tokenNames[i]    + '</text></td>'
        text += '   <td><text>' + this.tokenStatus[i]    + '</text></td>'
        text += '   <td><text>' + this.tokenSymbols[i]  + '</text></td>'
        text += '   <td><text>' + this.tokenDecimals[i]    + '</text></td>'
        text += '   <td><text>' + this.tokenAdrs[i]      + '</text></td>'
        text += '</tr>'
    }
    text += '</table>'
    document.getElementById(elementId).innerHTML = text;  
}



    
