// src/PiggyBank.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PiggyBank {
    mapping(address => uint256) private balances;

    // Native Token 입금
    receive() external payable {
            balances[msg.sender] += msg.value;
    }

    // 본인 잔액만 출금 가능
    function withdraw(uint256 amount) external {
            require(balances[msg.sender] >= amount, "Lack of balance");
            balances[msg.sender] -= amount;
            payable(msg.sender).transfer(amount);
    }

    // 본인의 잔액 확인
    function balanceOf(address user) public view returns (uint256) {
            return balances[user];
    }

    // 컨트랙트 전체 잔액
    function totalBalance() public view returns (uint256) {
        return address(this).balance;
    }
}