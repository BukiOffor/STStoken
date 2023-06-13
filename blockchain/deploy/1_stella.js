const{ethers,network} = require("hardhat");
const {verify} = require("../scripts/verify")
const {networkConfig,developmentChains} = require("../helper-hh-config")

module.exports.default = async({deployments})=>{
    const {deploy,log} = deployments;
    const accounts = await ethers.getSigners();
    const signer = accounts[0].address;
    const chainID = network.config.chainId;
    const initialSupply = networkConfig[chainID].initialSupply;
    const gasLane = networkConfig[chainID]['gasLane'];
    const callBackGasLimit = networkConfig[chainID]["callBackGasLimit"];
    let VrfCoordinatorV2Address, subscriptionId,value, vrfCoordinatorV2MOCK;


    if(!developmentChains.includes(network.name)){
        VrfCoordinatorV2Address = networkConfig[chainID].vrfCoordinatorV2;
        subscriptionId = networkConfig[chainID].subscriptionId;
        value = ethers.utils.parseEther("0.1")
    }else{
        log("Local network detected! Deploying mocks...")
        await deploy("VRFCoordinatorV2Mock",{
            from: signer,
            args: ["250000000000000000", 1e9],
            log: true,
            value: value
        })
        log("Mocks Deployed!")
        log("-------------------------------------------------------------------------------------------------")
        log("You are deploying to a local network, you'll need a local network running to interact")
        log("Please run `yarn hardhat console --network localhost` to interact with the deployed smart contracts!")
        log("--------------------------------------------------------------------------------------------------")
        vrfCoordinatorV2MOCK = await ethers.getContract("VRFCoordinatorV2Mock");
        VrfCoordinatorV2Address = vrfCoordinatorV2MOCK.address;
        const response = await vrfCoordinatorV2MOCK.createSubscription();
        const receipt = await response.wait(1);
        subscriptionId = receipt.events[0].args.subId;
        value = ethers.utils.parseEther("500");
        await vrfCoordinatorV2MOCK.fundSubscription(subscriptionId,ethers.utils.parseEther("100"));
    }

    const args = [initialSupply,subscriptionId,VrfCoordinatorV2Address,gasLane,callBackGasLimit];

    log("*******deploying contract********")
    const stella = await deploy("Stella",{
        from: signer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log("******Contract Deployed********")
    await vrfCoordinatorV2MOCK.addConsumer(
        subscriptionId,
        stella.address
    )

    if(!['hardhat','localhost'].includes(network.name)){
        log(`***********verifying ${stella.address}**********`)
        await verify(stella.address,args)
    }
}
module.exports.tags = ["all", "mocks","stella"]