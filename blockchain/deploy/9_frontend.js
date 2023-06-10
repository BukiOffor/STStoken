const { frontEndAbiFile,frontEndContractsFile,developmentChains } = require("../helper-hh-config");
const{  network } = require("hardhat");
const fs = require('fs');

const checker = true;


module.exports = async()=>{
    if(checker){
        console.log("Writing to front end...")
        //await updateContractAddresses()
        await updateAbi()
        console.log("Front end written!")
    }
    
    async function updateAbi(){
        const stella = await ethers.getContract('Stella');
        fs.writeFileSync(frontEndAbiFile, stella.interface.format(ethers.utils.FormatTypes.json))//this stella.interface enables us to get the abi
     }

    // async function updateContractAddresses(){
    //     const stella = await ethers.getContract("Stella");
    //     const contractAddresses = JSON.parse(fs.readFileSync(frontEndContractsFile, "utf8"))

    //     if(network.config.chainId.toString() in contractAddresses ){
    //         if(!contractAddresses[network.config.chainId.toString()].includes(stella.address)){
    //             contractAddresses[network.config.chainId.toString()].push(stella.address)
    //         }else {
    //             contractAddresses[network.config.chainId.toString()] = [stella.address]
    //         }
    //         fs.writeFileSync(frontEndContractsFile, JSON.stringify(contractAddresses))
    //     }
    // }
}

module.exports.tags = ["all", "frontend"]
