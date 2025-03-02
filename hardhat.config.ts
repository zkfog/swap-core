import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.5.16",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
 
  networks: {
    nexus: {
      url: "https://rpc.nexus.xyz/http",
      chainId: 393,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : []
    }
  },
  etherscan: {
    apiKey: {
      'nexus': 'empty'
    },
    customChains: [
      {
        network: "nexus",
        chainId: 393,
        urls: {
          apiURL: "https://explorer.nexus.xyz/api",
          browserURL: "https://explorer.nexus.xyz"
        }
      }
    ]
  }

};

export default config;
