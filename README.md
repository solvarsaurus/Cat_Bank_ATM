# CAT BANK ATM - COBOL Implementation

A retro-style ATM system written in COBOL with a cat theme. Manage accounts, check balances, deposit and withdraw funds with a cat-themed interface.

## Features

- **Idle Screen**: Welcome display with ASCII art
- **User Authentication**: Account number and PIN validation
- **Account Management**: 
  - Balance inquiry
  - Deposit funds
  - Withdraw funds
- **Session Management**: Login/logout with secure card ejection
- **System Shutdown**: Graceful system power-down

## Test Accounts

| Account | PIN  | Name          | Balance    |
|---------|------|---------------|------------|
| 12345   | 1111 | MR. WHISKERS  | $1,000.50  |
| 88888   | 1985 | DR. E. BROWN  | $5,000,000.00 |
| 54321   | 0000 | MARTY MCFLY   | $10.00     |

## Usage

### Starting the Program
```
cobol ATM.cob
./ATM
```

### Main Flow

1. **Idle Screen** - Press ENTER to start or 9 to shutdown
2. **Login** - Enter account number (5 digits) and PIN (4 digits)
3. **Main Menu** - Select operation:
   - `1` - Check balance
   - `2` - Deposit funds
   - `3` - Withdraw funds
   - `4` - Logout and eject card
   - `9` - Shutdown system

### Operations

**Balance Inquiry**
- Displays current account balance in currency format

**Deposit Funds**
- Enter amount to add to account
- Balance updates immediately

**Withdraw Funds**
- Enter amount to withdraw
- System validates sufficient funds
- Displays updated balance

**Logout**
- Ejects card and returns to idle screen
- Can login with different account

## Program Structure

```
MAIN-LOGIC
├── INIT-DB (Initialize test accounts)
├── DISPLAY-IDLE-SCREEN (Welcome screen)
├── LOGIN-SCREEN (Authentication)
│   └── AUTHENTICATE-USER (Verify credentials)
├── MAIN-MENU (Transaction menu)
│   ├── SHOW-BALANCE
│   ├── DEPOSIT-FUNDS
│   ├── WITHDRAW-FUNDS
│   └── LOGOUT-USER
└── System Shutdown
```

## Data Structure

**Account Database**
- Account Number (5 digits)
- PIN (4 digits)
- Balance (7 digits + 2 decimals)
- Name (20 characters)

**Session State**
- Current user index
- Login status
- Shutdown flag

## Error Handling

- Invalid account format detection
- Invalid PIN format detection
- Insufficient funds validation
- Invalid menu selection handling
- Invalid amount input validation

## Security Features

- PIN-based authentication
- Session state management
- Secure logout with card ejection
- Input validation on all numeric fields

## Customization

### Add New Accounts
Edit `INIT-DB` section to add more test accounts:
```cobol
MOVE 99999 TO DB-ACCT-NUM(4)
MOVE 2024  TO DB-PIN(4)
MOVE 5000.00 TO DB-BALANCE(4)
MOVE "YOUR NAME           " TO DB-NAME(4)
```

### Modify Account Limits
Change `ACCOUNT-DB OCCURS` value to support more accounts

### Adjust Balance Format
Modify `DISPLAY-MONEY PIC $$$$,$$9.99` for different currency display

## Author

ANDY - SOLVARSAURUS GITHUB

