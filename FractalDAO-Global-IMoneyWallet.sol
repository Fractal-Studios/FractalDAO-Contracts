// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IMoneyWallet {
    function walletBalance(address token) external view returns(uint256);
    function deposit(address token, uint256 amount) external;
    function send(address destination, address token, uint256 amount) external;
    function grantApproval(address destination, address token, uint256 amount) external;
    function ethBalance() external view returns (uint);
    function sendEth(address payable _to) external payable;
    function setRBAC(address newRBAC) external;
}
