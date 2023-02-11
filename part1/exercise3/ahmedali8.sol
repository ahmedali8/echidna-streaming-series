pragma solidity 0.8.0;

import "./mintable.sol";

contract TestToken is MintableToken {
    address echidna_caller = msg.sender;

    // update the constructor
    constructor() MintableToken(10_000) public {}

    // add the property
    function echidna_test_balance() public view returns (bool) {
        return balances[echidna_caller] <= 10_000;
    }
}
