#!/bin/bash
set -e

echo "🚀 TRON Local Fork Setup"
echo "======================="

# Check if JAR files exist
if [ ! -f "Toolkit.jar" ]; then
  echo "📥 Downloading Toolkit.jar..."
  wget -O Toolkit.jar "https://github.com/tronprotocol/tron-docker/releases/download/GreatVoyage-4.7.3/Toolkit.jar" 2>/dev/null || \
  wget -O Toolkit.jar "https://github.com/tronprotocol/tron-docker/releases/latest/download/Toolkit.jar"
fi

if [ ! -f "FullNode.jar" ]; then
  echo "📥 Downloading FullNode.jar..."
  wget -O FullNode.jar "https://github.com/tronprotocol/java-tron/releases/latest/download/FullNode.jar"
fi

echo "✅ JAR files ready"

# Generate wallets
echo ""
echo "🔑 Generating test wallets..."
python3 << 'PYTHON_EOF'
import json
from tronpy.keys import PrivateKey

# Generate 3 test wallets
wallets = {}
for i in range(1, 4):
    pk = PrivateKey.random()
    address = pk.public_key.to_base58check_address()
    wallets[f"wallet_{i}"] = {
        "address": address,
        "private_key": pk.hex()
    }
    print(f"Wallet {i}:")
    print(f"  Address:     {address}")
    print(f"  Private Key: {pk.hex()}")
    print()

# Save to file
with open("wallets.json", "w") as f:
    json.dump(wallets, f, indent=2)

print("✅ Wallets saved to wallets.json")
PYTHON_EOF

# Create fork.conf
echo ""
echo "📝 Creating fork.conf..."
python3 << 'PYTHON_EOF'
import json
from tronpy.keys import PrivateKey

# Load wallets
with open("wallets.json", "r") as f:
    wallets = json.load(f)

pk1_addr = wallets["wallet_1"]["address"]
pk2_addr = wallets["wallet_2"]["address"]

conf = f'''witnesses = [
  {{ address = "{pk1_addr}", url = "http://localhost:8090", voteCount = 100000036 }}
]

accounts = [
  {{ address = "{pk1_addr}", accountName = "Wallet1", balance = 99999999000000000 }},
  {{ address = "{pk2_addr}", accountName = "Wallet2", balance = 99999999000000000 }},
  {{ address = "TLsV52sRDL79HXGGm9yzwKwp7V98p5qZo7", accountName = "Wallet3", balance = 99999999000000000 }}
]

trc20Contracts = [
  {{ contractAddress = "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t", balancesSlotPosition = 0, address = "{pk1_addr}", balance = "999999000000000000" }},
  {{ contractAddress = "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t", balancesSlotPosition = 0, address = "{pk2_addr}", balance = "999999000000000000" }}
]

latestBlockHeaderTimestamp = 1735628883000
maintenanceTimeInterval = 21600000
nextMaintenanceTime = 1735628894000
'''

with open("fork.conf", "w") as f:
    f.write(conf.strip())

print("✅ fork.conf created")
PYTHON_EOF

# Apply fork to database
echo ""
echo "🔄 Applying fork to database..."
java -jar Toolkit.jar db fork -c fork.conf -d output-directory/database

echo ""
echo "✅ Fork setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Run: bash scripts/start_node.sh"
echo "   2. RPC endpoint: http://localhost:8090"
echo "   3. Check wallets in: wallets.json"