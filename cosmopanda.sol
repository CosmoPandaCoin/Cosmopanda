// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";

contract CosmoPanda is ERC20 {
   
    uint256 private _maxLimit;
    address private _owner;
    constructor(address devfund) 
    ERC20("CosmoPanda", "COSMO") 
    {
        unchecked 
        {
            _mint(msg.sender, 700000000 * (10 ** 18)); //70%
            _mint(devfund, 300000000 * (10 ** 18)); //10% + 10% + 5% + 5%
            _owner = msg.sender;       
            _maxLimit = 10000000 * (10 ** 18); // Set initial maximum buy limit to 1% of total supply
        }
    }
    function burn(uint256 value) external {
        _burn(msg.sender, value);
    }
    function setMaxLimit(uint256 limit) public 
    {  
        require(_owner == msg.sender, "Permission denied");
        _maxLimit = limit * (10 ** 18); //account max token limit      
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20) {
        if (from != address(0) && to != address(0)) {
            require(
                super.balanceOf(to) + amount <= _maxLimit,
                "Exceeded maximum holding limit"
            );
        }
        super._beforeTokenTransfer(from, to, amount);
    }
}
