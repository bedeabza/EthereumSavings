/**
 * @name SavingsContract
 * @author Dragos Badea <bedeabza@gmail.com>
 * @version 1.0
*/

pragma solidity ^0.4.15;

contract SavingsContract {
    // internal beneficiary -> balance
    mapping (address => uint) private savings;

    // date when the deposits become available for withdrawal
    // uint256 public endTime = 1735689600; //1 Jan 2025
    uint256 public endTime = 1512172800; //2 Dec 2017

    // default function to capture payments sent to the contract
    function () external payable {
        deposit(msg.sender);
    }
    
    // deposit paid amount to a beneficiary savings account
    function deposit(address beneficiary) public payable {
        require(beneficiary != address(0));
        require(validDeposit());
        
        savings[beneficiary] += msg.value;
    }
    
    // get beneficiary savings balance
    // contractInstance.savingsBalance("0xf17f52151EbEF6C7334FAD080c5704D77216b732")
    function savingsBalance(address beneficiary) public view returns (uint) {
        return savings[beneficiary];
    }
    
    // get all cumulated savings balance
    // contractInstance.contractBalance()
    function contractBalance() public view returns (uint256) {
        return this.balance;
    }
    
    // after endTime this function can be executed to withdraw savings
    // contractInstancec.withdraw({from: "0xf17f52151EbEF6C7334FAD080c5704D77216b732"})
    function withdraw() public returns (bool) {
        require(msg.sender != address(0));
        require(validWithdrawal());
        
        uint toTransfer = savings[msg.sender];
        
        if (toTransfer > 0) {
            savings[msg.sender] = 0;

            if (!msg.sender.send(toTransfer)) {
                savings[msg.sender] = toTransfer;
                return false;
            }
        }
        
        return true;
    }

    // internal function to check if
    //  - time is less than endTime
    //  - the deposited amount is greater than zero
    function validDeposit() internal view returns (bool) {
        bool withinPeriod = now <= endTime;
        bool nonZero = msg.value != 0;
        
        return withinPeriod && nonZero;
    }

    // internal function to check if
    //  - time is over endTime
    //  - the deposit balance of requester is greater than zero
    function validWithdrawal() internal view returns (bool) {
        bool overPeriod = now > endTime;
        bool nonZero = savings[msg.sender] != 0;
        
        return overPeriod && nonZero;
    }
}