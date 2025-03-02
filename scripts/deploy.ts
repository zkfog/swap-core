import { ethers } from "hardhat";

async function main() {

    const [deployer] = await ethers.getSigners();

    console.log(
        "Deploying contracts with the account:",
        deployer.address
    );

    const Shade = await ethers.getContractFactory("ShadeFactory");
    const contract = await Shade.deploy(deployer.address);
    await contract.waitForDeployment()

    console.log("Shade Factory deployed to:", await contract.getAddress());
    console.log("Transaction hash:", contract.deploymentTransaction()?.hash);

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });