// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { NaiveReceiverLenderPool } from "./NaiveReceiverLenderPool.sol";
import { FlashLoanReceiver } from "./FlashLoanReceiver.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract NaiveReceiverEchidna {
    using Address for address payable;

    // We will send ETHER_IN_POOL to the flash loan pool.
    uint256 constant ETHER_IN_POOL = 1000 ether;

    // We will send ETHER_IN_RECEIVER to the flash loan receiver.
    uint256 constant ETHER_IN_RECEIVER = 10 ether;

    NaiveReceiverLenderPool pool;
    FlashLoanReceiver receiver;

    constructor() payable {
        pool = new NaiveReceiverLenderPool();
        receiver = new FlashLoanReceiver(payable(address(pool)));

        payable(address(pool)).sendValue(ETHER_IN_POOL);
        payable(address(receiver)).sendValue(ETHER_IN_RECEIVER);
    }

    // We want to test whether the balance of the receiver contract can be decreased.
    function echidna_test() public view returns (bool) {
        return address(receiver).balance >= ETHER_IN_RECEIVER;
    }
}