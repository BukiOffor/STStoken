import { hoobank } from "../assets"
import { useWeb3Modal } from '@web3modal/react'
import { useState, useEffect } from 'react';
import { useAccount } from 'wagmi'



export const Nav = () => {
  const { open } = useWeb3Modal();
  const [buttonText, setButtonText] = useState('Wallet Connect');
  const { address, isConnected } = useAccount()

  useEffect(()=>{
    if (isConnected) {
      const short = `${address.slice(0,5)}...${address.slice(-4)}`
      setButtonText(short)
    } else {
      setButtonText("Wallet Connect")
    }
    }, [isConnected, address])
 
  return (

<nav className="bg-red-100 border-black dark:bg-gray-900 border-b-1">
  <div className="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4">
  <a href="https://flowbite.com/" className="flex items-center">
      <img src={hoobank} className="h-8 mr-3" alt="Flowbite Logo" />
      <span className="self-center text-2xl font-semibold whitespace-nowrap dark:text-white">Stella</span>
  </a>
  <div className="flex md:order-2">
          <button type="button" className="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2 text-center mr-3 md:mr-0 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
            onClick={async () => {  await open()  }}
          >{buttonText}</button>
      
  </div>
  <div className="items-center justify-between hidden w-full md:flex md:w-auto md:order-1" id="navbar-cta">
  </div>
  </div>
</nav>

  );
};
