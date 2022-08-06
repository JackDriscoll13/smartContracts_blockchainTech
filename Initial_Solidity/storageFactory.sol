//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Import our other contract
import "./SimpleStorage.sol";

// Inheritance. I can add all the functions to this contract that were in SimpleStorageContract 
contract StorageFactory is SimpleStorageContract {
    
    //Create an array to store the simple storage object. Define the variable we are putting in it and name it simpleStorageArray
    SimpleStorageContract[] public simpleStorageArray;
    
    function createSimpleStorageContract() public {
        SimpleStorageContract simpleStorage = new SimpleStorageContract();
        simpleStorageArray.push(simpleStorage);

    }
    // Get and set functions:
    /*
    function sfStoreDraft (uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // Anytime we want to interact with a contract we need: Address, ABI
        SimpleStorageContract simpleStorage = SimpleStorageContract(address(simpleStorageArray[_simpleStorageIndex]));
        simpleStorage.store(_simpleStorageNumber);
    }

    function sfGettestDraft (uint256 _simpleStorageIndex) public view returns(uint256){
        SimpleStorageContract simpleStorage = SimpleStorageContract(address(simpleStorageArray[_simpleStorageIndex]));
        return simpleStorage.retrieve();

    }
    */
    // Lets write these more efficiently:
    function sfStore (uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        return SimpleStorageContract(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
    }

    function sfGet (uint256 _simpleStorageIndex) public view returns(uint256){
        return SimpleStorageContract(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
    }

}