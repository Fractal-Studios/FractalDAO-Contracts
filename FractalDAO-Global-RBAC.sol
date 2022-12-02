// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract F1RBAC {

//Base Groups
    modifier onlyGuardian() {
        require(
            _rolemans[msg.sender] == true ||
             msg.sender == _master ||
              _eResponders[msg.sender] == true ||
               address(this) == msg.sender,
            "Error: caller is not a Gaurdian"
        );
        _;
    }

    function isGuardian(address _address)
    external
    view
    returns(bool allowed) {
        if(_rolemans[_address] == true ||
         _address == _master){
            allowed = true;
        } else {
            allowed = false;
        }
    }

    function isOracle(address _address)
    external
    view
    returns(bool allowed) {
        if(_puOracles[_address] == true ||
         _prOracles[_address] == true){
            allowed = true;
        } else {
            allowed = false;
        }
    }

    function isTreasurer(address _address)
    external
    view
    returns(bool allowed) {
        if(_erc20Handlers[_address] == true ||
         _erc721Handlers[_address] == true ||
          _erc1155Handlers[_address] == true){
            allowed = true;
        } else {
            allowed = false;
        }   
    }

//MASTER ROLE
    address private _master;

    event CrownRemoved(address indexed previousMaster, address indexed newMaster);

    constructor() {
        address msgSender = _msgSender();
        _master = msgSender;
        emit CrownRemoved(address(0), msgSender);
    }

    function master() public view returns(address) {
        return _master;
    }

    modifier onlyMaster() {
        require(_master == _msgSender(), "Error: Caller is not the master");
        _;
    }

    function renounceMaster() public virtual onlyMaster {
        emit CrownRemoved(_master, address(0));
        _master = address(0);
    }

    function transferMaster(address newMaster) public virtual onlyMaster {
        require(newMaster != address(0), "Error: New master is the zero address");
        emit CrownRemoved(_master, newMaster);
        _master = newMaster;
    }

//ROLE-MANAGER
    mapping(address => bool) internal _rolemans;

    modifier onlyRoleman() {
        require(
            _rolemans[msg.sender] == true || address(this) == msg.sender,
            "Error: caller is not a Role-Manager"
        );
        _;
    }

    function addRoleman(address _roleManager)
    external
    onlyGuardian {
        _rolemans[_roleManager] = true;
    }

    function delRoleman(address _roleManager)
    external
    onlyGuardian {
        delete _rolemans[_roleManager];
    }

    function disableRoleman(address _roleManager)
    external
    onlyGuardian {
        _rolemans[_roleManager] = false;
    }

    function isRoleman(address _address)
    external
    view
    returns(bool allowed) {
        allowed = _rolemans[_address];
    }

    function relinquishRoleman() external onlyRoleman {
        delete _rolemans[msg.sender];
    }
//PROPOSER
    mapping(address => bool) internal _proposers;

    modifier onlyProposer() {
        require(
            _proposers[msg.sender] == true || address(this) == msg.sender,
            "Error: caller is not a Proposer"
        );
        _;
    }

    function addProposer(address _proposer)
    external
    onlyGuardian {
        _proposers[_proposer] = true;
    }

    function delProposer(address _proposer)
    external
    onlyGuardian {
        delete _proposers[_proposer];
    }

    function disableProposer(address _proposer)
    external
    onlyGuardian {
        _proposers[_proposer] = false;
    }

    function isProposer(address _address)
    external
    view
    returns(bool allowed) {
        allowed = _proposers[_address];
    }

    function relinquishProposer() external onlyProposer {
        delete _proposers[msg.sender];
    }
//ERC20-Handler
    mapping(address => bool) internal _erc20Handlers;

    modifier onlyErc20Handler() {
        require(
            _erc20Handlers[msg.sender] == true || address(this) == msg.sender,
            "Error: caller is not an ERC20 Handler"
        );
        _;
    }

    function addErc20Handler(address _erc20Handler)
    external
    onlyGuardian {
        _erc20Handlers[_erc20Handler] = true;
    }

    function delErc20Handler(address _erc20Handler)
    external
    onlyGuardian {
        delete _erc20Handlers[_erc20Handler];
    }

    function disableErc20Handler(address _erc20Handler)
    external
    onlyGuardian {
        _erc20Handlers[_erc20Handler] = false;
    }

    function isErc20Handler(address _address)
    external
    view
    returns(bool allowed) {
        allowed = _erc20Handlers[_address];
    }

    function relinquishErc20Handler() external onlyErc20Handler {
        delete _erc20Handlers[msg.sender];
    }
//ERC721-Handler
    mapping(address => bool) internal _erc721Handlers;

    modifier onlyErc721Handler() {
        require(
            _erc721Handlers[msg.sender] == true || address(this) == msg.sender,
            "Error: caller is not an ERC721 Handler"
        );
        _;
    }

    function addErc721Handler(address _erc721Handler)
    external
    onlyGuardian {
        _erc721Handlers[_erc721Handler] = true;
    }

    function delErc721Handler(address _erc721Handler)
    external
    onlyGuardian {
        delete _erc721Handlers[_erc721Handler];
    }

    function disableErc721Handler(address _erc721Handler)
    external
    onlyGuardian {
        _erc20Handlers[_erc721Handler] = false;
    }

    function isErc721Handler(address _address)
    external
    view
    returns(bool allowed) {
        allowed = _erc721Handlers[_address];
    }

    function relinquishErc721Handler() external onlyErc721Handler {
        delete _erc721Handlers[msg.sender];
    }
//ERC1155-Handler
    mapping(address => bool) internal _erc1155Handlers;

    modifier onlyErc1155Handler() {
        require(
            _erc1155Handlers[msg.sender] == true || address(this) == msg.sender,
            "Error: caller is not an ERC1155 Handler"
        );
        _;
    }

    function addErc1155Handler(address _erc1155Handler)
    external
    onlyGuardian {
        _erc1155Handlers[_erc1155Handler] = true;
    }

    function delErc1155Handler(address _erc1155Handler)
    external
    onlyGuardian {
        delete _erc1155Handlers[_erc1155Handler];
    }

    function disableErc1155Handler(address _erc1155Handler)
    external
    onlyGuardian {
        _erc1155Handlers[_erc1155Handler] = false;
    }

    function isErc1155Handler(address _address)
    external
    view
    returns(bool allowed) {
        allowed = _erc1155Handlers[_address];
    }

    function relinquishErc1155Handler() external onlyErc1155Handler {
        delete _erc1155Handlers[msg.sender];
    }
//Private Oracle
    mapping(address => bool) internal _prOracles;

    modifier onlyPrivateOracle() {
        require(
            _prOracles[msg.sender] == true || address(this) == msg.sender,
            "Error: caller is not a Private Oracle"
        );
        _;
    }

    function addPrivateOracle(address _prOracle)
    external
    onlyGuardian {
        _prOracles[_prOracle] = true;
    }

    function delPrivateOracle(address _prOracle)
    external
    onlyGuardian {
        delete _prOracles[_prOracle];
    }

    function disablePrivateOracle(address _prOracle)
    external
    onlyGuardian {
        _prOracles[_prOracle] = false;
    }

    function isPrivateOracle(address _address)
    external
    view
    returns(bool allowed) {
        allowed = _prOracles[_address];
    }

    function relinquishPrivateOracle() external onlyPrivateOracle {
        delete _prOracles[msg.sender];
    }
//Public Oracle
    mapping(address => bool) internal _puOracles;

    modifier onlyPublicOracle() {
        require(
            _puOracles[msg.sender] == true || address(this) == msg.sender,
            "Error: caller is not a Public Oracle"
        );
        _;
    }

    function addPublicOracle(address _puOracle)
    external
    onlyGuardian {
        _puOracles[_puOracle] = true;
    }

    function delPublicOracle(address _puOracle)
    external
    onlyGuardian {
        delete _puOracles[_puOracle];
    }

    function disablePublicOracle(address _puOracle)
    external
    onlyGuardian {
        _puOracles[_puOracle] = false;
    }

    function isPublicOracle(address _address)
    external
    view
    returns(bool allowed) {
        allowed = _puOracles[_address];
    }

    function relinquishPublicOracle() external onlyPublicOracle {
        delete _puOracles[msg.sender];
    }
//EMERGENCY
    mapping(address => bool) internal _eResponders;

    modifier onlyEmergencyResponder() {
        require(
            _eResponders[msg.sender] == true || address(this) == msg.sender,
            "Error: caller is not an Emergency Response Team Engineer."
        );
        _;
    }

    function addER(address _er)
    external
    onlyGuardian {
        _eResponders[_er] = true;
    }

    function delER(address _er)
    external
    onlyGuardian {
        delete _eResponders[_er];
    }

    function disableER(address _er)
    external
    onlyGuardian {
        _eResponders[_er] = false;
    }

    function isER(address _address)
    external
    view
    returns(bool allowed) {
        allowed = _eResponders[_address];
    }

    function relinquishER() external onlyEmergencyResponder {
        delete _eResponders[msg.sender];
    }
    
    function _msgSender() internal view virtual returns(address payable) {
        return payable(msg.sender);
    }
}