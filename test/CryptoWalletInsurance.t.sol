// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console } from "forge-std/Test.sol";
import {CryptoWalletInsurance} from "../src/CryptoWalletInsurance.sol";

contract CryptoWalletInsuranceTest is Test {
    CryptoWalletInsurance public insurance;
    address public owner = address(1);

    function setUp() public {
        // Deploy the contract with a premiumAmount of 50 and owner address
        insurance = new CryptoWalletInsurance(50, owner);
    }

    function test_ConstructorInitialization_HighPremium() public {
        // Deploy the contract with a high premium amount
        CryptoWalletInsurance highPremiumInsurance = new CryptoWalletInsurance(200, owner);
        assertEq(highPremiumInsurance.claimableAmount(), 200 + (200 * 5 / 100)); // 5% interest
    }

    function testFail_ConstructorZeroPremium() public {
        // This should fail because premium amount is zero
        new CryptoWalletInsurance(0, owner);
    }

    function testFail_ConstructorZeroAddress() public {
        // This should fail because owner address is zero
        new CryptoWalletInsurance(50, address(0));
    }

    function testFail_ClaimInsuranceByNonOwner() public {
        // Set the block.timestamp to 31 days in the future
        vm.warp(block.timestamp + 31 days);

        // Try to claim insurance by a non-owner
        vm.prank(address(2));
        vm.expectRevert("Only owner can claim insurance");
        insurance.claimInsurance();
    }

    function testFail_ClaimInsuranceBefore30Days() public {
        // Try to claim insurance before 30 days have passed
        vm.startPrank(owner);
        insurance.claimInsurance();
        vm.stopPrank();
    }

    function test_ClaimInsurance() public {
        // Set the block.timestamp to 31 days in the future
        vm.warp(block.timestamp + 31 days);
        
        // Start impersonating the owner
        vm.startPrank(owner);
        
        // Claim the insurance
        insurance.claimInsurance();
        
        // Check if the insurance is claimed
        assertEq(insurance.isClaimed(), true);
        
        // Stop impersonating the owner
        vm.stopPrank();
    }

    function testFail_ClaimInsuranceTwice() public {
        // Set the block.timestamp to 31 days in the future
        vm.warp(block.timestamp + 31 days);

        // Claim the insurance first time
        vm.startPrank(owner);
        insurance.claimInsurance();

        // Try to claim insurance again
        insurance.claimInsurance();
        vm.stopPrank();
    }
    function testFuzz_ConstructorInitialization(uint256 _premiumAmount) public {
        // Limit the premium amount to a reasonable range to prevent overflow issues
        uint256 maxPremiumAmount = 10**18; // 1 ETH
        _premiumAmount = _premiumAmount % maxPremiumAmount + 1; // Ensure it's always greater than 0
        CryptoWalletInsurance fuzzInsurance = new CryptoWalletInsurance(_premiumAmount, owner);
        
        if (_premiumAmount < 100) {
            assertEq(fuzzInsurance.claimableAmount(), _premiumAmount + (_premiumAmount / 100)); // +1% interest
        } else {
            assertEq(fuzzInsurance.claimableAmount(), _premiumAmount + (_premiumAmount * 5 / 100)); // +5% interest
        }
    }
    
    function testFuzz_ClaimInsurance(uint256 _days) public {
        _days = _days % 365; // Limit to a year for practical testing
        vm.warp(block.timestamp + (_days * 1 days));

        if (_days >= 30) {
            vm.startPrank(owner);
            insurance.claimInsurance();
            assertEq(insurance.isClaimed(), true);
            vm.stopPrank();
        } else {
            vm.startPrank(owner);
            vm.expectRevert("Must wait at least 30 days after last premium payment");
            insurance.claimInsurance();
            vm.stopPrank();
        }
    }
}
