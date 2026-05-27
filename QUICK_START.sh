#!/bin/bash
# QUICK START - Copy and paste this entire file into your terminal

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║    TRON LOCAL FORK - COMPLETE SETUP IN ONE COMMAND            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Terminal 1: Run all setup
echo "📍 STEP 1: In Terminal 1, run the complete setup:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "bash scripts/run_all_setup.sh"
echo ""
echo "⏳ Wait for it to complete (5-10 minutes)..."
echo ""

sleep 2

echo "📋 After setup completes, check your wallet data:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "cat wallet_stats/WALLET_REPORT.txt"
echo ""

sleep 2

echo ""
echo "🚀 STEP 2: In Terminal 2, start the node:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "bash scripts/start_node.sh"
echo ""
echo "⏳ Wait until you see: '🔧 Starting FullNode...'"
echo ""

sleep 2

echo ""
echo "🧪 STEP 3: In Terminal 3, test the RPC:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "bash scripts/test_rpc.sh"
echo ""
echo "✅ If you see JSON response, RPC is working!"
echo ""

sleep 2

echo ""
echo "💼 STEP 4: Extract wallet data for your wallet:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "python3 << 'EXTRACT'"
echo "import json"
echo ""
echo "with open('wallet_stats/wallet_stats.json', 'r') as f:"
echo "    data = json.load(f)"
echo ""
echo "for wallet_name, wallet in data['wallets'].items():"
echo "    print(f'{wallet_name}:')"
echo "    print(f\"  Address: {wallet['address']}\")"
echo "    print(f\"  Private: {wallet['private_key']}\")"
echo "    print()"
echo "EXTRACT"
echo ""

sleep 2

echo ""
echo "🔐 STEP 5: Configure TRONLINK Wallet:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "   1. Install TRONLINK Chrome Extension"
echo "   2. Import test wallets using private keys from above"
echo "   3. Add custom network:"
echo "      - Name: Local TRON Fork"
echo "      - RPC: http://localhost:8090"
echo "      - Chain ID: 728126428"
echo "   4. Switch to 'Local TRON Fork' network"
echo "   5. You should see 99,999,999 TRX balance!"
echo ""

echo ""
echo "✅ EVERYTHING IS READY!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Generated Files:"
echo "   ✅ wallets.json - All wallet credentials"
echo "   ✅ fork.conf - Fork configuration"
echo "   ✅ roc_nodes/roc_nodes.json - ROC witness nodes"
echo "   ✅ wallet_stats/wallet_stats.json - Complete config"
echo "   ✅ wallet_stats/WALLET_REPORT.txt - Formatted report"
echo ""
echo "🎯 What's Next:"
echo "   1. Deploy smart contracts using http://localhost:8090"
echo "   2. Test transactions with unlimited free TRX"
echo "   3. Use TRONLINK to interact with your contracts"
echo "   4. No gas fees, no mainnet risk!"
echo ""
