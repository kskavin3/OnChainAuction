const hre = require("hardhat");

async function main() {
  const OasisReverseAuction = await hre.ethers.getContractFactory("OasisReverseAuction");
  console.log("Deploying OasisReverseAuction contract...");
  const oasisReverseAuction = await OasisReverseAuction.deploy();

  // Wait for the deployment transaction to be mined
  console.log("Waiting for deployment transaction to be mined...");
  await oasisReverseAuction.waitForDeployment();

  // Get the contract address
  const contractAddress = await oasisReverseAuction.getAddress();

  console.log("OasisReverseAuction deployed to:", contractAddress);
}

// Handle errors
main().catch((error) => {
  console.error("Error during deployment:", error);
  process.exitCode = 1;
});
