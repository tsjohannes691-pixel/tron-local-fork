#!/bin/bash
set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     TRON LOCAL FORK - COMPLETE SETUP EXECUTION               ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check Python and required packages
echo "✅ Checking Python environment..."
python3 -c "import tronpy" 2>/dev/null || pip install tronpy

# Step 1: Setup Fork
echo ""
echo "📍 STEP 1: Setting up TRON fork with test wallets..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash scripts/setup_fork.sh 2>&1 | tail -20
echo ""

# Step 2: Setup ROC Nodes
echo ""
echo "📍 STEP 2: Generating ROC nodes and network configuration..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash scripts/setup_roc_nodes.sh 2>&1 | tail -30
echo ""

# Step 3: Generate Wallet Stats
echo ""
echo "📍 STEP 3: Generating wallet and node statistics..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash scripts/generate_wallet_stats.sh
echo ""

# Final Summary
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    ✅ SETUP COMPLETE!                         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📁 Generated Files:"
echo "   ✅ wallets.json"
echo "   ✅ fork.conf"
echo "   ✅ roc_nodes/roc_nodes.json"
echo "   ✅ roc_nodes/network_config.json"
echo "   ✅ wallet_stats/wallet_stats.json"
echo "   ✅ wallet_stats/WALLET_REPORT.txt"
echo "   ✅ wallet_stats/quick_reference.csv"
echo ""

# Show wallet report
echo "📋 Your Wallet Information:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat wallet_stats/WALLET_REPORT.txt
echo ""

# Extract and display wallet data in easy-to-copy format
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           COPY THESE WALLET DETAILS FOR YOUR WALLET          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

python3 << 'PYSCRIPT'
import json

with open('wallet_stats/wallet_stats.json', 'r') as f:
    data = json.load(f)

print("🔐 TEST WALLETS - IMPORT INTO TRONLINK")
print("=" * 70)
print("")

for i, (wallet_name, wallet) in enumerate(data['wallets'].items(), 1):
    print(f"📌 WALLET {i} - {wallet_name.upper()}")
    print(f"   Address:      {wallet['address']}")
    print(f"   Private Key:  {wallet['private_key']}")
    print(f"   Balance:      {wallet['balance_trx']} TRX")
    print(f"   Status:       {wallet['status']}")
    print("")

print("=" * 70)
print("🌐 NETWORK CONFIGURATION FOR TRONLINK")
print("=" * 70)
print("")
print(f"RPC URL:      {data['network_endpoints']['primary']}")
print(f"Chain ID:     {data['network_endpoints']['chain_id']}")
print(f"Symbol:       {data['network_endpoints']['currency']}")
print("")

print("=" * 70)
print("🔗 ROC WITNESS NODES")
print("=" * 70)
print("")

for i, (node_name, node) in enumerate(data['roc_nodes'].items(), 1):
    print(f"🟢 ROC NODE {i}")
    print(f"   Address:      {node['address']}")
    print(f"   RPC URL:      {node['rpc_url']}")
    print(f"   P2P Port:     {node['p2p_port']}")
    print(f"   Private Key:  {node['private_key']}")
    print("")

print("=" * 70)
print("✅ CONFIGURATION STEPS")
print("=" * 70)
print("")
print("STEP 1: Start Node (Terminal 2)")
print("   bash scripts/start_node.sh")
print("")
print("STEP 2: Test RPC (Terminal 3)")
print("   bash scripts/test_rpc.sh")
print("")
print("STEP 3: Install TRONLINK Chrome Extension")
print("")
print("STEP 4: Import Wallet in TRONLINK")
print("   - Click 'Create/Import Wallet'")
print("   - Select 'Import Private Key'")
print("   - Paste: Wallet 1 Private Key above")
print("")
print("STEP 5: Add Network in TRONLINK")
print("   - Click Settings ⚙️")
print("   - Go to Networks")
print("   - Click Add Custom Network")
print("   - Fill in:")
print("      Network Name: Local TRON Fork")
print(f"      RPC URL: {data['network_endpoints']['primary']}")
print(f"      Chain ID: {data['network_endpoints']['chain_id']}")
print("      Currency Symbol: TRX")
print("   - Click Save")
print("")
print("STEP 6: Switch Network")
print("   - Click network dropdown in TRONLINK")
print("   - Select 'Local TRON Fork'")
print("")
print("STEP 7: Check Balance")
print("   - Should show: 99,999,999 TRX ✅")
print("")

PYSCRIPT

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          🎉 SETUP COMPLETE - YOU'RE READY TO GO!              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
