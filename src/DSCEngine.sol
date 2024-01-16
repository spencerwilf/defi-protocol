// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

/**
 * @title DSCEngine
 * @author Spencer Wilfahrt
 * 
 * System is designed to maintain a $1 peg. This stablecoin has the following features
 * 1.) Exogenous capital (wBTC, wETH)
 * 2.) Dollar Pegged
 * 3.) Algorithmically stable
 * 
 * The system is similar to DAI with the following exceptions
 * 1.) No governance
 * 2.) No fees
 * 3.) Only backed by wETH and wBTC
 * 
 * @notice DSC should be perpetually overcollateralized. At no point should the value of all collateral be less the value of all DSC.
 * 
 * @notice Tnis contract is the core of the DSC system. It handles all the logic for minting and redeeming DSC, as well as withdrawing collateral.
 * 
 * @notice This contrct is loosely based on the MakerDAO DSS (DAI) system.
 */
contract DSCEngine {

    function depositCollateralAndMintDsc() external {}

    function redeemCollateralForDSC() external {}

    function burnDSC() external {}

    function liquidate() external {}

    function getHealthFactor() external view {
        
    }
}