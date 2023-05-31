// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./Ownable.sol";
contract CosmoPanda is ERC20, Ownable {
   
    uint256 private _maxLimit;
    constructor(address devFund) 
    ERC20("CosmoPanda", "PAND") 
    {
            _mint(msg.sender, 700000000 * (10 ** 18)); //70%
            _mint(devFund, 300000000 * (10 ** 18)); //10% + 10% + 5% + 5%     
            _maxLimit = 10000000 * (10 ** 18); // Set initial maximum holding limit to 1% of total supply
    }
    function burn(uint256 value) external {
        _burn(_msgSender(), value);
    }
    function getMaxLimit() external onlyOwner view returns (uint256)
    {  
        return _maxLimit; 
    }
    function setMaxLimit(uint256 limit) external onlyOwner 
    {  
         _maxLimit = limit * (10 ** 18); //account max token limit      
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20) {
        if (from != address(0) && to != address(0) && from != owner() && to != owner()) {
            require(
                super.balanceOf(to) + amount <= _maxLimit,
                "Exceeded maximum holding limit"
            );
        }
        super._beforeTokenTransfer(from, to, amount);
    }
}
