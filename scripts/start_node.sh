#!/bin/bash
set -e

echo "🚀 Starting TRON Local Fork Node"
echo "================================"

# Check if fork.conf exists
if [ ! -f "fork.conf" ]; then
  echo "❌ fork.conf not found. Run 'bash scripts/setup_fork.sh' first"
  exit 1
fi

# Create node config
cat > node_config.conf << 'CONF'
needSyncCheck = false
minParticipationRate = 0
minEffectiveConnection = 0
node.p2p.version = 202599
node.http.fullNodePort = 8090
node.listen.port = 18888

storage {
  dbDirectory = "output-directory/database"
  indexDirectory = "output-directory/index"
}
CONF

echo "✅ Node config created"
echo ""
echo "🔧 Starting FullNode..."
echo "   RPC: http://localhost:8090"
echo "   P2P: localhost:18888"
echo ""
echo "Press Ctrl+C to stop the node"
echo ""

java -Xmx2g -jar FullNode.jar --witness -c node_config.conf