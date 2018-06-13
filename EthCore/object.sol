/*
Copyright (c) 2018, ZSC Dev Team
2017-12-18: v0.01
*/

pragma solidity ^0.4.21;

import "./delegate.sol";

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function transfer(address to, uint tokens) public returns (bool success);
    function balanceOf(address _owner) public constant returns (uint balance);
}

contract Recorder {
    function addLog(string _log, bool _newLine) public;
}

contract TimeStamp {
    function getTime(uint _time) public constant returns (bytes32);
}

contract Object is Delegated {
    bytes32 private name_ = "null";
    address public logRecorder_ = 0;
    address public timer_ = 0;

    // Constructor
    function Object(bytes32 _name) public { 
        name_ = _name;
    }

    // This unnamed function is called whenever someone tries to send ether to it
    function() public payable { revert(); }

    function name() public constant returns (bytes32) { 
        checkDelegate(msg.sender, 1);
        return name_;
    }

    function setLogRecorderAndTimer(address _rocorderAdr, address _timerAdr) public {
        checkDelegate(msg.sender, 1);
        logRecorder_ = _rocorderAdr;
        timer_ = _timerAdr;
    }

    function getTimeStr(uint _time) internal constant returns (bytes32) {
        if (timer_ != address(0)) {
            return TimeStamp(timer_).getTime(_time);
        } else {
            return 0;
        }
    }

    function addLog(string _log, bool _newLine) public {
        checkDelegate(msg.sender, 1);
        if (logRecorder_ != 0) {
            Recorder(logRecorder_).addLog(_log, _newLine);
        }
    }

    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
        checkOwner(msg.sender);
        return ERC20Interface(tokenAddress).transfer(msg.sender, tokens);
    }    
}
