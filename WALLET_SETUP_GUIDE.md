# 🔐 Complete Wallet Configuration Guide for TRON Local Fork

## Step 1: Run the Master Setup Script

First, run all the automation scripts to generate your wallets and ROC nodes:

```bash
bash scripts/run_all_setup.sh
```

**What this does:**
- ✅ Downloads TRON JAR files
- ✅ Generates 3 test wallets with private keys
- ✅ Creates fork.conf with unlimited balances
- ✅ Generates 5 ROC witness nodes
- ✅ Creates wallet statistics and reports

**Expected output:**
```
✅ SETUP COMPLETE!
📁 Generated Files:
   ✅ wallets.json
   ✅ fork.conf
   ✅ roc_nodes/roc_nodes.json
   ✅ wallet_stats/wallet_stats.json
   ✅ wallet_stats/WALLET_REPORT.txt
```

---

## Step 2: View Your Wallet Information

### 2A. View the Beautiful Report
```bash
cat wallet_stats/WALLET_REPORT.txt
```

This shows you all wallet addresses and ROC node details in a formatted table.

### 2B. View Complete JSON Configuration
```bash
cat wallet_stats/wallet_stats.json
```

This contains all the data you need (addresses, private keys, RPC URLs, balances).

### 2C. Quick Reference CSV
```bash
cat wallet_stats/quick_reference.csv
```

Simple table for quick lookups.

---

## Step 3: Start the TRON Node

Open a **NEW terminal** and run:

```bash
bash scripts/start_node.sh
```

**Expected output:**
```
🚀 Starting TRON Local Fork Node
✅ Node config created
🔧 Starting FullNode...
   RPC: http://localhost:8090
   P2P: localhost:18888
```

**Note:** Keep this terminal open. The node must stay running!

---

## Step 4: Test the RPC Connection

Open **ANOTHER NEW terminal** and run:

```bash
bash scripts/test_rpc.sh
```

**Expected output:**
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x1"
}
```

If you see this, your node is running perfectly! ✅

---

## Step 5: Extract Your Wallet Data

Run this command to extract wallet details for use in your dApp/wallet:

```bash
python3 << 'EOF'
import json

# Load wallet data
with open("wallet_stats/wallet_stats.json", "r") as f:
    data = json.load(f)

print("\n" + "="*70)
print("TEST WALLETS - COPY THESE INTO YOUR WALLET")
print("="*70 + "\n")

for wallet_name, wallet_info in data["wallets"].items():
    print(f"📝 {wallet_name.upper()}")
    print(f"   Address:     {wallet_info['address']}")
    print(f"   Private Key: {wallet_info['private_key']}")
    print(f"   Balance:     {wallet_info['balance_trx']} TRX")
    print()

print("="*70)
print("ROC NODES - FOR RUNNING WITNESS NODES")
print("="*70 + "\n")

for node_name, node_info in data["roc_nodes"].items():
    print(f"🔗 {node_name.upper()}")
    print(f"   Address:  {node_info['address']}")
    print(f"   RPC URL:  {node_info['rpc_url']}")
    print(f"   Private Key: {node_info['private_key']}")
    print()

print("="*70)
print("NETWORK ENDPOINTS")
print("="*70 + "\n")
print(f"Primary RPC:  {data['network_endpoints']['primary']}")
print(f"Chain ID:     {data['network_endpoints']['chain_id']}")
print(f"Currency:     {data['network_endpoints']['currency']}\n")

EOF
```

---

## Step 6: Configure TRONLINK Wallet (Chrome Extension)

### 6A. Import Wallet 1

1. **Open TRONLINK** in your browser
2. Click **"Create/Import Wallet"**
3. Select **"Import Private Key"**
4. Paste the **private key from wallet_1**
5. Give it a name: `Local Test Wallet 1`
6. Save password and confirm

### 6B. Add Custom Network

1. Click **Settings** ⚙️ in TRONLINK
2. Go to **"Networks"**
3. Click **"Add Custom Network"**
4. Fill in:
   ```
   Network Name: Local TRON Fork
   RPC URL: http://localhost:8090
   Chain ID: 728126428
   Currency Symbol: TRX
   ```
5. Click **"Save"**

### 6C. Switch to Local Network

1. In TRONLINK, click the **network dropdown**
2. Select **"Local TRON Fork"**
3. You should see your balance: **99,999,999 TRX** ✅

---

## Step 7: Import Additional Test Wallets

Repeat Step 6A for wallet_2 and wallet_3 using their private keys from `wallet_stats/wallet_stats.json`.

---

## Step 8: Verify Everything Works

### 8A. Check Balance in TRONLINK
- Switch to each wallet
- You should see **99,999,999 TRX** in each one

### 8B. Send a Test Transaction

1. In TRONLINK, select **Wallet 1**
2. Click **"Send"**
3. Enter Wallet 2's address
4. Amount: `10` TRX
5. Click **"Send"**
6. Should complete instantly with no gas fees! ✅

### 8C. Verify Using RPC

```bash
curl -X POST http://localhost:8090 \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc":"2.0",
    "method":"eth_getBalance",
    "params":["0x...ADDRESS...","latest"],
    "id":1
  }' | jq .
```

---

## Step 9: Deploy Your Smart Contracts

Now you can deploy contracts using:

```bash
# Using Hardhat
npx hardhat deploy --network local-tron

# Using Truffle
truffle migrate --network local-tron

# Using ethers.js directly
const provider = new ethers.providers.JsonRpcProvider('http://localhost:8090');
const wallet = new ethers.Wallet('0x...PRIVATE_KEY...', provider);
```

---

## 📊 Configuration Summary

| Item | Value |
|------|-------|
| Primary RPC | `http://localhost:8090` |
| Chain ID | `728126428` |
| Currency | `TRX` |
| Wallets | 3 (each with 99,999,999 TRX) |
| ROC Nodes | 5 (witness nodes) |
| Gas Fees | FREE ✅ |
| Risk Level | ZERO (testnet only) |

---

## 🆘 Troubleshooting

### Issue: "Cannot connect to RPC"
**Solution:** Make sure the node is running with `bash scripts/start_node.sh`

### Issue: "Invalid private key format"
**Solution:** Make sure to copy the FULL private key, including the `0x` prefix

### Issue: "Wallet shows 0 balance"
**Solution:** 
1. Make sure you switched to the "Local TRON Fork" network
2. Refresh TRONLINK
3. Make sure you ran `bash scripts/run_all_setup.sh` completely

### Issue: "Transaction failed"
**Solution:** 
1. Check node is running
2. Verify you're on the local network
3. Check you have enough TRX (should be 99M+)

---

## ✅ Next Steps After Setup

1. **Test with your dApp** - Point your app to `http://localhost:8090`
2. **Deploy contracts** - Use the wallet as deployer
3. **Run integration tests** - All gas is free!
4. **Debug contracts** - Use local node for instant debugging

---

**You now have a complete local TRON development environment! 🎉**
