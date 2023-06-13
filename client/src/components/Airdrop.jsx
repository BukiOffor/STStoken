import {ethers} from "ethers";
import abi from "../../constants/abi.json"
import {useState} from "react"



export default function Airdrop() {
    
    const provider = new ethers.providers.Web3Provider(window.ethereum);

    const Contractaddress = "0xcf7ed3acca5a467e9e704c703e8d87f634fb0fc9"
    const setValue = (setter) => (evt) => setter(evt.target.value);
    const[address, setAddress] = useState('')

    async function connectWallet(){
        if(window.ethereum){
            provider.send("eth_requestAccounts", [])
        }else{
            <>Please Install MetaMask</>
        }
    }
    

    async function getAirdrop(){
        connectWallet()
        const signer = provider.getSigner()
        const STStoken = new ethers.Contract(Contractaddress,abi,signer)
        const receipt = await STStoken.airdrop(address)
        console.log(receipt)
    }
    async function lottery(){
        connectWallet()
        const signer = provider.getSigner();
        const STStoken = new ethers.Contract(Contractaddress,abi,signer)
        const receipt = await STStoken.lottery()
        console.log(receipt)



        



    }

    
    return (
        <>
        <input placeholder="Type in your address"
        value={address}
        onChange={setValue(setAddress)}
        ></input>
        <input type="submit" className="button" value="Airdrop" onClick={getAirdrop} /><br/>
       <br /> <input type="submit" className="button" value="Lottery" onClick={lottery} />


        </>
    )
 }