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
    print(f"   Address:    {wallet['address']}")
    print(f"   Private Key: {wallet['private_key']}")
    print(f"   Balance:    {wallet['balance_trx']} TRX")
    print(f"   Status:     {wallet['status']}")
    print("")

print("=" * 70)
print("🌐 NETWORK CONFIGURATION")
print("=" * 70)
print("")
print(f"Primary RPC URL:  {data['network_endpoints']['primary']}")
print(f"Chain ID:         {data['network_endpoints']['chain_id']}")
print(f"Currency Symbol:  {data['network_endpoints']['currency']}")
print("")

print("=" * 70)
print("🔗 ROC NODES (WITNESS NODES)")
print("=" * 70)
print("")

for i, (node_name, node) in enumerate(data['roc_nodes'].items(), 1):
    print(f"🟢 ROC NODE {i}")
    print(f"   Address:    {node['address']}")
    print(f"   RPC URL:    {node['rpc_url']}")
    print(f"   P2P Port:   {node['p2p_port']}")
    print(f"   Private Key: {node['private_key']}")
    print("")

print("=" * 70)
print("✅ NEXT STEPS:")
print("=" * 70)
print("")
print("1. Terminal 2 - Start the Node:")
print("   bash scripts/start_node.sh")
print("")
print("2. Terminal 3 - Test RPC:")
print("   bash scripts/test_rpc.sh")
print("")
print("3. Install TRONLINK Chrome Extension")
print("")
print("4. Import wallets using Private Keys above")
print("")
print("5. Add Network in TRONLINK:")
print("   Name: Local TRON Fork")
print(f"   RPC: {data['network_endpoints']['primary']}")
print(f"   Chain ID: {data['network_endpoints']['chain_id']}")
print("")
print("6. Switch to Local TRON Fork network")
print("")
print("7. You'll see 99,999,999 TRX in each wallet! 🎉")
print("")

PYSCRIPT

echo "🎉 All setup complete! Copy the details above and use them in TRONLINK."
echo ""
