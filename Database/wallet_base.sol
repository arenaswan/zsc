/*
Copyright (c) 2018, ZSC Dev Team
*/

pragma solidity ^0.4.21;

import "./db_entity.sol";

contract WalletBase is DBNode {
    struct Payment {
        uint time_;
        bool isInput_;
        address sender_;
        address receiver_;
        uint256 amount_;
        bytes32 data_;
    }
    uint nos_;
    mapping(uint => Payment) payments_;

    Payment tempPyment_;
    
    bool private isEthAccount_;
    uint lokedValue_;
    uint256 totalValue_;

    address[] multiSig_;
    mapping(address => bool) sigAdrExists_;
    mapping(address => bool) sigStatus_;

    // Constructor
    constructor(bytes32 _name) public DBNode(_name) {
        isEthAccount_ = false;
        lokedValue_ = 0;
        totalValue_= 0;
        tempSigned_ = false;
    }

    ////////// internal functions /////////////
    function setAsEthAccount() internal {
        isEthAccount_ = true;
    }

    function updateTempPayment(address _dest, uint _amount, bytes32 _data) internal {
        tempPyment_.time_     = now;
        tempPyment_.isInput_  = false;
        tempPyment_.sender_   = address(this);
        tempPyment_.receiver_ = _dest;
        tempPyment_.amount_   = _amount;
        tempPyment_.data_     = _data;
    }
    
    function changeValue(bool _doesIncrease, bool _isLocked, uint _amount) internal returns (bool) {
        if (_doesIncrease) {
            if (_isLocked) {
                lokedValue_ = lokedValue_.add(_amount);
            } 
            totalValue_ = totalValue_.add(_amount);
        } else {
            if (_isLocked) {
                require(lokedValue_ >= _amount);
                lokedValue_= lokedValue_.sub(_amount);
            }
            require(totalValue_ >= _amount);
            totalValue_ = totalValue_.sub( _amount);
        }
    }

    function checkBeforeSent(address _dst, uint _amount) internal constant returns (bool) {
        if (totalValue_.sub(lokedValue_) >= _amount && _dst != address(this)) {
            return true;
        } else {
            return false;
        }
    }

    function recordInput(address _sender, uint _amount, bytes32 _data) internal {
        uint index = nos_;
        nos_++;
        payments_[index] = Payment(now, false, _sender, address(this), _amount, _data);
    }

    function recordOut(address _receiver, uint _amount, bytes32 _data) internal {
        require(totalValue_ >= _amount);
        uint index = nos_;
        nos_++;
        payments_[index] = Payment(now, true, address(this), _receiver, _amount, _data);
    }

    function getTempPaymentInfo() internal constant returns (address, uint, bytes32) {
        return (tempPyment_.receiver_, tempPyment_.amount_, tempPyment_.data_);
    }

    ////////// public functions /////////////
    function doesLastTransactionSigned() public constant returns (bool) {
        checkDelegate(msg.sender, 1);

        if (nos_ == 0) {
            return true;
        } else {
            return payments_[nos_ - 1].isSigned_;
        }
    }

    function getBlance(bool _locked) public constant returns (uint256) {
        checkDelegate(msg.sender, 1);

        if (_locked) return lokedValue_;
        else return totalValue_;
    }

    function numTransactions() public constant returns (uint) {
        checkDelegate(msg.sender, 1);

        return nos_;
    }

    function getTransactionInfoByIndex(uint _index) public constant returns (uint, bool, bytes32, uint, address, address) {
        checkDelegate(msg.sender, 1);
        
        require(_index < nos_);
        
        return (payments_[_index].time_,
                payments_[_index].isInput_,
                payments_[_index].data_,
                payments_[_index].amount_,
                payments_[_index].sender_, 
                payments_[_index].receiver_);
    }
}
