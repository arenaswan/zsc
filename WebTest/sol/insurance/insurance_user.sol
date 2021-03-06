/**
  Copyright (c) 2018, ZSC Dev Team
  2018-10-19: v0.00.01
 */

pragma solidity ^0.4.25;
// pragma experimental ABIEncoderV2;

import "../utillib/LibString.sol";
import "../utillib/LibInt.sol";
import "../common/hashmap.sol";
import "../common/delegate.sol";

contract InsuranceUser is Delegate {

    using LibString for *;
    using LibInt for *;

    address private userMgr_;
    string[] private keys_;

    modifier _onlyAdminOrHigher() {
        require(checkDelegate(msg.sender, 2));
        _;
    }

    constructor() public {
        userMgr_ = new Hashmap();
    }

    /** [desc] Destroy the contract.
      * [param] none.
      * [return] none.
      */
    function destroy() public _onlyOwner {
        Hashmap(userMgr_).kill();
        userMgr_ = address(0);
        super.kill();
    }

    /** [desc] Get detail info.
      * [param] _addr: info address.
      * [return] error code and info for json data.
      *           0: success
      *          -1: params error
      *          -2: no data
      *          -3: no authority
      *          -9: inner error  
      */
    function _getDetailInfo(address _addr) private view returns (int, string) {
        uint len = Hashmap(_addr).size(true);
        if (0 == len) {
            return (-2, "");
        }

        string memory str = "{";
        str = str.concat(len.toKeyValue("Size"), ",");
        for (uint i=0; i<len; i++) {
            int error = 0;
            string memory key = "";
            uint8 position = 0;
            string memory data0 = "";
            address data1 = address(0);
            uint data2 = uint(0);
            (error, key, position, data0, data1, data2) = Hashmap(_addr).get(i, true);
            if (0 != error) {
                return (error, "");
            }

            if (0 == position) {
                str = str.concat(data0.toKeyValue(key));
            } else if (1 == position) {
                string memory data = "0x";
                data = data.concat(data1.addrToAsciiString());
                str = str.concat(data.toKeyValue(key));
            } else if (2 == position) {
                str = str.concat(data2.toKeyValue(key));
            } else {
                return (-9, "");
            }

            if ((len -1) > i) {
                str = str.concat(",");
            }
        }

        str = str.concat("}");

        return (0, str);
    }

    /** [desc] Get user brief info.
      * [param] _key: user key.
      * [param] _addr: nfo address.
      * [return] error code and info for json data.
      *           0: success
      */
    function _getBriefInfo(string _key, address _addr) private pure returns (int, string) {
        string memory str = "{\"Size\":2,";
        string memory user = "0x";

        user = user.concat(_addr.addrToAsciiString());

        str = str.concat(_key.toKeyValue("Key"), ",");
        str = str.concat(user.toKeyValue("Address"), "}");

        return (0, str);
    }

    /** [desc] User sign up.
      * [param] _userKey: user key.
      * [param] _template: user template data.
      * [param] _data: json data.
      * [return] none.
      */
    function add(string _userKey, string _template, string _data) external _onlyAdminOrHigher {
        // check param
        require(0 != bytes(_userKey).length);
        require(0 != bytes(_template).length);
        require(0 != bytes(_data).length);
        require(!exist(0, _userKey, 0));

        _template.split("#", keys_);

        bool valid = false;
        address user = new Hashmap();

        for (uint i=0; i<keys_.length; i++) { 
            if (_data.keyExists(keys_[i])) {
                string memory value = _data.getStringValueByKey(keys_[i]);
                Hashmap(user).set(keys_[i], 0, value, address(0), uint(0));
                valid = true;
            }
        }

        require(valid);

        Hashmap(userMgr_).set(_userKey, 1, "", user, uint(0));
    }

    /** [desc] remove user.
      * [param] _key: key of user.
      * [return] none.
      */
    function remove(string _key) external _onlyAdminOrHigher {
        // check param
        require(0 != bytes(_key).length);
        Hashmap(userMgr_).remove(_key);
    }

    /** [desc] Get size of users.
      * [param] none.
      * [return] size of users.
      */
    function size() public view returns (uint) {
        return Hashmap(userMgr_).size(true);
    }

    /** [desc] Check user exist
      * [param] _type: info type (0: key is string, 1: key is address).
      * [param] _key0: user key for string.
      * [param] _key0: user key for address.
      * [return] true/false.
      */
    function exist(uint8 _type, string _key0, address _key1) public view returns (bool) {
        // check param
        if (((0 == _type) && (0 == bytes(_key0).length)) 
          || (((1 == _type)) && (address(0) == _key1)) || (_type > 1)) {
            return false;
        }

        string memory key = "";
        if (0 == _type) {
            key = _key0;
        } else {
            key = key.concat("0x", _key1.addrToAsciiString());
        }

        int error = 0;
        uint position = 0;
        string memory data0 = "";
        address user = address(0);
        uint data2 = uint(0);
        (error, position, data0, user, data2) = Hashmap(userMgr_).get(key, true);
        if ((0 != error) || (1 != position)) {
            return false;
        }

        return true;
    }

    /** [desc] Get user info by key.
      * [param] _type: info type (0: detail, 1: brief).
      * [param] _key: user key.
      * [return] error code and user info for json data.
      *           0: success
      *          -1: params error
      *          -2: no data
      *          -3: no authority
      *          -9: inner error  
      */
    function getByKey(uint8 _type, string _key) external view returns (int, string) {
        // check param
        if ((1 < _type) || (0 == bytes(_key).length)) {
            return (-1, "");
        }

        int error = 0;
        uint position = 0;
        string memory data0 = "";
        address user = address(0);
        uint data2 = uint(0);
        (error, position, data0, user, data2) = Hashmap(userMgr_).get(_key, true);
        if (0 != error) {
            return (error, "");
        }
        if (1 != position) {
            return (-9, "");
        }

        if (0 == _type) {
            return _getDetailInfo(user);
        } else {
            return _getBriefInfo(_key, user);
        }
    }

    /** [desc] Get user info by id.
      * [param] _type: info type (0: detail, 1: brief).
      * [param] _id: user id.
      * [return] error code and user info for json data.
      *           0: success
      *          -1: params error
      *          -2: no data
      *          -3: no authority
      *          -9: inner error     
      */
    function getById(uint8 _type, uint _id) external view returns (int, string) {
        // check param
        if ((1 < _type) || (size() <= _id)) {
            return (-1, "");
        }

        int error = 0;
        string memory key = "";
        uint position = 0;
        string memory data0 = "";
        address user = address(0);
        uint data2 = uint(0);
        (error, key, position, data0, user, data2) = Hashmap(userMgr_).get(_id, true);
        if (0 != error) {
            return (error, "");
        }
        if (1 != position) {
            return (-9, "");
        }

        if (0 == _type) {
            return  _getDetailInfo(user);
        } else {
            return _getBriefInfo(key, user);
        }
    }
}
