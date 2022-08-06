// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    // This is a comment in solidity

    // This will get itiliazed to 0
    // add keyword 'public' to this var to make it visible to public
    uint256 favoriteNumber;

    // structs
    // Basically like a class, multiple atributes
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // People public person = People({favoriteNumber: 2, name: "Jack"});

    // creating array (dynamic not fixed)
    People[] public people;

    // Mapping, like a dictiontionary
    // Mapp a string to a mathcing integer, a key to a valuue
    mapping(string => uint256) public nameToNumber;

    // Lets create a function
    function store(uint256 _favoriteNumber) public returns (uint256) {
        favoriteNumber = _favoriteNumber;
        return favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    // add people to the array
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToNumber[_name] = _favoriteNumber; // Just like a python dict!
    }

    // There are 2 ways to store info in solidyty
    // memory (delete after executing), storage (keep forever)
    // When creating parameters need to put memory before string parameters

    // There are 2 keywords that define functions that you don't have to make a transaction on
    // View, Pure
    // A view function means we want to read something off the blockchain. Public variables inherently have view functions

    // Pure functions only do some type of math. The don't "save state".
}
