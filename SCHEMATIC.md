# CAT BANK ATM - Program Schematic

## System Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    PROGRAM START                            │
│                   (MAIN-LOGIC)                              │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │   Initialize Database  │
        │      (INIT-DB)         │
        │  Load 3 Test Accounts  │
        └────────────┬───────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │  Display Idle Screen   │
        │ (DISPLAY-IDLE-SCREEN)  │
        │  "WELCOME TO CAT BANK" │
        └────────────┬───────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
      [ENTER]                   [9]
         │                       │
         ▼                       ▼
    ┌─────────────┐      ┌──────────────┐
    │ LOGIN FLOW  │      │ SHUTDOWN     │
    └─────────────┘      │ SYSTEM       │
         │               └──────────────┘
         │                       │
         ▼                       ▼
    ┌──────────────────────────────────┐
    │  Enter Account Number (5 digits) │
    │  Enter PIN (4 digits)            │
    └────────────┬─────────────────────┘
                 │
         ┌───────┴────────┐
         │                │
      Valid          Invalid
         │                │
         ▼                ▼
    ┌─────────────┐  ┌──────────────┐
    │ Authenticate│  │ Error Message│
    │   User      │  │ Return to    │
    └────────┬────┘  │ Idle Screen  │
             │       └──────────────┘
         ┌───┴────┐
         │        │
      Match   No Match
         │        │
         ▼        ▼
    ┌────────┐ ┌──────────────┐
    │ LOGGED │ │ Error Message│
    │  IN    │ │ Return to    │
    └────┬───┘ │ Idle Screen  │
         │     └──────────────┘
         ▼
    ┌──────────────────────────────┐
    │      MAIN MENU LOOP          │
    │  (PERFORM UNTIL LOGGED-OUT)  │
    └────────────┬─────────────────┘
                 │
    ┌────────────┴────────────┐
    │                         │
    ▼                         ▼
┌─────────────────┐    ┌──────────────────┐
│  Display Menu   │    │  Accept Choice   │
│  1. Balance     │    │  (1-4, 9)        │
│  2. Deposit     │    └────────┬─────────┘
│  3. Withdraw    │             │
│  4. Logout      │    ┌────────┴────────────────┐
│  9. Shutdown    │    │                         │
└─────────────────┘    ▼                         ▼
                   ┌─────────────┐         ┌──────────────┐
                   │  Operation  │         │ Invalid      │
                   │  Handler    │         │ Selection    │
                   └─────────────┘         └──────────────┘
                         │
        ┌─────────────┬──┼─────────┬────────────┐
        │             │            │            │
        ▼             ▼            ▼            ▼
    ┌────────┐  ┌──────────┐  ┌────────┐  ┌──────────┐
    │Balance │  │ Deposit  │  │Withdraw│  │ Logout   │
    │Inquiry │  │  Funds   │  │ Funds  │  │  Card    │
    └────┬───┘  └────┬─────┘  └───┬────┘  └────┬─────┘
         │           │            │            │
         ▼           ▼            ▼            ▼
    ┌─────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
    │ Display │ │ Validate │ │ Validate │ │Set       │
    │ Balance │ │ Amount   │ │ Funds    │ │LOGGED-OUT│
    │ Format  │ │ Add to   │ │ Subtract │ │Return to │
    │ Currency│ │ Balance  │ │ Balance  │ │Idle      │
    └────┬────┘ └────┬─────┘ └────┬─────┘ └──────────┘
         │           │            │
         └───────────┴────────────┘
                     │
                     ▼
         ┌──────────────────────┐
         │ Return to Main Menu  │
         │ (Loop continues)     │
         └──────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
      Continue              Logout/Shutdown
         │                       │
         └───────────┬───────────┘
                     │
                     ▼
         ┌──────────────────────┐
         │ Return to Idle Screen│
         │ (Main loop repeats)  │
         └──────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
      Continue              Shutdown
         │                       │
         └───────────┬───────────┘
                     │
                     ▼
         ┌──────────────────────┐
         │ SYSTEM SHUTDOWN      │
         │ "POWERING DOWN"      │
         │ STOP RUN             │
         └──────────────────────┘
```

## Data Flow

```
┌──────────────────────────────────────────────────────────┐
│                   WORKING STORAGE                        │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  ACCOUNT-DB (3 accounts)                                │
│  ├─ DB-ACCT-NUM (5 digits)                              │
│  ├─ DB-PIN (4 digits)                                   │
│  ├─ DB-BALANCE (7 digits + 2 decimals)                  │
│  └─ DB-NAME (20 characters)                             │
│                                                          │
│  SESSION-STATE                                          │
│  ├─ CURRENT-USER-IDX (1 digit)                          │
│  ├─ IS-LOGGED-IN (Y/N flag)                             │
│  └─ SHUTDOWN-FLAG (Y/N flag)                            │
│                                                          │
│  INPUT VARIABLES                                        │
│  ├─ RAW-STRING (10 characters)                          │
│  ├─ INPUT-ACCT (5 digits)                               │
│  ├─ INPUT-PIN (4 digits)                                │
│  ├─ INPUT-AMOUNT (7 digits + 2 decimals)                │
│  ├─ MENU-CHOICE (1 character)                           │
│  └─ AUTH-SUCCESS (Y/N flag)                             │
│                                                          │
│  DISPLAY-MONEY (Currency format)                        │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

## State Machine

```
┌─────────────┐
│   STARTUP   │
└──────┬──────┘
       │
       ▼
┌──────────────┐
│ IDLE STATE   │◄─────────────────────┐
│ (Waiting)    │                      │
└──────┬───────┘                      │
       │                              │
       ├─[ENTER]──────────────────┐   │
       │                          │   │
       │                    ┌─────▼──────┐
       │                    │ LOGIN STATE│
       │                    │ (Auth)     │
       │                    └─────┬──────┘
       │                          │
       │                    ┌─────┴──────┐
       │                    │            │
       │                Success      Failure
       │                    │            │
       │                    ▼            │
       │            ┌──────────────┐    │
       │            │ MENU STATE   │    │
       │            │ (Operations) │    │
       │            └──────┬───────┘    │
       │                   │            │
       │            ┌──────┴──────┐     │
       │            │             │     │
       │         Logout      Shutdown   │
       │            │             │     │
       │            └─────┬───────┘     │
       │                  │             │
       │                  └─────────────┘
       │
       └─[9]─────────────────────────────┐
                                         │
                                    ┌────▼──────┐
                                    │ SHUTDOWN  │
                                    │ STATE     │
                                    └───────────┘
```

## Module Dependencies

```
MAIN-LOGIC
├── INIT-DB
├── DISPLAY-IDLE-SCREEN
├── LOGIN-SCREEN
│   └── AUTHENTICATE-USER
├── MAIN-MENU
│   ├── SHOW-BALANCE
│   ├── DEPOSIT-FUNDS
│   ├── WITHDRAW-FUNDS
│   └── LOGOUT-USER
└── System Termination
```

## Transaction Processing

```
User Input
    │
    ▼
Input Validation
    │
    ├─ Numeric Check
    ├─ Format Check
    └─ Range Check
    │
    ▼
Process Transaction
    │
    ├─ Retrieve Account
    ├─ Perform Operation
    └─ Update Balance
    │
    ▼
Format Output
    │
    ├─ Currency Format
    └─ Display Result
    │
    ▼
Return to Menu
```
