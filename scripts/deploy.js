const hre = require("hardhat");

async function main() {
  const FreelanceMarketplace = await hre.ethers.getContractFactory("FreelanceMarketplace");
  const contract = await FreelanceMarketplace.deploy();
  await contract.deployed();
  console.log("FreelanceMarketplace deployed to:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
