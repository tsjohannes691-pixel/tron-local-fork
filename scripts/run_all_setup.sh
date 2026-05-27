#!/bin/bash
set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     TRON LOCAL FORK - COMPLETE SETUP AUTOMATION              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Setup Fork
echo "📍 STEP 1: Setting up TRON fork with test wallets..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash scripts/setup_fork.sh
echo ""

# Step 2: Setup ROC Nodes
echo ""
echo "📍 STEP 2: Generating ROC nodes and network configuration..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash scripts/setup_roc_nodes.sh
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
echo "   ✅ wallets.json                    - Test wallet credentials"
echo "   ✅ fork.conf                       - Fork configuration"
echo "   ✅ roc_nodes/roc_nodes.json        - ROC node details"
echo "   ✅ roc_nodes/network_config.json   - Complete network setup"
echo "   ✅ roc_nodes/node_*_config.conf    - Individual node configs"
echo "   ✅ wallet_stats/wallet_stats.json  - Detailed statistics"
echo "   ✅ wallet_stats/WALLET_REPORT.txt  - Human-readable report"
echo "   ✅ wallet_stats/quick_reference.csv - Quick lookup"
echo ""
echo "🚀 Next Steps:"
echo ""
echo "   1️⃣  Start the primary node:"
echo "       bash scripts/start_node.sh"
echo ""
echo "   2️⃣  In another terminal, test the RPC:"
echo "       bash scripts/test_rpc.sh"
echo ""
echo "   3️⃣  View wallet/ROC node info:"
echo "       cat wallet_stats/WALLET_REPORT.txt"
echo ""
echo "   4️⃣  Use wallet data in your dApp:"
echo "       cat wallet_stats/wallet_stats.json"
echo ""
echo "🔧 Ready to deploy contracts and test on local TRON!"
echo ""
