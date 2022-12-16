// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface INFTWALLET {

    function checkBalance(address nft) external view returns(uint256);
    function approveNFT(address nft, address _to, uint256 _id) external;
    function approveAll(address nft, address operator, bool _approved) external;
    function checkFullApproval(address nft, address operator) external view returns(bool);
    function sendNFT(address nft, address _to, uint256 _id) external;
    function sendNFTwData(address nft, address _to, uint256 _id, bytes memory aux) external;
    function setRBAC(address newRBAC) external;
    function onERC721Received(
    address,
    address,
    uint256,
    bytes memory
    ) external returns (bytes4);
}