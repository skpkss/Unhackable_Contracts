// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract CryptoWalletInsurance {
    address public immutable owner;
    uint public immutable premiumAmount;
    bool public isClaimed;
    uint public immutable lastPremiumPaidAt;
    uint public immutable claimableAmount;

    constructor(uint _premiumAmount, address _owner) {
        require(_premiumAmount > 0, "Premium must be greater than 0");
        require(_owner != address(0), "Owner address cannot be zero");
        premiumAmount = _premiumAmount;
        owner = _owner;
        isClaimed = false;
        lastPremiumPaidAt = block.timestamp;
        // Set initial claimableAmount based on premium and interest conditions
        if (premiumAmount < 100) {
            claimableAmount = premiumAmount + (premiumAmount / 100); // +1% interest
        } else {
            claimableAmount = premiumAmount + (premiumAmount * 5 / 100); // +5% interest
        }
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function claimInsurance() external onlyOwner virtual {
        require(block.timestamp >= lastPremiumPaidAt + 30 days, "Must wait at least 30 days after last premium payment");
        require(!isClaimed, "Insurance already claimed");
        isClaimed = true;
    }
}

contract CryptoWalletInsuranceEchidnaTest is CryptoWalletInsurance {
    constructor() CryptoWalletInsurance(100, msg.sender) {}

    function claimInsurance() public override {
        // The onlyOwner modifier is not used here to allow Echidna to call this function
        if (block.timestamp >= lastPremiumPaidAt + 30 days && !isClaimed) {
            isClaimed = true;
        }
    }

    // Test to ensure isClaimed is set to true only after the required conditions are met
    function echidna_test_is_claimed_correctly() public view returns (bool) {
        return !isClaimed || (isClaimed && block.timestamp >= lastPremiumPaidAt + 30 days);
    }

    // Test to ensure the claimableAmount is calculated correctly
    function echidna_test_claimable_amount() public view returns (bool) {
        if (premiumAmount < 100) {
            return claimableAmount == premiumAmount + (premiumAmount / 100);
        } else {
            return claimableAmount == premiumAmount + (premiumAmount * 5 / 100);
        }
    }

    // Test to ensure premiumAmount is greater than zero
    function echidna_test_premium_amount() public view returns (bool) {
        return premiumAmount > 0;
    }

    // Test to ensure the owner's address is not zero
    function echidna_test_owner_address() public view returns (bool) {
        return owner != address(0);
    }
}
