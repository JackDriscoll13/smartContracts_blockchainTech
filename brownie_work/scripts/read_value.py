from brownie import SimpleStorage, accounts, config 

def read_contract():
    contract = SimpleStorage[-1] # read the contract at the most recent instance
    print(contract)
    print(contract.retrieve())

def main():
    read_contract()
