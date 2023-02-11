contract Ownership {
    address owner = msg.sender;

    function Owner() public {
        owner = msg.sender;
    }

    modifier isOwner() {
        require(owner == msg.sender);
        _;
    }
}

contract Pausable is Ownership {
    bool is_paused;

    modifier ifNotPaused() {
        require(!is_paused);
        _;
    }

    function paused() public isOwner {
        is_paused = true;
    }

    function resume() public isOwner {
        is_paused = false;
    }
}

contract Token is Pausable {
    mapping(address => uint256) public balances;

    function transfer(address to, uint256 value) public ifNotPaused {
        require(balances[msg.sender] != 0);

        uint256 prevBalanceOfMsgSender = balances[msg.sender];
        uint256 prevBalanceOfTo = balances[to];

        balances[msg.sender] -= value;
        balances[to] += value;

        assert(balances[msg.sender] <= prevBalanceOfMsgSender);
        assert(balances[to] >= prevBalanceOfTo);
    }
}
