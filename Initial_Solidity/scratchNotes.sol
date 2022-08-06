pragma solidity ^0.6.0;


// Just a file where I can save deleted notes from the smart contracts 
// and files 
contract SimpleStorage {
    uint256 favoriteNumber = 50;
    bool favBool = true;
    string favStriing = "Jack";
    int256 favInt = -5;
    address favoriteAddress = 0x6ac9e08b3aa6b501e5fb29b3d65e4c12305ba721;
    bytes32 favByte = "dog";


}


pragma solidity ^0.6.0;

contract SimpleStorage {
    // This is a comment in solidity 
    
    // This will get itiliazed to 0
    // add keyword 'public' to this var
    uint256 public favoriteNumber;

    // Lets create a function 
    function store(uint256 _favoriteNumber)public {
        favoriteNumber = _favoriteNumber;
    }


    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }


    // There are 2 keywords that define functions that you don't have to make a transaction on 
    // View, Pure
    // A view function means we want to read something off the blockchain. Public variables inherently have view functions

    // Pure functions only do some type of math. The don't "save state". 

    function retrieve(uint256 favoriteNumber) public pure {
        favoriteNumber + favoriteNumber;
        
    }

}