const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying ZenithOracle with account:", deployer.address);

  const ZenithOracle = await hre.ethers.getContractFactory("ZenithOracle");
  const oracle = await ZenithOracle.deploy();
  await oracle.waitForDeployment();

  console.log("ZenithOracle deployed to:", await oracle.getAddress());

  // Initialize BTC/USD and ETH/USD feeds
  const ethFeed = hre.ethers.encodeBytes32String("ETH/USD");
  await oracle.updatePrice(ethFeed, 350000000000); // 3500.00 USD (8 dec)
  console.log("Initialized ETH/USD price feed.");

  console.log("Deployment complete.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
