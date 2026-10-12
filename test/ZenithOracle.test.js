const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ZenithOracle Aggregator Protocol Test", function () {
  let deployer, reporter, nonReporter;
  let oracle;
  let feedId;

  beforeEach(async function () {
    [deployer, reporter, nonReporter] = await ethers.getSigners();

    const ZenithOracle = await ethers.getContractFactory("ZenithOracle");
    oracle = await ZenithOracle.deploy();
    await oracle.waitForDeployment();

    feedId = ethers.encodeBytes32String("KITE/USD");
    await oracle.setReporter(reporter.address, true);
  });

  it("Should allow authorized reporter to publish price data", async function () {
    await oracle.connect(reporter).updatePrice(feedId, 250000000); // 2.50 USD
    const [price, timestamp, roundId] = await oracle.getPrice(feedId);

    expect(price).to.equal(250000000);
    expect(roundId).to.equal(1);
    expect(timestamp).to.be.gt(0);
  });

  it("Should revert on unauthorized updates", async function () {
    await expect(
      oracle.connect(nonReporter).updatePrice(feedId, 250000000)
    ).to.be.revertedWith("ZenithOracle: unauthorized reporter");
  });
});
