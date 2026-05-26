#!/usr/bin/env python3
"""
Simple script to deploy a contract to local TRON fork
"""

import json
import sys
from web3 import Web3

# Load wallets
with open("wallets.json", "r") as f:
    wallets = json.load(f)

# Connect to local TRON node
RPC_URL = "http://localhost:8090"
w3 = Web3(Web3.HTTPProvider(RPC_URL))

if not w3.is_connected():
    print("❌ Cannot connect to TRON node at", RPC_URL)
    print("Make sure the node is running: bash scripts/start_node.sh")
    sys.exit(1)

print("✅ Connected to TRON node")
print(f"   Chain ID: {w3.eth.chain_id}")
print(f"   Block number: {w3.eth.block_number}")
print()

# Get test account
test_account = wallets["wallet_1"]
account_address = test_account["address"]
account_key = test_account["private_key"]

print(f"📝 Using account: {account_address}")
print(f"   Balance: {w3.eth.get_balance(account_address)} wei")
print()

# Simple ERC20 contract bytecode (minimal)
contract_bytecode = "0x6080604052"
contract_abi = json.loads('[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"}]')

print("📝 Contract bytecode:")
print(f"   {contract_bytecode}")
print()

print("💡 Tip: Use this RPC endpoint in your dApp:")
print(f"   {RPC_URL}")
print()
print("💡 Tip: Use these test wallets:")
for wallet_name, wallet_data in wallets.items():
    print(f"   {wallet_name}: {wallet_data['address']}")