# 🔗 TronLink Wallet Integration Guide

This guide shows how to connect **TronLink Wallet** to your **local TRON fork** running in GitHub Codespaces.

## Why TronLink?

| Feature | Details |
|---------|---------|
| **TRON Native** | Built specifically for TRON blockchain |
| **Custom RPC** | Supports custom RPC endpoints |
| **Local Testing** | Can connect to localhost/Codespaces |
| **Private Key Import** | Use pre-generated test wallets |
| **Browser Extension** | Works with Chrome, Firefox, Brave, Edge |

---

## Prerequisites

✅ Local TRON fork running and accessible  
✅ TronLink browser extension installed  
✅ Test wallets from `wallets.json`  

---

## Step 1: Install TronLink

### Download & Install

1. **Chrome/Brave/Edge:**
   - Visit: https://chromewebstore.google.com/detail/tronlink/ibnejojhbbbfbmogeijolaomcnelhbah
   - Click "Add to Chrome"

2. **Firefox:**
   - Visit: https://addons.mozilla.org/firefox/addon/tronlink/
   - Click "Add to Firefox"

3. **Or manually:**
   - Download from: https://www.tronlink.org/
   - Extract and load as unpacked extension

### Create Wallet/Password

1. Open TronLink extension (top-right corner)
2. Click "Create Account"
3. Set a **password** (for this local testing)
4. ⚠️ Save the seed phrase (even though it's test-only)

---

## Step 2: Get Your Local Fork RPC

### Check Your Codespaces Setup

```bash
# Make sure your TRON node is running
bash scripts/start_node.sh

# In another terminal, test the RPC
bash scripts/test_rpc.sh
```

### Get the Public RPC URL (Codespaces)

If running in GitHub Codespaces:

1. Look for the **"Ports"** tab in Codespaces
2. Find port **8090** (TRON RPC)
3. Click the **globe icon** → copy the public URL
4. It will look like: `https://your-codespace-abc123.preview.app:8090`

If running **locally**:
- Use: `http://localhost:8090`

---

## Step 3: Add Custom Network in TronLink

### Open TronLink Settings

1. Click the **TronLink extension icon**
2. Click the **⚙️ Settings icon** (top-right)
3. Select **"Network"**

### Add New Network

1. Click **"Custom Network"** or **"Add Network"**
2. Fill in the details:

```
Network Name:        Local TRON Fork
RPC URL:            http://localhost:8090 (or your Codespaces URL)
Chain ID:           728126428
Currency Symbol:    TRX
Block Explorer URL: (leave blank for now)
```

3. Click **"Save"** or **"Add Network"**

### Example Screenshot Flow

```
TronLink Menu
    ↓
Settings
    ↓
Network
    ↓
Add Custom Network
    ↓
Enter Details (see above)
    ↓
Save
    ↓
Switch to "Local TRON Fork"
```

---

## Step 4: Import Test Wallet

### Get Private Key from wallets.json

```bash
# In your repo root, check the generated wallets
cat wallets.json
```

Output example:
```json
{
  "wallet_1": {
    "address": "T...",
    "private_key": "0x..."
  }
}
```

### Import into TronLink

1. Click **TronLink extension icon**
2. Click **Profile icon** (top-right) → **"Import Account"**
3. Select **"Import from private key"**
4. Paste the **private key** from `wallets.json` (without `0x` prefix)
5. Give it a name: **"Test Wallet 1"**
6. Click **"Import"**

---

## Step 5: Verify Connection

### Check Wallet Balance

1. Switch to **"Local TRON Fork"** network (if not already)
2. Your wallet should show:
   - ✅ **Balance:** ~100 million TRX (or whatever you set in fork.conf)
   - ✅ **Network:** "Local TRON Fork"
   - ✅ **Status:** Connected ✓

### Send a Test Transaction

1. Click **"Send"**
2. Recipient: Use wallet_2 address (from wallets.json)
3. Amount: **1 TRX**
4. Click **"Send"**
5. Confirm the transaction

Expected result:
- ✅ Transaction appears in TronLink
- ✅ Balances update immediately (instant finality on local fork)

---

## Step 6: Troubleshooting

### Issue: "Cannot connect to RPC"

**Solution 1: Check if node is running**
```bash
# Make sure TRON node is running
ps aux | grep FullNode.jar

# If not running, start it
bash scripts/start_node.sh
```

**Solution 2: Verify RPC URL**
- In Codespaces? Use the public forwarded URL from Ports tab
- Localhost? Use `http://localhost:8090`
- Test with curl:
  ```bash
  curl -X POST http://localhost:8090 \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
  ```

### Issue: "Invalid Chain ID"

**Solution:** Make sure Chain ID is **728126428** (TRON mainnet ID)

### Issue: Wallet shows 0 balance

**Solution 1:** Check you're on correct network
```bash
# Verify network in TronLink
TronLink → Network → Select "Local TRON Fork"
```

**Solution 2:** Verify wallet was imported with correct private key
```bash
# Check wallets.json matches imported address
cat wallets.json | grep -A2 "wallet_1"
```

**Solution 3:** Re-run fork setup
```bash
bash scripts/setup_fork.sh
bash scripts/start_node.sh
```

---

## Advanced: Multiple Wallets

### Import All 3 Test Wallets

```bash
# Extract all wallets from wallets.json
cat wallets.json
```

For each wallet:
1. TronLink → Profile → Import Account
2. Paste private key
3. Name it (Wallet 1, Wallet 2, Wallet 3)
4. Click Import

Now you can:
- ✅ Switch between wallets
- ✅ Send TRX between them
- ✅ Test multi-wallet scenarios
- ✅ Test smart contract interactions

---

## Use Cases

### 1. Test Smart Contract Interactions

```bash
# Deploy contract with Wallet 1
# Then interact with Wallet 2 in TronLink
# See transactions in real-time
```

### 2. Test Token Transfers

```bash
# USDT is pre-allocated to both wallets
# Send USDT from Wallet 1 → Wallet 2
# Verify token balance changes
```

### 3. Test Multi-sig or DAO Scenarios

```bash
# Use different wallets for different roles
# Test voting, proposals, etc.
```

### 4. Debug Transaction Issues

```bash
# View transaction details in TronLink
# See gas usage, status, logs
# Compare with blockchain explorer
```

---

## Security Notes

⚠️ **These wallets are for LOCAL TESTING ONLY**

- ✅ Safe to use locally on your machine
- ✅ Safe in Codespaces (private container)
- ❌ NEVER use these private keys on mainnet
- ❌ NEVER use these private keys on testnet
- ❌ NEVER share these private keys publicly

---

## Next Steps

1. ✅ Install TronLink
2. ✅ Add "Local TRON Fork" network
3. ✅ Import test wallets
4. ✅ Send test transactions
5. 🚀 Deploy and test smart contracts
6. 📊 Monitor transactions in TronLink

---

## Useful Links

- **TronLink Official:** https://www.tronlink.org/
- **TRON Documentation:** https://tronprotocol.org/
- **JsontRPC Methods:** https://tronprotocol.github.io/doc/rpc/
- **GitHub Codespaces:** https://docs.github.com/en/codespaces

---

## Questions?

If you run into issues:

1. Check that your TRON node is running: `ps aux | grep FullNode.jar`
2. Test RPC connectivity: `bash scripts/test_rpc.sh`
3. Verify wallets exist: `cat wallets.json`
4. Check TronLink network settings match your RPC URL

Happy testing! 🎉
