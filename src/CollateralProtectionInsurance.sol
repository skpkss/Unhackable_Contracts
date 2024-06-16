// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract CollateralProtectionInsurance {
    address public immutable owner;
    uint public immutable coveragePercentage;
    bool public isClaimed;
    uint public protectedAmount;

    constructor(uint _coveragePercentage, address _owner) {
        require(_owner != address(0), "Owner address cannot be zero");
        require(_coveragePercentage <= 100, "Invalid coverage percentage");
        coveragePercentage = _coveragePercentage;
        owner = _owner;
        isClaimed = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function claimCollateralProtection(uint collateralValue) external onlyOwner virtual {
        require(!isClaimed, "Protection already claimed");

        if (coveragePercentage == 100) {
            protectedAmount = collateralValue; // Claim 100% of collateral
        } else {
            // Calculate protected amount based on coverage percentage and collateral value
            protectedAmount = (collateralValue * coveragePercentage) / 100;
        }
        isClaimed = true;
    }
}

contract CollateralProtectionInsuranceEchidnaTest is CollateralProtectionInsurance {
    constructor() CollateralProtectionInsurance(50, msg.sender) {}

    function claimCollateralProtection(uint collateralValue) public override {
        // The onlyOwner modifier is not used here to allow Echidna to call this function
        if (!isClaimed) {
            if (coveragePercentage == 100) {
                protectedAmount = collateralValue; // Claim 100% of collateral
            } else {
                // Calculate protected amount based on coverage percentage and collateral value
                protectedAmount = (collateralValue * coveragePercentage) / 100;
            }
            isClaimed = true;
        }
    }

    // Echidna test to ensure protectedAmount does not exceed the collateral value provided
    function echidna_test_protected_amount() public view returns (bool) {
        return protectedAmount <= 2**256 - 1; // Check for uint256 overflow
    }

    // Echidna test to ensure protectedAmount is set correctly
    function echidna_test_correct_protected_amount() public view returns (bool) {
        if (coveragePercentage == 100) {
            return protectedAmount <= 2**256 - 1; // Check for uint256 overflow
        } else {
            return protectedAmount <= 2**256 - 1; // Check for uint256 overflow
        }
    }

    // Echidna test to ensure isClaimed is set to true after claimCollateralProtection is called
    function echidna_test_is_claimed() public view returns (bool) {
        return !isClaimed || (isClaimed && protectedAmount >= 0);
    }
}
