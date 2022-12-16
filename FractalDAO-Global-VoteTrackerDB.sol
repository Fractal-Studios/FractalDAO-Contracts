// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

abstract contract logicRole {

//MASTER ROLE FOR INIT CONFIG
    address private _master;
    event CrownRemoved(address indexed previousMaster, address indexed newMaster);
    constructor() {
        _master = msg.sender;
        emit CrownRemoved(address(0), msg.sender);
    }
    function master() public view returns(address) {
        return _master;
    }
    modifier onlyMaster() {
        require(_master == msg.sender, "Error: Caller is not the master");
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

    mapping(address => bool) internal _logicContracts;

    modifier onlyLogic() {
        require(
            _logicContracts[msg.sender] == true || address(this) == msg.sender,
            "Error: Logic Permission Error!"
        );
        _;
    }

    function addLogic(address _logic)
    external
    onlyMaster {
        _logicContracts[_logic] = true;
    }

    function delLogic(address _logic)
    external
    onlyMaster {
        delete _logicContracts[_logic];
    }

    function disableLogic(address _logic)
    external
    onlyMaster {
        _logicContracts[_logic] = false;
    }

    function isLogic(address _address)
    external
    view
    returns(bool allowed) {
        allowed = _logicContracts[_address];
    }

    function relinquishLogic() external onlyLogic {
        delete _logicContracts[msg.sender];
    }
}

contract userVoteDB is logicRole {

    uint256 totalVotes;

    mapping(address => uint256) internal _votingPointsOwned;
    mapping(address => uint256) internal _votingPointsSpent;
    mapping(address => uint256) internal _lastVoteTimestamp;

    function setVPO(address account, uint256 amount) external onlyLogic {
        _votingPointsOwned[account] = amount;
    }

    function setVPS(address account, uint256 amount) external onlyLogic {
        _votingPointsSpent[account] = amount;
    }

    function setLVT(address account, uint256 timestamp) external onlyLogic {
        _lastVoteTimestamp[account] = timestamp;
    }

    function addToTotal(uint256 amount) external onlyLogic {
        totalVotes = totalVotes + amount;
    }

    function getVPO(address account) external view returns(uint256) {
        return _votingPointsOwned[account];
    }

    function getVPS(address account) external view returns(uint256) {
        return _votingPointsSpent[account];
    }

    function getLVT(address account) external view returns(uint256) {
        return _lastVoteTimestamp[account];
    }

    function getTotalVotes() external view returns(uint256) {
        return totalVotes;
    }
}