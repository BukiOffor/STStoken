import {ethers} from "ethers";
import abi from "../../constants/abi.json"
import {useState} from "react"



export default function Airdrop() {

    const[address, setAddress] = useState('')
    const provider = new ethers.providers.Web3Provider(window.ethereum);


    const setValue = (setter) => (evt) => setter(evt.target.value);

    const Contractaddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"
    
    async function getAirdrop(){
        const STStoken = new ethers.Contract(Contractaddress,abi,provider)
        const signer = provider.getSigner()
        STStoken.connect(signer)
        await STStoken.airdrop(address)
        //console.log(receipt)
    }


    
    return (
        <>
        <input placeholder="Type in your address"
        value={address}
        onChange={setValue(setAddress)}
        ></input>
        <input type="submit" className="button" value="Transfer" onClick={getAirdrop} />

        </>
    )
 }