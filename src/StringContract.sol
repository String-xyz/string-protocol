//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.13;

/// @title String Contract Template
/// @author String Technology Inc.
/// @notice Demonstrates standards and conventions for String smart contracts
/// @dev Use verbose variable/function naming to describe what things are/do.
/// @dev Use comments to describe why something is being done
/**
 * @dev Contract layout is:
 * Variables, 
 * Constructor, 
 * Modifiers, 
 * External, 
 * External View, 
 * External Pure, 
 * Public, 
 * Internal, 
 * Private
**/ 

// import "forge-std/console2.sol"; // This debug import must be removed before deployment

contract StringContract {

    string public instanceName; // Label of contract with multiple instances
    address private _deployer; // Deployer has administrative priviledges
    mapping (address => bool) private _mayOnboardUser; // Which contracts may onboard users
    mapping (address => uint256) private _onboardedUsers; // user > risk rating, requires clearance to view

    /// @notice Constructor
    /// @param name Useful if we have several instances of these to keep track of
    constructor(string memory name) {
        instanceName = name;
        _deployer = msg.sender;
    }

    /// @notice Only the admin should be able to allow contracts to onboard users
    /// @param onboarder Whom we wish to allow to onboard users
    function adminAllowOnboarder(address onboarder) external {
        require(msg.sender == _deployer, "!deployer");
        require(_mayOnboardUser[onboarder] == false, "!new");
        _mayOnboardUser[onboarder] = true;
    }

    /// @notice The admin may need to remove stale contracts from onboarding users
    /// @param onboarder Whom we no longer wish to allow to onboard users
    function adminDisableOnboarder(address onboarder) external {
        require(msg.sender == _deployer, "!deployer");
        require(_mayOnboardUser[onboarder] == true, "!exist");
        _mayOnboardUser[onboarder] = false;
    }

    /// @notice Approved contracts may onboard users providing a risk rating
    /// @param user Whom we wish to onboard
    /// @param riskRating % (N/100e18), affects user permissions
    function onboardUser(address user, uint256 riskRating) external {
        require(_mayOnboardUser[msg.sender] == true, "!rights");
        require(_onboardedUsers[user] == 0, "!new");
        require(riskRating > 0, "!riskRating");
        _onboardedUsers[user] = riskRating;
    }

    /// @notice Allow onboarders to check if a user is already onboarded
    /// @param user Whom we wish to check the onboarding status of
    /// @return 0 if not onboarded, otherwise users risk factor
    function isUserOnboarded(address user) external view returns (uint256) {
        require(_mayOnboardUser[msg.sender] == true, "!rights");
        return _onboardedUsers[user];
    }
}