#!/bin/bash

echo "🧪 Testing TRON RPC Endpoint"
echo "============================"
echo ""

RPC_URL="http://localhost:8090"

echo "📍 Testing connection to: $RPC_URL"
echo ""

# Test 1: Get block number
echo "Test 1: Get current block number"
curl -s -X POST "$RPC_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq .

echo ""

# Test 2: Get chain ID
echo "Test 2: Get chain ID"
curl -s -X POST "$RPC_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' | jq .

echo ""

# Test 3: Get gas price
echo "Test 3: Get gas price"
curl -s -X POST "$RPC_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_gasPrice","params":[],"id":1}' | jq .

echo ""
echo "✅ RPC tests complete"