import "./token.sol";

contract MintableToken is Token{

    uint totalMinted;
    uint totalMintable;

    constructor(uint _totalMintable) public {
        totalMintable = _totalMintable;
    }

    function mint(uint value) isOwner() public {

        require(value + totalMinted < totalMintable);
        totalMinted += value;

        balances[msg.sender] += value;
    }
}
