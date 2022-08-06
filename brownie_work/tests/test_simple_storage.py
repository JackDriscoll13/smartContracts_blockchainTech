# Import the contract, and the accounts
from brownie import SimpleStorage, accounts


def test_deploy():
    # Arrange - set up all the critical pieces (get account to transact from)
    account = accounts[0]

    # Act - (deploy contract)
    storage_contract = SimpleStorage.deploy({"from": account})
    starting_value = storage_contract.retrieve()
    expected = 0
    # Assert
    # Assertiions should always be true. A way to test code. If false will terminate program
    assert starting_value == expected


def test_updating_storage():
    # Arrange:
    account = accounts[0]
    contract = SimpleStorage.deploy({"from": account})
    # Act:
    expected = 40
    contract.store(expected, {"from": account})
    # Assert
    assert expected == contract.retrieve()


# Some helpful testing tips:
# all brownie tests come from pytest
# brownie test -k (function name) -> test only one function
# brownie test --pdb -> kicks you into python shell to play around and see what variables are going on
# brownie test -s gives you more details on where your test went wrong
