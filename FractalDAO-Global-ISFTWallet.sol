// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ISFTWALLET {

    function checkBalance(address sft, uint256 id) external view returns(uint256);
    function approveAll(address sft, address operator, bool approved) external;
    function checkFullApproval(address sft, address operator) external view returns(bool);
    function sendSFT(address sft, address _to, uint256 _id, uint256 _amt) external;
    function sendSFTwData(address sft, address _to, uint256 _id, uint256 _amt, bytes memory aux) external;
    function setRBAC(address newRBAC) external;
}