# put our account info (address and private key) into brownie:
# the accounts return a list of the genache cli accounts generated
# great for working with local networks (genache)
import os
from dotenv import load_dotenv
from brownie import accounts

# Import the config file
from brownie import config

# Import the simple storage contract
from brownie import SimpleStorage

# Import network from brownie
from brownie import network

# THE BEST, SAFEST WAY TO STORE ACCOUNT INFO:
# if we want to add acounts differntly like if we are using a testnet, we can add them directly
# We can add accounts directly into the terminal:
# brownie accounts new jacks-account


# Good practice is putting all logic in a seperate function and calling it in the main function


def deploy_simple_storage():
    account = get_account()
    # print("First Local Account:")
    # print(str(account))


    # We can access our brownie loaded accounts:
    # jacks_account = accounts.load("jacks-account")
    # print(jacks_account)

    # We can access our enviorment loaded accounts:
    # env_account = accounts.add(config["wallets"]["from_key"])
    # print("My account: " + str(env_account))

    # Deploy the simple storage contract from my account
    storage_contract = SimpleStorage.deploy({"from": account}) 
    print("Storage Contract:")
    print(storage_contract)

    # Now we want to recreate what we did in the web3 lesson with the retrieve function and the store function:
    # because retrieve is a view function we don't have to add an acocunt, it knows we are not making a state change
    stored_value = storage_contract.retrieve()
    print("Stored value: " + str(stored_value))
    # update stored value, since transaction making change need to add account
    transaction = storage_contract.store(25, {"from": account})
    transaction.wait(1)  # wait 1 block for the contract to update
    updated_stored_value = storage_contract.retrieve()
    print("Stored value: " + str(updated_stored_value))

    # But what if we want to deploy to test net? Brownie comes pre-packaged with a bunch of test nets
    # brownie networks list
    # We can get the netwrok npc or url with a enviorment variable ( from infura)
    # We can select the network when we run the script brownie run scripts/deploy.py --network rinkeby

# get account, if its not on the development network, pull from config and use infura link and rinkeby private key
def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else: 
        return accounts.add(config["wallets"]["from_key"])

def main():
    print("Running main:")
    deploy_simple_storage()
