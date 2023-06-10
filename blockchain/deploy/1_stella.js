const{ethers,network} = require("hardhat");
const {verify} = require("../scripts/verify")

module.exports.default = async({deployments})=>{
    const {deploy,log} = deployments;
    const accounts = await ethers.getSigners()
    const signer = accounts[0].address
    const args = ["5000000000000000000000000000"]

    log("*******deploying contract********")
    const stella = await deploy("Stella",{
        from: signer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log("******Contract Deployed********")

    if(!['hardhat','localhost'].includes(network.name)){
        log(`***********verifying ${stella.address}**********`)
        await verify(stella.address,args)
    }
}