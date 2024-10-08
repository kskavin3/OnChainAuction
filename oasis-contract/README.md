# Oasis Reverse Auction Smart Contract

This project contains the smart contract for the Oasis Reverse Auction platform, implemented using Hardhat.

## Overview

The Oasis Reverse Auction smart contract enables decentralized reverse auctions on the Oasis Protocol. It allows buyers to create auctions with specific requirements and sellers to place bids, ensuring a transparent and efficient marketplace.

## Prerequisites

- Node.js (version 12 or higher)
- npm (comes with Node.js)
- Hardhat

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-username/oasis-contract.git
   cd oasis-contract
   ```

2. Install dependencies:
   ```
   npm install
   ```

## Usage

### Compiling the contract

To compile the smart contract, run:
npx hardhat compile


### Running tests

To run the test suite:
npx hardhat test


### Deploying the contract

To deploy the contract to a network:
npx hardhat run scripts/deploy.js --network <network-name>


Replace `<network-name>` with the desired network (e.g., `mainnet`, `testnet`, or `localhost`).

## Contract Details

The main contract file is `OasisReverseAuction.sol`, which implements the core functionality of the reverse auction system.

Key features include:
- Creating auctions
- Placing bids
- Concluding auctions
- Handling payments and refunds

## Development

For local development and testing, you can use Hardhat's built-in network:
npx hardhat node


Then, in a separate terminal, run your scripts or tests against the local network.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

## Acknowledgments

- Oasis Protocol Foundation
- OpenZeppelin for secure smart contract libraries
- Hardhat development environment