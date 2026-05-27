#!/bin/bash
set -e

echo "📊 TRON Wallet Statistics Generator"
echo "===================================="
echo ""

if [ ! -f "wallets.json" ]; then
    echo "❌ wallets.json not found. Run 'bash scripts/setup_fork.sh' first"
    exit 1
fi

# Generate wallet statistics
python3 << 'PYTHON_EOF'
import json
import os
from datetime import datetime
from pathlib import Path

# Create stats directory
Path("wallet_stats").mkdir(exist_ok=True)

# Load wallets and ROC nodes
with open("wallets.json", "r") as f:
    wallets = json.load(f)

roc_nodes = {}
if os.path.exists("roc_nodes/roc_nodes.json"):
    with open("roc_nodes/roc_nodes.json", "r") as f:
        roc_nodes = json.load(f)

# Calculate total values
total_trx = 0
total_wallets = len(wallets)
total_roc_nodes = len(roc_nodes)

# Create detailed wallet report
wallet_stats = {
    "generated_at": datetime.now().isoformat(),
    "summary": {
        "total_wallets": total_wallets,
        "total_roc_nodes": total_roc_nodes,
        "total_nodes": total_wallets + total_roc_nodes,
        "trx_per_wallet": 99999999,
        "total_trx_allocated": total_wallets * 99999999,
        "usdt_per_wallet": 999999000000000000,
        "network_type": "local_testnet"
    },
    "wallets": {},
    "roc_nodes": {},
    "network_endpoints": {
        "primary": "http://localhost:8090",
        "chain_id": 728126428,
        "currency": "TRX"
    }
}

# Add wallet details
for wallet_name, wallet_data in wallets.items():
    wallet_stats["wallets"][wallet_name] = {
        "address": wallet_data["address"],
        "private_key": wallet_data["private_key"],
        "balance_trx": 99999999,
        "balance_usdt": "999999000000000000",
        "status": "active",
        "transactions": 0,
        "created_at": datetime.now().isoformat()
    }

# Add ROC node details
for node_name, node_data in roc_nodes.items():
    node_num = node_name.split("_")[-1]
    wallet_stats["roc_nodes"][node_name] = {
        "address": node_data["address"],
        "private_key": node_data["private_key"],
        "p2p_port": node_data["p2p_port"],
        "rpc_port": node_data["rpc_port"],
        "rpc_url": f"http://localhost:{node_data['rpc_port']}",
        "role": node_data["role"],
        "status": node_data["status"],
        "vote_count": node_data["vote_count"],
        "balance_trx": 99999999
    }

# Save wallet stats
with open("wallet_stats/wallet_stats.json", "w") as f:
    json.dump(wallet_stats, f, indent=2)

# Create human-readable report
report = f"""
╔════════════════════════════════════════════════════════════════════╗
║        TRON LOCAL FORK - WALLET & NODE STATISTICS REPORT          ║
╚════════════════════════════════════════════════════════════════════╝

📅 Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

┌─ NETWORK SUMMARY ─────────────────────────────────────────────────┐
│ Total Wallets:          {total_wallets}
│ Total ROC Nodes:        {total_roc_nodes}
│ Total Network Nodes:    {total_wallets + total_roc_nodes}
│ Chain ID:               728126428
│ Currency:               TRX
│ Network Type:           Local Testnet (No mainnet risk)
└───────────────────────────────────────────────────────────────────┘

┌─ TEST WALLETS ────────────────────────────────────────────────────┐
"""

for i, (wallet_name, wallet_data) in enumerate(wallets.items(), 1):
    report += f"""│ 
│ [{i}] {wallet_name.upper()}
│     Address:  {wallet_data['address']}
│     Balance:  99,999,999 TRX + 999,999 USDT
│     Private:  {wallet_data['private_key'][:20]}...
"""

if roc_nodes:
    report += """└───────────────────────────────────────────────────────────────────┘

┌─ ROC NODES (WITNESS NODES) ───────────────────────────────────────┐
"""
    for i, (node_name, node_data) in enumerate(roc_nodes.items(), 1):
        report += f"""│ 
│ [{i}] {node_name.upper()} - ACTIVE WITNESS
│     Address:   {node_data['address']}
│     RPC URL:   {f"http://localhost:{node_data['rpc_port']}"}
│     P2P Port:  {node_data['p2p_port']}
│     Votes:     {node_data['vote_count']}
│     Private:   {node_data['private_key'][:20]}...
"""

report += """└───────────────────────────────────────────────────────────────────┘

┌─ NETWORK ENDPOINTS ───────────────────────────────────────────────┐
│ Primary Node:        http://localhost:8090
"""

if roc_nodes:
    for i in range(1, len(roc_nodes) + 1):
        report += f"│ ROC Node {i}:          http://localhost:{8090 + i}\n"

report += """└───────────────────────────────────────────────────────────────────┘

┌─ QUICK START COMMANDS ────────────────────────────────────────────┐
│ 1. Start Primary Node:
│    bash scripts/start_node.sh
│
│ 2. Test RPC Connection:
│    bash scripts/test_rpc.sh
│
│ 3. View this report:
│    cat wallet_stats/wallet_stats.json
│
│ 4. Connect to ROC Nodes:
│    - Use RPC URLs above in your dApp
│    - Import private keys into TRON wallets
│
│ 5. Deploy Contracts:
│    - Use primary node RPC: http://localhost:8090
│    - Gas is free in testnet mode
└───────────────────────────────────────────────────────────────────┘

✅ All wallets and ROC nodes are configured and ready to use!
"""

with open("wallet_stats/WALLET_REPORT.txt", "w") as f:
    f.write(report)

print(report)

# Create quick reference CSV
csv_content = "Name,Type,Address,RPC_URL,Balance_TRX,Status\n"

for wallet_name, wallet_data in wallets.items():
    csv_content += f'{wallet_name},wallet,{wallet_data["address"]},N/A,99999999,active\n'

for node_name, node_data in roc_nodes.items():
    csv_content += f'{node_name},roc_node,{node_data["address"]},http://localhost:{node_data["rpc_port"]},99999999,active\n'

with open("wallet_stats/quick_reference.csv", "w") as f:
    f.write(csv_content)

print("\n✅ Statistics files created:")
print("   - wallet_stats/wallet_stats.json (detailed config)")
print("   - wallet_stats/WALLET_REPORT.txt (formatted report)")
print("   - wallet_stats/quick_reference.csv (quick lookup)")

PYTHON_EOF
