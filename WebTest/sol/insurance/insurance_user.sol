/**
  Copyright (c) 2018, ZSC Dev Team
  2018-10-19: v0.00.01
 */

pragma solidity ^0.4.25;
// pragma experimental ABIEncoderV2;

import "../utillib/LibString.sol";
import "../common/hashmap.sol";

contract InsuranceTemplate {
    function getByName(bytes32 _name) external view returns (int, string);
}

contract InsuranceUser is Ownable {

    using LibString for *;

    address private userMgr_;
    address private templateAddr_;
    string[] private params_;

    modifier _checkTemplateAddr() {
        require(0 != templateAddr_);
        _;
    }

    constructor() public {
        userMgr_ = new Hashmap();
    }

    /** [desc] Kill the contract.
      * [param] none.
      * [return] none.
      */
    function kill() external _onlyOwner {
        Hashmap(userMgr_).kill();
        selfdestruct(owner_);   
    }

    /** [desc] Get user info.
      * [param] _user: user info address.
      * [return] user info for json data.
      */
    function _getUserInfo(address _user) private view returns (string) {
        string memory str = "{";

        uint len = Hashmap(_user).size();
        for (uint i=0; i<len; i++) {
            int error = 0;
            bytes32 param = bytes32(0);
            bytes32 data1 = bytes32(0);
            string memory value = "";
            address data3 = address(0);
            (error, param, data1, value, data3) = Hashmap(_user).get(i);
            if (0 == error) {
                if ((len -1) == i) {
                    str = str.concat(value.toKeyValue(param.bytes32ToString()));
                } else {
                    str = str.concat(value.toKeyValue(param.bytes32ToString()), ",");
                }
            }
        }

        str = str.concat("}");

        return str;
    }

    /** [desc] Setup.
      * [param] _templateAddr: template contract address.
      * [return] none.
      */
    function setup(address _templateAddr) external _onlyOwner {
        // check template address
        require(0 != _templateAddr);
        templateAddr_ = _templateAddr;
    }

    /** [desc] This unnamed function is called whenever someone tries to send ether to it.
      * [param] none.
      * [return] none.
      */
    function() external payable { revert(); }

    /** [desc] User sign up.
      * [param] _data: json data.
      * [return] none.
      */
    function signUp(string _data) external _onlyOwner _checkTemplateAddr {
        // check param
        require(0 != bytes(_data).length);

        string memory template = "";
        int error = 0;
        (error, template) = InsuranceTemplate(templateAddr_).getByName("[DB]User");
        require(0 == error);
        template.split("#", params_);

        bool valid = false;
        bytes32 name = bytes32(0);
        address user = new Hashmap();

        for (uint i=0; i<params_.length; i++) { 
            if (_data.keyExists(params_[i])) {
                bytes32 param = params_[i].toBytes32();
                string memory value = _data.getStringValueByKey(params_[i]);
                Hashmap(user).set(param, bytes32(0), value, address(0));

                if (params_[i].equals("Name")) {
                    name = value.toBytes32();
                }

                valid = true;
            }
        }

        require(valid);

        Hashmap(userMgr_).set(name, bytes32(0), "", user);
    }

    /** [desc] Get size of users.
      * [param] none.
      * [return] size of users.
      */
    function size() external view returns (uint) {
        return Hashmap(userMgr_).size();
    }

    /** [desc] Get user info by name.
      * [param] _name: user name.
      * [return] error code and user info for json data.
      *           0: success
      *          -1: params error
      *          -2: no data
      *          -3: inner error   
      */
    function getByName(string _name) external view returns (int, string) {
        int error = 0;
        bytes32 data0 = bytes32(0);
        string memory data1 = "";
        address data2 = address(0);
        bytes32 name = _name.toBytes32();

        (error, data0, data1, data2) = Hashmap(userMgr_).get(name);
        if (0 != error) {
            return (error, "{}");
        }

        string memory str = _getUserInfo(data2);
        return (0, str);
    }

    /** [desc] Get user info by id.
      * [param] _name: user id.
      * [return] error code and user info for json data.
      *           0: success
      *          -1: params error
      *          -2: no data
      *          -3: inner error   
      */
    function getById(uint id) external view returns (int, string) {
        int error = 0;
        bytes32 name = bytes32(0);
        bytes32 data0 = bytes32(0);
        string memory data1 = "";
        address data2 = address(0);

        (error, name, data0, data1, data2) = Hashmap(userMgr_).get(id);
        if (0 != error) {
            return (error, "{}");
        }

        string memory str =_getUserInfo(data2);
        return (0, str);
    }

    function getTemplateAddr() external view _onlyOwner returns (address) {
        return templateAddr_;
    }
}
