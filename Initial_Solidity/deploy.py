#  Hi daddy, I'm home
# Read in simple storage file

# Import solc x compiler library
print("Importing Solx...")
from solcx import compile_standard, install_solc

print("Importing Web3...")
# Import web3.py
from web3 import Web3

print("Importing Json...")
import json

print("Importing dotenv...")
import os
from dotenv import load_dotenv

load_dotenv()

print("Reading SimpleStorage file...")
# Read in simple storage contract
with open("simpleStorage.sol", "r") as file:
    simple_storage_file = file.read()
    # print(simple_storage_file)

# Install necessary versions of solc
print("Installing and compiling...")
install_solc("0.8.0")


# Compile our solidity code from Solidity source code:
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
                }
            }
        },
    },
    solc_version="0.8.0",
)

# Take the solidity source code and save it in a file
# this is important because we will be looking at it and making changes to it
with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

# get bytecode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

print("Installed!")
# Now we have everything we need from the contract, we are going to deploy it. where? Genache - a fake blockchain
# connect to genache
print("Connecting to Genache....")
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))
chain_id = 1337
my_address = "0x50674C1df2e21d475aFef43C0aCCCF2966D9B195"
# NEVER HARD CODE YOUR PRIVATE KEY
print("Loading Enviormental Variables...")
private_key = os.getenv(
    "PRIVATE_KEY"
)  # always add 0x to front of private key python always looks for hexadecimal version
print("Loaded Private Key!")
print(str(private_key))

print("getting bytecode")
# Create a contract in python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)
# print(SimpleStorage)
print("bytecode secured!")
# Get the latest transaction count (nonce)
nonce = w3.eth.getTransactionCount(my_address)
# print(nonce)
print("connected to ganache!")
# Build a transaction
print("Deploying contract.....")
transaction = SimpleStorage.constructor().buildTransaction(
    {
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce,
    }  # not sure if i need chainID or what
)

# Sign a transaction
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
# Send a transaction
txn_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
# create transaction receipt
txn_reciept = w3.eth.wait_for_transaction_receipt(txn_hash)

print("Deployed!")
# After we have deployed the contract, how do we interact and work with the contract
# We need address and ABI

simple_storage = w3.eth.contract(address=txn_reciept.contractAddress, abi=abi)
# Call -> Simulate making the call and getting a return value (no state change)
# Transact -> Actually make a state change


print("Retrieving favorite number")
# call the retriive function from our contract
print(simple_storage.functions.retrieve().call())
# print(simple_storage.functions.store(15).call()) # THIS DOESN"T DO ANYTHING SINCE ITS JUST A CALL, It doesnt store anything, just simulates it

print("Updating favorite number...")
# when we do stuff to our contract, we have to make a transaction, so we build one:
store_transaction = simple_storage.functions.store(15).build_transaction(
    {"gasPrice": w3.eth.gas_price, "from": my_address, "nonce": nonce + 1}
)
signed_store_txn = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)
store_txn_hash = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(store_txn_hash)
print("Retrieving new favorite number...")
print(simple_storage.functions.retrieve().call())

print("All Done!")
