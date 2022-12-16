// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC165 {

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

abstract contract ERC165 is IERC165 {
function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

interface IERC1155 is IERC165 {

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
    event URI(string value, uint256 indexed id);
    function balanceOf(address account, uint256 id) external view returns (uint256);
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
        external
        view
        returns (uint256[] memory);
    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(address account, address operator) external view returns (bool);
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}

interface IERC1155Receiver is IERC165 {

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

abstract contract ERC1155Receiver is IERC1155Receiver, ERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
    }
}

contract ERC1155Holder is ERC1155Receiver {
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }
}

interface IF1RBAC {
    function isErc1155Handler(address _address)
    external
    view
    returns(bool);
    function isGuardian(address _address)
    external
    view
    returns(bool);
}

contract sftWallet is ERC1155Holder {

    address rbac;
    IF1RBAC r = IF1RBAC(rbac);

    constructor(address _rbac) {
        rbac = _rbac;
    }

    function checkBalance(address sft, uint256 id) external view returns(uint256) {
        return IERC1155(sft).balanceOf(address(this),id);
    }

    function approveAll(address sft, address operator, bool approved) external {
        require(r.isErc1155Handler(msg.sender) == true,"Error: Bad Perms!");
        IERC1155(sft).setApprovalForAll(operator,approved);
    }

    function checkFullApproval(address sft, address operator) external view returns(bool) {
        return IERC1155(sft).isApprovedForAll(address(this),operator);
    }

    function sendSFT(address sft, address _to, uint256 _id, uint256 _amt) external {
        require(r.isErc1155Handler(msg.sender) == true,"Error: Bad Perms!");
        IERC1155(sft).safeTransferFrom(address(this),_to,_id,_amt,"");
    }

    function sendSFTwData(address sft, address _to, uint256 _id, uint256 _amt, bytes memory aux) external {
        require(r.isErc1155Handler(msg.sender) == true,"Error: Bad Perms!");
        IERC1155(sft).safeTransferFrom(address(this),_to,_id,_amt,aux);
    }

    function setRBAC(address newRBAC) external {
        require(r.isGuardian(msg.sender) == true, "Error: Bad Perms!");
        rbac = newRBAC;
    }
}