
export const Jumbo = () => {
  return (
      <div>
          
          <section className="bg-white">
    <div className="py-8 px-4 mx-auto max-w-screen-xl lg:py-16 grid lg:grid-cols-2 gap-8 lg:gap-16">
        <div className="flex flex-col justify-center">
            <h1 className="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">A Token for the world’s potential</h1>
                      <p className="mb-6 text-sm font-normal text-gray-500 lg:text-sm dark:text-gray-400">
                      On an order book, market price is determined by the point at which the highest bid price meets the lowest ask price. Because Stella does not use an order book, there are no bid or ask prices available to reference. Instead, Stella Token leverages a constant product function to determine asset prices. This approach is summarized by the equation x*y=k, where x is the amount of token A in a liquidity pool, y is the amount of token B in a liquidity pool, and k is a constant number. As the ratio of token A to token B fluctuates with trade, the exchange rate between the two assets changes in response.
            </p>
            <a href="https://docs.uniswap.org/contracts/v2/concepts/protocol-overview/how-uniswap-works" className="text-blue-600 dark:text-blue-500 hover:underline font-medium text-lg inline-flex items-center">Read more about our algorithm on uniswap 
                <svg className="w-3.5 h-3.5 ml-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 10">
                    <path stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M1 5h12m0 0L9 1m4 4L9 9"/>
                </svg>
            </a>
        </div>
        <div>
            <div className="w-full lg:max-w-xl p-6 space-y-8 sm:p-8 bg-white rounded-lg my-6 shadow-xl dark:bg-gray-800">
                <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
                    Swap your tokens
                </h2>
                <htmlForm className="mt-8 space-y-6" action="#">

                    <div className="mt-6"> 
                        <input type="text" name="id" id="" placeholder="Swap ETH for STS: " className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" required/>
                    </div>
                    
                    <button type="submit" className="w-full px-5 py-3 text-base font-medium text-center text-white bg-blue-700 rounded-lg hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 sm:w-auto dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">Swap</button>
                    
                </htmlForm>
            </div>
        </div>
    </div>
</section>


    </div>
  )
}

