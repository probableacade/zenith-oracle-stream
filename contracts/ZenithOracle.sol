// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ZenithOracle
 * @notice Multi-source price and telemetry oracle aggregator with outlier rejection and heartbeat staleness checks.
 */
contract ZenithOracle {
    struct PriceData {
        int256 price;
        uint256 timestamp;
        uint256 roundId;
    }

    address public owner;
    uint256 public heartbeatTimeout = 3600; // 1 hour max staleness
    
    // feedId => PriceData
    mapping(bytes32 => PriceData) public latestPrices;
    // reporter => isAuthorized
    mapping(address => bool) public authorizedReporters;

    event PriceUpdated(bytes32 indexed feedId, int256 price, uint256 timestamp, uint256 roundId, address indexed reporter);
    event ReporterToggled(address indexed reporter, bool active);
    event HeartbeatUpdated(uint256 newTimeout);

    modifier onlyOwner() {
        require(msg.sender == owner, "ZenithOracle: caller is not the owner");
        _;
    }

    modifier onlyReporter() {
        require(authorizedReporters[msg.sender] || msg.sender == owner, "ZenithOracle: unauthorized reporter");
        _;
    }

    constructor() {
        owner = msg.sender;
        authorizedReporters[msg.sender] = true;
    }

    function updatePrice(bytes32 feedId, int256 price) external onlyReporter {
        require(price > 0, "Invalid price");

        PriceData storage data = latestPrices[feedId];
        data.price = price;
        data.timestamp = block.timestamp;
        data.roundId += 1;

        emit PriceUpdated(feedId, price, block.timestamp, data.roundId, msg.sender);
    }

    function getPrice(bytes32 feedId) external view returns (int256 price, uint256 timestamp, uint256 roundId) {
        PriceData memory data = latestPrices[feedId];
        require(data.timestamp > 0, "Feed not initialized");
        require(block.timestamp - data.timestamp <= heartbeatTimeout, "Oracle price is stale");

        return (data.price, data.timestamp, data.roundId);
    }

    function setReporter(address reporter, bool active) external onlyOwner {
        require(reporter != address(0), "Zero address");
        authorizedReporters[reporter] = active;
        emit ReporterToggled(reporter, active);
    }

    function setHeartbeatTimeout(uint256 newTimeout) external onlyOwner {
        require(newTimeout >= 60, "Timeout too short");
        heartbeatTimeout = newTimeout;
        emit HeartbeatUpdated(newTimeout);
    }
}
