// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC721 {
//IERC165
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
//IERC721
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function approve(address to, uint256 tokenId) external;
    function setApprovalForAll(address operator, bool _approved) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
//Metadata
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
interface IF1RBAC {
    function isErc721Handler(address _address)
    external
    view
    returns(bool);
    function isGuardian(address _address)
    external
    view
    returns(bool);
}

contract ERC721Holder is IERC721Receiver {

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}

contract nftWallet is ERC721Holder {

    address rbac;
    IF1RBAC r = IF1RBAC(rbac);

    constructor(address _rbac) {
        rbac = _rbac;
    }

    function checkBalance(address nft) external view returns(uint256) {
        return IERC721(nft).balanceOf(address(this));
    }

    function approveNFT(address nft, address _to, uint256 _id) external {
        require(r.isErc721Handler(msg.sender) == true,"Error: Bad Perms!");
        IERC721(nft).approve(_to, _id);
    }

    function approveAll(address nft, address operator, bool _approved) external {
        require(r.isErc721Handler(msg.sender) == true,"Error: Bad Perms!");
        IERC721(nft).setApprovalForAll(operator, _approved);
    }
    
    function checkFullApproval(address nft, address operator) external view returns(bool) {
        return IERC721(nft).isApprovedForAll(address(this),operator);
    }

    function sendNFT(address nft, address _to, uint256 _id) external {
        require(r.isErc721Handler(msg.sender) == true,"Error: Bad Perms!");
        IERC721(nft).safeTransferFrom(address(this),_to,_id);
    }

    function sendNFTwData(address nft, address _to, uint256 _id, bytes memory aux) external {
        require(r.isErc721Handler(msg.sender) == true,"Error: Bad Perms!");
        IERC721(nft).safeTransferFrom(address(this),_to,_id,aux);
    }

    function setRBAC(address newRBAC) external {
        require(r.isGuardian(msg.sender) == true, "Error: Bad Perms!");
        rbac = newRBAC;
    }
}