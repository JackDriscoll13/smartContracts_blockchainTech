//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Import chainlink interface for refrence in getting latest eth price 
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// Could use safemath as well, if the case, we would use a library in our contract for that variable type. As follows;
// using SafeMathChainlink for uint256;

// Interfaces actually compile down to ABIS 
// ABI = Application Binary Interface 
// ABI tells solidity and other languages how the interface can interact with other contracts (what functions it can use)
// Anytime you want to interact with another contract, you are going to need that contracts ABI



contract FundMe{
   
    address public owner; // create owner variable 
    address[] public funders;
    // The instant our contract gets deployed the constructor contract is called 
    constructor () public{
        owner = msg.sender; //msg.sender is the person who called the function, in the constructor instance, the person who deployed the contract
    }


    // Lets keep track of who sent us some funding 
    mapping (address => uint256 ) public addressToAmountFunded;

    // Defining a function as payable, this contract can be used to pay for things
    function fund () public payable{
        // Set the minimum payment converted to gwei 
        // $50
        uint256 minimumUSD = 50 * 10 ** 18;
        // To set this as minimum, we could do an if statement, if less than minimum, revert,
        // better practice to do require statement. if less than, reverts transaction, returning money and sending message
        require(getConversionRate(msg.value) >= minimumUSD, "You need to send me more money!");

        // In every transaction that occurs, we can get the value sent and who sent it with msg.sender and msg.value
        addressToAmountFunded[msg.sender] += msg.value;
        // what the eth -> USD conversion rates 
        // To connect to real world data, we need an oracle, like chainlink
        funders.push(msg.sender);



    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256){
        AggregatorV3Interface price = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);

        // (uint80 roundID, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) = price.latestRoundData();
        // Instead of returning those other variables from latest round data, we can actually just return blanks ->
        (,int256 answer,,,) = price.latestRoundData();
        // We acknowledge that there are other variables returned by latestRoundData, but don't save them locally, our code is cleaner
        // We want to return 18 decimal places to save our value in terms of wei
        return uint256(answer * 1000000000);
    }

    function getConversionRate(uint256 ethAmount)public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 transPrice = (ethAmount * ethPrice) / 1000000000;
        return transPrice;
    
    }

    // modifiers are used to change the behavior of functions in a declaritive way
    modifier onlyOwner{
        require (msg.sender == owner);
        _;
    }

    function withdraw() public onlyOwner payable {
        // require(msg.sender == owner);
        payable(msg.sender).transfer(address(this).balance);

        // "this" is a term used to refer to the contract we are currently in
        // address(this) = address for current contract 
        // Msg.sender = the person who calls the function, whoever calls the withdraw function is the sender
        // in this case, whoever calls the withdraw function is transfered the entire balance held in the contract

        // We don't want just anyone to be able to withdraw the balance of our contract 
        // We need to require that only the contract owner/admin be able to withdraw

        // We wabt to loop through the funders array 
        for (uint256 i=0; i<funders.length; i++){
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }


}
