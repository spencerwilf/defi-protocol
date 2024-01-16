// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {ERC20, ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/**
 * @title Decentralized Stable Coin
 * @author Spencer Wilfahrt
 * Collateral: Exogenous
 * Minting: Algorithmic
 * Relative Stability: Pegged to USD
 * 
 * @notice This contract is meant to be governed by the DSCEngine. This contract is simply the ERC20 implementation of the stablecoin system.
 */
contract DecentralizedStableCoin is ERC20Burnable {

    constructor() ERC20("DecentraizedStableCoin", "DSC") {
        
    }
}