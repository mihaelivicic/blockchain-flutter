pragma solidity ^0.8.0;

contract SimpleStorage {
    //a variable that stores number because
    //we set its type to uint
    uint storedData;

    constructor() public {
        storedData = 0;
    }

    //used for changing the number inside
    //storedData variable
    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint retVal) {
        return storedData;
    }
}