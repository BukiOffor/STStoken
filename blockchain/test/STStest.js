const{expect,assert} = require("chai");
const{ethers, network, getNamedAccounts, deployments,} = require("hardhat");
const{developmentChains} = require("../helper-hh-config");

!developmentChains.include(network.name)
    ? describe.skip
    : describe("STStokenTest", ()=>{
        let stsToken ,deployer;
        beforeEach(async()=>{
            deployer = await (getNamedAccounts()).deployer
            await deployments.fixture()
            stsToken = ethers.getContract("Stella",deployer);
        })
        describe("Constructor", async()=>{
            it("should initialise properly",async()=>{

            })
        })



    })