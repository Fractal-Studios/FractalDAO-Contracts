// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IF1RBAC {

//Interface for F1RBAC
    function isGuardian(address _address)
    external
    view
    returns(bool);
    function isOracle(address _address)
    external
    view
    returns(bool);
    function isTreasurer(address _address)
    external
    view
    returns(bool);
//MASTER ROLE
    event CrownRemoved(address indexed previousMaster, address indexed newMaster);
    function master() external view returns(address);
    function renounceMaster() external;
    function transferMaster(address newMaster) external;
//ROLE-MANAGER
    function addRoleman(address _roleManager)
    external;
    function delRoleman(address _roleManager)
    external;
    function disableRoleman(address _roleManager)
    external;
    function isRoleman(address _address)
    external
    view
    returns(bool);
    function relinquishRoleman() external;
//PROPOSER
    function addProposer(address _proposer)
    external;
    function delProposer(address _proposer)
    external;
    function disableProposer(address _proposer)
    external;
    function isProposer(address _address)
    external
    view
    returns(bool);
    function relinquishProposer() external;
//ERC20-Handler
    function addErc20Handler(address _erc20Handler)
    external;
    function delErc20Handler(address _erc20Handler)
    external;
    function disableErc20Handler(address _erc20Handler)
    external;
    function isErc20Handler(address _address)
    external
    view
    returns(bool);
    function relinquishErc20Handler() external;
//ERC721-Handler
    function addErc721Handler(address _erc721Handler)
    external;
    function delErc721Handler(address _erc721Handler)
    external;
    function disableErc721Handler(address _erc721Handler)
    external;
    function isErc721Handler(address _address)
    external;
    function relinquishErc721Handler() external;
//ERC1155-Handler
    function addErc1155Handler(address _erc1155Handler)
    external;
    function delErc1155Handler(address _erc1155Handler)
    external;
    function disableErc1155Handler(address _erc1155Handler)
    external;
    function isErc1155Handler(address _address)
    external
    view
    returns(bool);
    function relinquishErc1155Handler() external;
//Private Oracle
    function addPrivateOracle(address _prOracle)
    external;
    function delPrivateOracle(address _prOracle)
    external;
    function disablePrivateOracle(address _prOracle)
    external;
    function isPrivateOracle(address _address)
    external
    view
    returns(bool);
    function relinquishPrivateOracle() external;
//Public Oracle
    function addPublicOracle(address _puOracle)
    external;
    function delPublicOracle(address _puOracle)
    external;
    function disablePublicOracle(address _puOracle)
    external;
    function isPublicOracle(address _address)
    external
    view
    returns(bool);
    function relinquishPublicOracle() external;
//EMERGENCY
    function addER(address _er)
    external;
    function delER(address _er)
    external;
    function disableER(address _er)
    external;
    function isER(address _address)
    external
    view
    returns(bool);
    function relinquishER() external;
}