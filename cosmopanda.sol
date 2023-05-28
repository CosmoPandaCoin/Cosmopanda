// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CosmoPanda is ERC20, ERC20Burnable, Ownable {
    uint256 private _maxBuyLimit;
    
    constructor(
        address liquidityPoolAddress,
        address burnAddress,
        address developmentFundAddress,
        address listingsAddress,
        address supportAddress
    ) ERC20("CosmoPanda", "COSMO") {
        uint256 totalSupply = 1000000000 * 10 ** decimals();

        uint256 liquidityPoolAmount = totalSupply * 70 / 100;
        uint256 burnAmount = totalSupply * 5 / 100;
        uint256 developmentFundAmount = totalSupply * 10 / 100;
        uint256 listingsAmount = totalSupply * 10 / 100;
        uint256 supportAmount = totalSupply * 5 / 100;

        _mint(liquidityPoolAddress, liquidityPoolAmount);
        _mint(burnAddress, burnAmount);
        _mint(developmentFundAddress, developmentFundAmount);
        _mint(listingsAddress, listingsAmount);
        _mint(supportAddress, supportAmount);

        _maxBuyLimit = totalSupply * 1 / 100; // Set initial maximum buy limit to 1% of total supply
    }
    
    function getMaxBuyLimit() public view returns (uint256) {
        return _maxBuyLimit;
    }
    
    function setMaxBuyLimit(uint256 newLimit) public onlyOwner {
        _maxBuyLimit = newLimit;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20) {
        if (from != address(0) && to != address(0)) {
            require(
                amount <= _maxBuyLimit,
                "Exceeded maximum buy limit"
            );
        }

        super._beforeTokenTransfer(from, to, amount);
    }
}
