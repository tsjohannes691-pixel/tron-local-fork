# TRON Local Fork - GitHub Codespaces

🚀 **Unlimited fake TRON, zero risk, in GitHub Codespaces**

This repository provides a complete setup for running a local TRON blockchain fork inside GitHub Codespaces. No need for Tenderly (which doesn't support TRON), no mainnet costs, no transaction risks.

## Quick Start

### 1. Open in Codespaces

```bash
# GitHub will automatically run the devcontainer setup
# Once the container is ready, you'll have Java 11 and Python 3
```

### 2. Initialize the Fork

```bash
bash scripts/setup_fork.sh
```

This will:
- ✅ Download `Toolkit.jar` and `FullNode.jar`
- ✅ Generate 3 test wallets with private keys
- ✅ Create `fork.conf` with unlimited TRX and USDT for test accounts
- ✅ Apply the fork to the database
- ✅ Save wallet info to `wallets.json`

### 3. Start the Node

```bash
bash scripts/start_node.sh
```

Expected output:
```
🚀 Starting TRON Local Fork Node
✅ Node config created
🔧 Starting FullNode...
   RPC: http://localhost:8090
   P2P: localhost:18888
```

### 4. Test the RPC

In a new terminal:
```bash
bash scripts/test_rpc.sh
```

You should see:
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x1"
}
```

## What You Get

| Feature | Details |
|---------|----------|
| **RPC Endpoint** | `http://localhost:8090` |
| **Test Wallets** | 3 pre-funded wallets with ~100M TRX each |
| **USDT Balance** | Pre-allocated USDT (TRC20) tokens |
| **Gas/Fees** | Configurable, no real costs |
| **Database** | Fresh fork of TRON mainnet state |
| **Block Producer** | Wallet1 auto-produces blocks |

## Wallet Credentials

After running `setup_fork.sh`, check `wallets.json`:

```json
{
  "wallet_1": {
    "address": "T...",
    "private_key": "0x..."
  },
  "wallet_2": {
    "address": "T...",
    "private_key": "0x..."
  },
  "wallet_3": {
    "address": "T...",
    "private_key": "0x..."
  }
}
```

**⚠️ These are test wallets only. Never use these private keys on mainnet.**

## Usage Examples

### Connect with ethers.js

```javascript
const { ethers } = require("ethers");

const provider = new ethers.providers.JsonRpcProvider(
  "http://localhost:8090"
);

const wallet = new ethers.Wallet(
  "0x...", // private key from wallets.json
  provider
);

const balance = await wallet.getBalance();
console.log("Balance:", ethers.utils.formatEther(balance));
```

### Connect with web3.py

```python
from web3 import Web3

w3 = Web3(Web3.HTTPProvider("http://localhost:8090"))

print(f"Connected: {w3.is_connected()}")
print(f"Chain ID: {w3.eth.chain_id}")
print(f"Block number: {w3.eth.block_number}")

# Get balance
address = "0x..."  # from wallets.json
balance = w3.eth.get_balance(address)
print(f"Balance: {balance} wei")
```

### Deploy a Smart Contract

```bash
# Use Truffle, Hardhat, or other frameworks
# Point RPC to: http://localhost:8090
# Use any wallet from wallets.json as the deployer
```

## Port Forwarding

GitHub Codespaces automatically forwards these ports:

- **8090**: TRON JSON-RPC endpoint (HTTP)
- **18888**: TRON P2P network port

In Codespaces, click the "Ports" tab to see the public URLs.

## Troubleshooting

### Node won't start

```bash
# Check if setup_fork.sh completed
ls -la fork.conf output-directory/

# If fork.conf is missing, run:
bash scripts/setup_fork.sh
```

### RPC returns connection refused

```bash
# Make sure node is running in another terminal
ps aux | grep FullNode.jar

# Check port 8090 is listening
netstat -an | grep 8090
```

### Out of memory

Increase JVM heap in `scripts/start_node.sh`:
```bash
java -Xmx4g -jar FullNode.jar ...  # Use 4GB instead of 2GB
```

## What's Different from Tenderly?

| Feature | Tenderly | This Setup |
|---------|----------|----------|
| TRON Support | ❌ No | ✅ Yes |
| EVM Chains | ✅ Yes | ❌ No |
| Dashboard | ✅ Yes | ❌ No |
| RPC URL | ✅ Managed | ✅ Local |
| Cost | Paid tier | 🎉 Free |
| Privacy | Remote | Local |

## Architecture

```
┌─────────────────────────────────────────────────┐
│   GitHub Codespaces Container   │
│                                 │
│  ┌──────────────────┐           │
│  │ FullNode.jar │◄──────────┬──┤
│  │ (TRON Node)  │           │  │
│  └──────────────────┘           │  │
│         ▲                   │  │
│         │ RPC 8090          │  │
│         │                   │  │
│  ┌──────────────────────────────────────┐    │  │
│  │  Your dApp / Tests  │    │  │
│  │  (ethers, web3.py)  │◄───────┘  │
│  └──────────────────────────────────────┘        │
│                                 │
│  Wallets: wallets.json          │
│  Config: fork.conf              │
└─────────────────────────────────────────────────┘
```

## Next Steps

1. ✅ Run `bash scripts/setup_fork.sh`
2. ✅ Run `bash scripts/start_node.sh`
3. ✅ Test with `bash scripts/test_rpc.sh`
4. 🏗️ Deploy your contracts using the RPC endpoint
5. 🧪 Test your dApp with unlimited fake TRON

## Resources

- [TRON Documentation](https://tronprotocol.org/en)
- [JSON-RPC Methods](https://tronprotocol.github.io/)
- [GitHub Codespaces Docs](https://docs.github.com/en/codespaces)

## License

MIT

---

**💡 Tip:** Keep this repo handy for all your TRON local development needs. Clone it, customize it, and share it with your team!