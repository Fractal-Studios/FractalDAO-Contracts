// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}
interface IF1RBAC {
    function isErc20Handler(address _address)
    external
    view
    returns(bool);
    function isGuardian(address _address)
    external
    view
    returns(bool);
}

contract moneyWallet {

    address rbac;
    IF1RBAC r = IF1RBAC(rbac);

    constructor(address _rbac) {
        rbac = _rbac;
    }

    function walletBalance(address token) external view returns(uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    function deposit(address token, uint256 amount) external {
        require(r.isErc20Handler(msg.sender) == true, "Error: Bad Perms!");
        IERC20(token).transferFrom(msg.sender,address(this),amount);
    }

    function send(address destination, address token, uint256 amount) external {
        require(r.isErc20Handler(msg.sender) == true, "Error: Bad Perms!");
        IERC20(token).transfer(destination,amount);
    }

    function grantApproval(address destination, address token, uint256 amount) external {
        require(r.isErc20Handler(msg.sender) == true, "Error: Bad Perms!");
        IERC20(token).approve(destination,amount);
    }

    receive() external payable {}

    fallback() external payable {}

    function ethBalance() public view returns (uint) {
        return address(this).balance;
    }

    function sendEth(address payable _to) public payable {
        require(r.isErc20Handler(msg.sender) == true, "Error: Bad Perms!");
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Error: Failed to send Eth!");
    }

    function setRBAC(address newRBAC) external {
        require(r.isGuardian(msg.sender) == true, "Error: Bad Perms!");
        rbac = newRBAC;
    }
}
