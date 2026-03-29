# Banking System

A Python-based banking system project designed to demonstrate core banking operations and financial management principles.

## Overview

This Banking System is a comprehensive solution for managing bank accounts, transactions, and customer information. It provides a foundation for understanding how banking operations work at the software level.

## Features

- **Account Management**: Create and manage multiple bank accounts
- **Transaction Processing**: Deposit, withdrawal, and transfer operations
- **Balance Tracking**: Real-time balance updates and account status
- **Transaction History**: View complete transaction logs for audit trails
- **User Authentication**: Secure login and account access control
- **Interest Calculation**: Automatic interest accrual on savings accounts

## Requirements

- Python 3.8 or higher
- pip (Python package installer)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/kimoo12343/Banking-System.git
cd Banking-System
```

2. Install required dependencies:
```bash
pip install -r requirements.txt
```

3. Run the application:
```bash
python main.py
```

## Usage

### Creating an Account

```python
from banking_system import BankAccount

account = BankAccount(
    account_number="1001",
    account_holder="John Doe",
    initial_balance=1000.00
)
```

### Performing Transactions

```python
# Deposit money
account.deposit(500.00)

# Withdraw money
account.withdraw(200.00)

# Check balance
print(account.get_balance())
```

### Transferring Funds

```python
account1.transfer_to(account2, 100.00)
```

## Project Structure

```
Banking-System/
├── main.py              # Entry point of the application
├── banking_system/      # Main package
│   ├── __init__.py
│   ├── account.py       # Bank account classes
│   ├── transaction.py   # Transaction handling
│   ├── user.py          # User authentication
│   └── utils.py         # Utility functions
├── tests/               # Unit tests
├── requirements.txt     # Project dependencies
└── README.md            # This file
```

## Architecture

The system is built using object-oriented principles with the following main components:

- **BankAccount**: Manages account data and operations
- **Transaction**: Handles transaction records and logging
- **User**: Manages user authentication and profiles
- **Bank**: Central controller for all banking operations

## API Reference

### BankAccount Class

- `deposit(amount)` - Add funds to account
- `withdraw(amount)` - Remove funds from account
- `transfer_to(target_account, amount)` - Transfer funds to another account
- `get_balance()` - Returns current account balance
- `get_transaction_history()` - Returns list of all transactions

## Testing

Run the test suite:

```bash
python -m pytest tests/
```

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions or support, please reach out to [your-email@example.com](mailto:your-email@example.com).

## Disclaimer

This is a sample banking system for educational purposes only and should not be used for real banking operations without proper security audits and compliance reviews.
