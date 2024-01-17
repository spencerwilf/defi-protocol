// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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
contract DSCEngine is ReentrancyGuard {
    /* Errors */
    error DSCEngine__MustBeMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error DSCEngine__InvalidCollateral();
    error DSCEngine__TransferFromFailed();

    /* State variables */
    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    DecentralizedStableCoin private immutable i_dsc;
    mapping(address user => uint amountDscMinted) private s_DSCMinted;
    address[] private s_collateralTokens;

    /* Events */
    event CollateralDeposited(address indexed user, address indexed token, uint indexed amount);

    /* Modifiers */
    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__MustBeMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address tokenAddress) {
        if (s_priceFeeds[tokenAddress] == address(0)) {
            revert DSCEngine__InvalidCollateral();
        }
        _;
    }

    /* Functions */
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }

        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
            s_collateralTokens.push(tokenAddresses[i]);
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    /* External Functions */
    function depositCollateralAndMintDsc() external {}

    /**
     * @param tokenCollateralAddress The address of the token to deposit as collateral
     * @param amountCollateral The amount of collateral to deposit
     * @notice follows CEI (checks, effects, interactions) pattern
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!success) {
            revert DSCEngine__TransferFromFailed();
        }
    }

    function redeemCollateral() external {}

    function redeemCollateralForDSC() external {}

    /**
     * @notice follows CEI (checks, effects, interactions) pattern
     * @param amountDscToMint The amount of the stablecoin to mint.
     * @notice Must have more collateral than minimum threshold
     */
    function mintDsc(uint amountDscToMint) external moreThanZero(amountDscToMint) nonReentrant {
        s_DSCMinted[msg.sender] += amountDscToMint;
        revertIfHealthFactorIsBroken(msg.sender);

    }

    function burnDSC() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}

    /* Private and Internal Functions */

    function _getAccountInformation(address user) private view returns(uint totalDscMinted, uint collateralValueInUsd) {
        totalDscMinted = s_DSCMinted[user];
        collateralValueInUsd = getCollateralValue(user);
    } 

    /**
     * @notice returns how close a user is to liquidation
     * If a user's health factor goes below 1, they can be liquidated
     */
    function _healthFactor(address user) private view returns(uint) {
        (uint totalDscMinted, uint collateralValueInUsd) = _getAccountInformation(user);
    }

    function revertIfHealthFactorIsBroken(address user) internal view {

    }

    /* Public and External View Functions */

    function getAccountCollateralValue(address user) public view returns(uint) {
        for (uint i = 0; i < s_collateralTokens.length; i++) {
            address token = s_collateralTokens[i];
            uint amount = s_collateralDeposited[user][token];
            totalCollateralValueInUsd += 
        }
    }

    function getUsdValue(address token, uint amount) public view returns(uint) {
        
    }
}
