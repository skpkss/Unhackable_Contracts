// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {CollateralProtectionInsurance} from "../src/CollateralProtectionInsurance.sol";

contract CollateralProtectionInsuranceTest is Test {
    CollateralProtectionInsurance public insurance;
    address public owner = address(1);

    function setUp() public {
        // Deploy the contract with a coverage percentage of 50% and owner address
        insurance = new CollateralProtectionInsurance(50, owner);
    }

    function test_ConstructorInitialization() view public {
        // Check initial values
        assertEq(insurance.coveragePercentage(), 50);
        assertEq(insurance.owner(), owner);
        assertEq(insurance.isClaimed(), false);
    }

    function testFail_ConstructorZeroAddress() public {
        // This should fail because owner address is zero
        new CollateralProtectionInsurance(50, address(0));
    }

    function testFail_ConstructorInvalidCoveragePercentage() public {
        // This should fail because coverage percentage is greater than 100
        new CollateralProtectionInsurance(150, owner);
    }

    function test_ClaimCollateralProtection() public {
        uint collateralValue = 1000;
        uint expectedProtectedAmount = (collateralValue * 50) / 100;

        // Start impersonating the owner
        vm.startPrank(owner);

        // Claim the protection
        insurance.claimCollateralProtection(collateralValue);

        // Check if the protection is claimed
        assertEq(insurance.isClaimed(), true);
        assertEq(insurance.protectedAmount(), expectedProtectedAmount);

        // Stop impersonating the owner
        vm.stopPrank();
    }

    function test_ClaimCollateralProtectionFullCoverage() public {
        // Deploy the contract with 100% coverage
        insurance = new CollateralProtectionInsurance(100, owner);
        uint collateralValue = 1000;

        // Start impersonating the owner
        vm.startPrank(owner);

        // Claim the protection
        insurance.claimCollateralProtection(collateralValue);

        // Check if the protection is claimed
        assertEq(insurance.isClaimed(), true);
        assertEq(insurance.protectedAmount(), collateralValue);

        // Stop impersonating the owner
        vm.stopPrank();
    }

    function testFail_ClaimProtectionByNonOwner() public {
        uint collateralValue = 1000;

        // Try to claim protection by a non-owner
        vm.prank(address(2));
        insurance.claimCollateralProtection(collateralValue);
    }

    function testFail_ClaimProtectionTwice() public {
        uint collateralValue = 1000;

        // Start impersonating the owner
        vm.startPrank(owner);

        // Claim the protection first time
        insurance.claimCollateralProtection(collateralValue);

        // Try to claim protection again
        insurance.claimCollateralProtection(collateralValue);

        // Stop impersonating the owner
        vm.stopPrank();
    }

    function testFuzz_ConstructorInitialization(uint256 _coveragePercentage) public {
        // Limit the coverage percentage to a reasonable range to prevent invalid input
        _coveragePercentage = _coveragePercentage % 101; // Ensure it's between 0 and 100
        CollateralProtectionInsurance fuzzInsurance = new CollateralProtectionInsurance(_coveragePercentage, owner);
        
        assertEq(fuzzInsurance.coveragePercentage(), _coveragePercentage);
        assertEq(fuzzInsurance.owner(), owner);
        assertEq(fuzzInsurance.isClaimed(), false);
    }

    function testFuzz_ClaimCollateralProtection(uint256 _coveragePercentage, uint256 collateralValue) public {
        _coveragePercentage = _coveragePercentage % 101; // Ensure it's between 0 and 100

        uint256 maxCollateralValue = 10**18; // 1 ETH
        collateralValue = collateralValue % maxCollateralValue;

        insurance = new CollateralProtectionInsurance(_coveragePercentage, owner);

        uint expectedProtectedAmount = (collateralValue * _coveragePercentage) / 100;

        vm.startPrank(owner);

        // Claim the protection
        insurance.claimCollateralProtection(collateralValue);

        // Check if the protection is claimed
        assertEq(insurance.isClaimed(), true);
        assertEq(insurance.protectedAmount(), expectedProtectedAmount);

        // Stop impersonating the owner
        vm.stopPrank();
    }
}
