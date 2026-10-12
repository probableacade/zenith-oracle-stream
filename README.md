# Zenith Oracle Stream: Decentralized Real-Time Oracle Feed

![Solidity](https://img.shields.io/badge/Solidity-^0.8.20-blue)
![Hardhat](https://img.shields.io/badge/Framework-Hardhat-yellow)
![License](https://img.shields.io/badge/License-MIT-green)

A modular, low-latency on-chain **Oracle Data Feed Aggregator Protocol** tailored for real-time asset pricing, telemetry indexing, and decentralized synthetic settlement on EVM networks.

---

## 🌟 Key Features

- **Multi-Feed Multiplexing**: Gas-optimized indexing using 32-byte hash keys (`bytes32 feedId`).
- **Heartbeat Staleness Guards**: Automatic reverts when price data exceeds maximum configurable validity intervals.
- **Role-Based Reporter Auth**: Multi-node validator and reporter whitelist management.
- **Round-by-Round Versioning**: Monotonically increasing round IDs for seamless historic indexing.

---

## 🏗 Architecture

```text
       +---------------------------------------------+
       |         Off-Chain Price Relayers / Nodes    |
       +----------------------+----------------------+
                              |
                     updatePrice(feedId, price)
                              |
                              v
       +----------------------+----------------------+
       |                ZenithOracle                 |
       |  - Whitelist Check                          |
       |  - Update Round & Timestamp                 |
       +---------------------------------------------+
                              |
                     getPrice(feedId)
                              |
                              v
       +----------------------+----------------------+
       |           DeFi Protocols / Synthetics       |
       +---------------------------------------------+
```

---

## 🚀 Quick Start

### 1. Installation

```bash
git clone https://github.com/probableacade/zenith-oracle-stream.git
cd zenith-oracle-stream
npm install
```

### 2. Compile Contracts

```bash
npx hardhat compile
```

### 3. Run Automated Tests

```bash
npx hardhat test
```

### 4. Deploy

```bash
npx hardhat run scripts/deploy.js --network localhost
```

---

## 📄 License

Distributed under the MIT License. See [LICENSE](LICENSE) for more details.
