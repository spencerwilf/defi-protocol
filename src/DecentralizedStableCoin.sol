// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {ERC20, ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Decentralized Stable Coin
 * @author Spencer Wilfahrt
 * Collateral: Exogenous
 * Minting: Algorithmic
 * Relative Stability: Pegged to USD
 * 
 * @notice This contract is meant to be governed by the DSCEngine. This contract is simply the ERC20 implementation of the stablecoin system.
 */
contract DecentralizedStableCoin is ERC20Burnable, Ownable {

    error DecentralizedStableCoin__MustBeMoreThanZero();
    error DecentralizedStableCoin__BurnAmountExceedsUserBalance();
    error DecentralizedStableCoin__NotZeroAddress();

    constructor() ERC20("DecentraizedStableCoin", "DSC") Ownable(address(0)) {

    }

    function burn(uint _amount) public override onlyOwner {
        uint balance = balanceOf(msg.sender);
        if (_amount <= 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero();
        }
        if (balance < _amount) {
            revert DecentralizedStableCoin__BurnAmountExceedsUserBalance();
        }
        super.burn(_amount);
    }

    function mint(address _to, uint _amount) external onlyOwner returns(bool) {
        if (_to == address(0)) {
            revert DecentralizedStableCoin__NotZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }
}