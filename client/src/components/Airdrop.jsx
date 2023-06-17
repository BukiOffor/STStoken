import {ethers} from "ethers";
import abi from "../../constants/abi.json"
import {useState} from "react"



export default function Airdrop() {
    
    const provider = new ethers.providers.Web3Provider(window.ethereum, "any");
    provider.on("network", (newNetwork, oldNetwork) => {
        // When a Provider makes its initial connection, it emits a "network"
        // event with a null oldNetwork along with the newNetwork. So, if the
        // oldNetwork exists, it represents a changing network
        if (oldNetwork) {
            window.location.reload();
        }
    })

    const Contractaddress = "0xcf7ed3acca5a467e9e704c703e8d87f634fb0fc9"
    const setValue = (setter) => (evt) => setter(evt.target.value);
    const[address, setAddress] = useState('')
    const[ signer, setSigner] = useState("")
    const[ amount, setAmount] = useState("")
    const[checker, setChecker] = useState(false)


    async function connectWallet(){
        if(window.ethereum){
            provider.send("eth_requestAccounts", [])
            const response = provider.getSigner();
            setSigner(response);
            setChecker(true)
        }else{
            <>Please Install MetaMask</>
        }
    }
    window.addEventListener('load', connectWallet) 

    

    async function getAirdrop(){
        //await connectWallet()
        //const signer = provider.getSigner()
        const STStoken = new ethers.Contract(Contractaddress,abi,signer)
        const receipt = await STStoken.airdrop(address)
        console.log(receipt)
    }
    async function lottery(){
        const STStoken = new ethers.Contract(Contractaddress,abi,signer)
        const receipt = await STStoken.lottery()
        console.log(receipt)
    }
     async function getTokenPrice(amount){
        const STStoken = new ethers.Contract(Contractaddress,abi,signer)
        const price = await STStoken.requestSTSforETH(amount)
        console.log(price);
        
     }
    
    return (
        <>
        <input type="submit" className="button" value="connect" onClick={()=>{connectWallet}} /><br />

        <br /><input placeholder="Type in your address"
        value={address}
        onChange={setValue(setAddress)}
        ></input>
        <input type="submit" className="button" value="Airdrop" onClick={getAirdrop} /><br/>
       
        <br/> <input placeholder="Type in your amount to swap"
        value={amount}
        onChange={setValue(setAmount)}
        ></input>
        <input type="submit" className="button" value="Lottery" onClick={()=>{getTokenPrice(amount)}} />



        </>
    )
 }