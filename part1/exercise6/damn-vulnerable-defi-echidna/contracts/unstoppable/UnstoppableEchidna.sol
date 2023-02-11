// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { DamnValuableToken } from "../DamnValuableToken.sol";
import { UnstoppableLender, IReceiver } from "./UnstoppableLender.sol";

contract UnstoppableEchidna {
    // Pool has 1M * 10**18 tokens
    // We will send TOKENS_IN_POOL to the flash loan pool.
    uint256 constant TOKENS_IN_POOL = 1_000_000 ether;

    // We will send INITIAL_ATTACKER_BALANCE to the attacker (which is the deployer) of this contract.
    uint256 constant INITIAL_ATTACKER_TOKEN_BALANCE = 100 ether;

    DamnValuableToken token;
    UnstoppableLender pool;

    constructor() payable {
        token = new DamnValuableToken();
        pool = new UnstoppableLender(address(token));

        token.approve(address(pool), TOKENS_IN_POOL);
        pool.depositTokens(TOKENS_IN_POOL);

        token.transfer(msg.sender, INITIAL_ATTACKER_TOKEN_BALANCE);
    }

    function receiveTokens(address tokenAddress, uint256 amount) external {
        require(msg.sender == address(pool), "Sender must be pool");

        // Return all tokens to the pool
        require(
            IERC20(tokenAddress).transfer(msg.sender, amount),
            "Transfer of tokens failed"
        );
    }

    // This is the Echidna property entrypoint.
    // We want to test whether flash loans can always be made.
    function echidna_testFlashLoan() public returns (bool) {
        pool.flashLoan(10);
        return true;
    }
}