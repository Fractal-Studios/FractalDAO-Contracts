// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IUserVoteDB {

    function setVPO(address account, uint256 amount) external;

    function setVPS(address account, uint256 amount) external;

    function setLVT(address account, uint256 timestamp) external;

    function addToTotal(uint256 amount) external;

    function getVPO(address account) external view returns(uint256);

    function getVPS(address account) external view returns(uint256);

    function getLVT(address account) external view returns(uint256);

    function getTotalVotes() external view returns(uint256);
}