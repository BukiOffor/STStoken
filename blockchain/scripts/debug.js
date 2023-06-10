const {ethers, getNamedAccounts,deployments} = require("hardhat");

async function main(){
    await deployments.fixture()
    const signer = (await getNamedAccounts()).deployer
    const stella = await ethers.getContractAt('Stella',"0x5FbDB2315678afecb367f032d93F642f64180aa3",signer);
    const balance = await stella.totalSupply()
    const contractBalance = await stella.balanceOf(stella.address)
    const airdrop = await stella.airdrop("0x70997970C51812dc3A010C7d01b50e0d17dc79C8", "10000000")


    console.log(contractBalance.toString())

    const con = await stella.balanceOf("0x70997970C51812dc3A010C7d01b50e0d17dc79C8")
    console.log(con.toString())
}
module.exports = main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });