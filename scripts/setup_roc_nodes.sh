#!/bin/bash
set -e

echo "🚀 TRON ROC (Rate of Change) Nodes Setup"
echo "=========================================="
echo ""

# Load existing wallets
if [ ! -f "wallets.json" ]; then
    echo "❌ wallets.json not found. Run 'bash scripts/setup_fork.sh' first"
    exit 1
fi

echo "📋 Generating ROC node configuration..."
echo ""

# Create ROC nodes setup script in Python
python3 << 'PYTHON_EOF'
import json
import os
from pathlib import Path

# Load existing wallets
with open("wallets.json", "r") as f:
    wallets = json.load(f)

# Create ROC nodes directory
roc_dir = Path("roc_nodes")
roc_dir.mkdir(exist_ok=True)

# Generate 5 additional ROC nodes
roc_nodes = {}
for i in range(1, 6):
    from tronpy.keys import PrivateKey
    
    pk = PrivateKey.random()
    address = pk.public_key.to_base58check_address()
    
    node_id = f"roc_node_{i}"
    roc_nodes[node_id] = {
        "address": address,
        "private_key": pk.hex(),
        "port": 18888 + i,
        "rpc_port": 8090 + i,
        "role": "witness",
        "status": "active",
        "vote_count": 100000000
    }
    
    print(f"✅ ROC Node {i}:")
    print(f"   Address:     {address}")
    print(f"   Private Key: {pk.hex()}")
    print(f"   P2P Port:    {18888 + i}")
    print(f"   RPC Port:    {8090 + i}")
    print()

# Save ROC nodes config
with open("roc_nodes/roc_nodes.json", "w") as f:
    json.dump(roc_nodes, f, indent=2)

# Create extended wallet configuration with ROC nodes
extended_config = {
    "primary_node": {
        "rpc_url": "http://localhost:8090",
        "p2p_port": 18888,
        "node_type": "primary"
    },
    "test_wallets": wallets,
    "roc_nodes": roc_nodes,
    "network_config": {
        "chain_id": 728126428,
        "currency_symbol": "TRX",
        "usdt_contract": "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t",
        "maintenance_interval": 21600000,
        "consensus": "PoS"
    }
}

# Save extended configuration
with open("roc_nodes/network_config.json", "w") as f:
    json.dump(extended_config, f, indent=2)

print("=" * 50)
print("✅ ROC Nodes Configuration Complete!")
print("=" * 50)
print("")
print("📁 Files created:")
print("   - roc_nodes/roc_nodes.json")
print("   - roc_nodes/network_config.json")
print("")

PYTHON_EOF

# Create node configuration files for each ROC node
python3 << 'PYTHON_EOF'
import json
from pathlib import Path

with open("roc_nodes/roc_nodes.json", "r") as f:
    roc_nodes = json.load(f)

# Create config files for each ROC node
for node_name, node_config in roc_nodes.items():
    node_num = node_name.split("_")[-1]
    
    # Create node-specific config
    node_conf = f"""# ROC Node {node_num} Configuration
needSyncCheck = false
minParticipationRate = 0
minEffectiveConnection = 0
node.p2p.version = 202599
node.http.fullNodePort = {node_config['rpc_port']}
node.listen.port = {node_config['p2p_port']}

storage {{
  dbDirectory = "output-directory/roc_node_{node_num}/database"
  indexDirectory = "output-directory/roc_node_{node_num}/index"
}}
"""
    
    config_path = Path("roc_nodes") / f"node_{node_num}_config.conf"
    with open(config_path, "w") as f:
        f.write(node_conf)
    
    print(f"✅ Created config for ROC Node {node_num} at {config_path}")

PYTHON_EOF

echo ""
echo "✅ ROC nodes setup complete!"
echo ""
echo "📊 Network Summary:"
echo "   Primary Node RPC:  http://localhost:8090"
echo "   ROC Node 1 RPC:    http://localhost:8091"
echo "   ROC Node 2 RPC:    http://localhost:8092"
echo "   ROC Node 3 RPC:    http://localhost:8093"
echo "   ROC Node 4 RPC:    http://localhost:8094"
echo "   ROC Node 5 RPC:    http://localhost:8095"
echo ""
echo "🔑 Configuration files:"
echo "   - roc_nodes/roc_nodes.json (all ROC node details)"
echo "   - roc_nodes/network_config.json (full network setup)"
