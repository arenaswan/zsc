/*
Copyright (c) 2018, ZSC Dev Team
*/

pragma solidity ^0.4.21;

/*
contract DBDatabase {
    function getNode(bytes32 _name) public view returns (address);
    function destroyNode(address _node) public returns (bool);
    function checkeNodeByAddress(address _adr) public view returns (bool);
    function _addNode(address _node) public ;
}

contract DBNode {
    function setId(address _ethWalletiId) public;
    function getId() public returns (address);
    function getNodeType() public view returns (bytes32);
    function getBlance(bool _locked) public view returns (uint256);

    function setActivated(bool _activated) public;
    function getActivated() public view returns (bool);

    function addParameter(bytes32 _parameter) public returns (bool);
    function removeParameter(bytes32 _parameter) public returns (bool);
    function setParameter(bytes32 _parameter, bytes32 _value) public returns (bool);
    function getParameter(bytes32 _parameter) public view returns (bytes32);
    function numParameters() public view returns (uint);
    function getParameterNameByIndex(uint _index) public view returns (bytes32);

    function setERC20TokenAddress(address _tokenAdr) public;
    function doesLastTransactionSigned() public view returns (bool);
    //function submitTransaction(address _dest, uint256 _amount, bytes _data, address _user) public returns (uint);
    //function confirmTransaction(address _sigAdr) public returns (uint);    
    function executeTransaction(address _dest, uint256 _amount) public returns (uint);
    function informTransaction(address _src, address _dest, uint256 _amount) public;
    function numTransactions() public view returns (uint);
    function getTransactionInfoByIndex(uint _index) public view returns (uint, bool, bytes32, uint, address, address);

    function setAgreementStatus(bytes32 _tag, bytes32 receiver) public returns (bool);
    function configureHandlers() public returns (bool);
    function getHandler(bytes32 _type) public view returns (address);
    function numAgreements() public view returns (uint);
    function getAgreementByIndex(uint _index) public view returns (address);

    function numChildren() public view returns(uint);
    function getChildByIndex(uint _index) public  view returns(address);
    function addChild(address _node) public returns (address);

    function getMiningInfoByIndex(bool _isReward, uint _index) public view returns (uint, uint);
    function numMiningInfo(bool _isReward) public view returns (uint);

    function addSignature(address _sigAdr) public returns (bool);
    function getAgreementInfo() public view returns (bytes32, bytes32, uint, uint, bytes32, uint);
}

contract FactoryBase {
    function setDatabase(address _adr) public;
    function getDatabase() public view returns (address);
    function createNode(bytes32 _nodeName, address _parent, address _creator) public returns (address);
}

contract WalletBase {
    function getBlance() public view returns (uint256);
    function getLockBalanceInfoByAgreement(address _agreementAdr) public view returns (uint, uint, uint, address);
    function setLockValue(bool _tag, uint _amount, uint _duration, address _agreementAdr) public returns (bool);
    function executeTransaction(address _dest, uint256 _amount) public returns (bool);
}
*/

contract DBNode {
    function getNodeType() public view returns (bytes32);
    function getBlance() public view returns (uint256);

    function addParameter(bytes32 _parameter) public returns (bool);
    //function removeParameter(bytes32 _parameter) public returns (bool);
    function setParameter(bytes32 _parameter, bytes32 _value) public returns (bool);
    function getParameter(bytes32 _parameter) public view returns (bytes32);
    function numParameters() public view returns (uint);
    function getParameterNameByIndex(uint _index) public view returns (bytes32);

    function setERC20TokenAddress(address _tokenAdr) public;
    //function submitTransaction(address _dest, uint256 _amount, bytes _data, address _user) public returns (uint);
    //function confirmTransaction(address _sigAdr) public returns (uint);    
    function executeTransaction(address _dest, uint256 _amount) public returns (uint);
    function informTransaction(address _src, uint256 _amount) public;
    function numTransactions() public view returns (uint);
    function getTransactionInfoByIndex(uint _index) public view returns (uint, bool,  bytes32, uint, address, address);

    function setAgreementStatus(bytes32 _tag, bytes32 receiver) public returns (bool);
    //function configureHandlers() public returns (bool);
    //function getHandler(bytes32 _type) public view returns (address);

    function bindAgreement(address _adr) public;
    function numAgreements() public view returns (uint);
    function numTemplates() public view returns (uint);
    function getAgreementByIndex(uint _index) public view returns (address);
    function getTemplateByIndex(uint _index) public view returns (address);

    function numChildren() public view returns(uint);
    function getChildByIndex(uint _index) public  view returns(address);
    function addChild(address _node) public returns (address);

    //function getMiningInfoByIndex(bool _isReward, uint _index) public view returns (uint, uint);
    //function numMiningInfo(bool _isReward) public view returns (uint);

    //function addSignature(address _sigAdr) public returns (bool);
    //function getAgreementInfo() public view returns (bytes32, bytes32, uint, uint, bytes32, uint);

    function simulatePayforInsurance() public returns (uint);
}

contract DBFactory {
    function setDatabase(address _adr) public;
    function createNode(bytes32 _nodeName, address _parent) public returns (address);
    function numFactoryNodes() public view returns (uint);
    function getFactoryNodeNameByIndex(uint _index) public view returns (bytes32);
}

contract DBDatabase {
    function delegateFactory(address _adr, uint _priority) public;
    function getNode(bytes32 _name) public view returns (address);
    function getRootNode() public view returns (address);
    function destroyNode(address _node) public returns (bool);
    function checkeNodeByAddress(address _adr) public view returns (bool);
    function _addNode(address _node) public ;
}

