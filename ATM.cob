IDENTIFICATION DIVISION.
       PROGRAM-ID. CAT-BANK-ATM.
       AUTHOR. ANDY - SOLVARSAURUS GITHUB.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       *> ---------------------------------------------------
       *> SIMULATED DATABASE (TABLE OF ACCOUNTS)
       *> ---------------------------------------------------
       01  ACCOUNT-DB.
           05  CUSTOMER-ENTRY OCCURS 3 TIMES INDEXED BY C-IDX.
               10  DB-ACCT-NUM     PIC 9(5).
               10  DB-PIN          PIC 9(4).
               10  DB-BALANCE      PIC 9(7)V99.
               10  DB-NAME         PIC X(20).

       *> ---------------------------------------------------
       *> SESSION STATE
       *> ---------------------------------------------------
       01  SESSION-STATE.
           05  CURRENT-USER-IDX   PIC 9(1).
           05  IS-LOGGED-IN       PIC X(1) VALUE 'N'.
               88  LOGGED-IN       VALUE 'Y'.
               88  LOGGED-OUT      VALUE 'N'.
           05  SHUTDOWN-FLAG      PIC X(1) VALUE 'N'.
               88  SYSTEM-SHUTDOWN VALUE 'Y'.

       *> ---------------------------------------------------
       *> INPUT VARIABLES (ROBUST)
       *> ---------------------------------------------------
       01  RAW-INPUT.
           05  RAW-STRING         PIC X(10).
       
       01  PARSED-INPUTS.
           05  INPUT-ACCT         PIC 9(5).
           05  INPUT-PIN          PIC 9(4).
           05  INPUT-AMOUNT       PIC 9(7)V99.
           05  MENU-CHOICE        PIC X(1).

       01  VALIDATION-FLAGS.
           05  AUTH-SUCCESS       PIC X(1) VALUE 'N'.

       *> ---------------------------------------------------
       *> FORMATTING VARIABLES
       *> ---------------------------------------------------
       01  DISPLAY-MONEY          PIC $$$$,$$9.99.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM INIT-DB.

           *> THE MAIN SYSTEM LOOP
           PERFORM UNTIL SYSTEM-SHUTDOWN
               PERFORM DISPLAY-IDLE-SCREEN
               
               IF NOT SYSTEM-SHUTDOWN
                   SET LOGGED-OUT TO TRUE
                   PERFORM LOGIN-SCREEN
                   
                   *> IF LOGIN SUCCESSFUL, SHOW MENU
                   IF LOGGED-IN
                       PERFORM UNTIL LOGGED-OUT OR SYSTEM-SHUTDOWN
                           PERFORM MAIN-MENU
                       END-PERFORM
                   END-IF
               END-IF
           END-PERFORM.

           DISPLAY " "
           DISPLAY "SYSTEM POWERING DOWN. SECURE."
           STOP RUN.

       *> ---------------------------------------------------
       *> DATABASE INITIALIZATION (MOCK DATA)
       *> ---------------------------------------------------
       INIT-DB.
           *> USER 1: MR. WHISKERS
           MOVE 12345 TO DB-ACCT-NUM(1)
           MOVE 1111  TO DB-PIN(1)
           MOVE 1000.50 TO DB-BALANCE(1)
           MOVE "MR. WHISKERS        " TO DB-NAME(1).

           *> USER 2: DOC BROWN
           MOVE 88888 TO DB-ACCT-NUM(2)
           MOVE 1985  TO DB-PIN(2)
           MOVE 5000000.00 TO DB-BALANCE(2)
           MOVE "DR. E. BROWN        " TO DB-NAME(2).

           *> USER 3: MCFLY
           MOVE 54321 TO DB-ACCT-NUM(3)
           MOVE 0000  TO DB-PIN(3)
           MOVE 10.00 TO DB-BALANCE(3)
           MOVE "MARTY MCFLY            " TO DB-NAME(3).

       *> ---------------------------------------------------
       *> LOGIN LOGIC
       *> ---------------------------------------------------
       LOGIN-SCREEN.
           DISPLAY " "
           DISPLAY "PLEASE ENTER ACCOUNT NUMBER (5 DIGITS): " 
               WITH NO ADVANCING.
           ACCEPT RAW-STRING.
           
           *> CHECK IF USER WANTS TO SHUTDOWN AT LOGIN
           IF RAW-STRING(1:1) = '9' AND RAW-STRING(2:1) = ' '
               SET SYSTEM-SHUTDOWN TO TRUE
           ELSE
               IF RAW-STRING(1:5) IS NUMERIC
                   MOVE RAW-STRING(1:5) TO INPUT-ACCT
                   DISPLAY "PLEASE ENTER PIN (4 DIGITS): " 
                       WITH NO ADVANCING
                   ACCEPT RAW-STRING
                   
                   IF RAW-STRING(1:4) IS NUMERIC
                       MOVE RAW-STRING(1:4) TO INPUT-PIN
                       PERFORM AUTHENTICATE-USER
                   ELSE
                       DISPLAY "INVALID PIN FORMAT."
                   END-IF
               ELSE
                   DISPLAY "INVALID ACCOUNT FORMAT."
               END-IF
           END-IF.

       AUTHENTICATE-USER.
           MOVE 'N' TO AUTH-SUCCESS.
           PERFORM VARYING C-IDX FROM 1 BY 1 UNTIL C-IDX > 3
               IF DB-ACCT-NUM(C-IDX) = INPUT-ACCT AND 
                  DB-PIN(C-IDX) = INPUT-PIN
                   MOVE C-IDX TO CURRENT-USER-IDX
                   SET LOGGED-IN TO TRUE
                   MOVE 'Y' TO AUTH-SUCCESS
                   DISPLAY " "
                   DISPLAY "ACCESS GRANTED. WELCOME, " DB-NAME(C-IDX)
               END-IF
           END-PERFORM.

           IF AUTH-SUCCESS = 'N'
               DISPLAY " "
               DISPLAY "ERROR: INVALID CREDENTIALS. DISPERSING SECURITY CATS."
           END-IF.

       *> ---------------------------------------------------
       *> MENU & TRANSACTIONS
       *> ---------------------------------------------------
       MAIN-MENU.
           DISPLAY " "
           DISPLAY "==================================="
           DISPLAY "       CAT BANK OPERATIONS"
           DISPLAY "==================================="
           DISPLAY " 1. BALANCE INQUIRY"
           DISPLAY " 2. DEPOSIT FUNDS"
           DISPLAY " 3. WITHDRAW FUNDS"
           DISPLAY " 4. LOGOUT / EJECT CARD"
           DISPLAY " 9. SHUTDOWN SYSTEM"
           DISPLAY "==================================="
           DISPLAY "SELECT OPTION: " WITH NO ADVANCING.
           
           ACCEPT MENU-CHOICE.

           EVALUATE MENU-CHOICE
               WHEN '1' PERFORM SHOW-BALANCE
               WHEN '2' PERFORM DEPOSIT-FUNDS
               WHEN '3' PERFORM WITHDRAW-FUNDS
               WHEN '4' PERFORM LOGOUT-USER
               WHEN '9' SET SYSTEM-SHUTDOWN TO TRUE
               WHEN OTHER DISPLAY "INVALID SELECTION."
           END-EVALUATE.

       SHOW-BALANCE.
           MOVE DB-BALANCE(CURRENT-USER-IDX) TO DISPLAY-MONEY.
           DISPLAY " "
           DISPLAY "CURRENT BALANCE: " DISPLAY-MONEY.
           DISPLAY " ".

       DEPOSIT-FUNDS.
           DISPLAY "ENTER DEPOSIT AMOUNT: " WITH NO ADVANCING.
           ACCEPT RAW-STRING.
           
           IF RAW-STRING IS NUMERIC
               MOVE RAW-STRING TO INPUT-AMOUNT
               ADD INPUT-AMOUNT TO DB-BALANCE(CURRENT-USER-IDX)
               DISPLAY "DEPOSIT SUCCESSFUL."
               PERFORM SHOW-BALANCE
           ELSE
               DISPLAY "INVALID AMOUNT."
           END-IF.

       WITHDRAW-FUNDS.
           DISPLAY "ENTER WITHDRAWAL AMOUNT: " WITH NO ADVANCING.
           ACCEPT RAW-STRING.

           IF RAW-STRING IS NUMERIC
               MOVE RAW-STRING TO INPUT-AMOUNT
               IF INPUT-AMOUNT > DB-BALANCE(CURRENT-USER-IDX)
                   DISPLAY "INSUFFICIENT FUNDS (NOT ENOUGH TREATS)."
               ELSE
                   SUBTRACT INPUT-AMOUNT FROM DB-BALANCE(CURRENT-USER-IDX)
                   DISPLAY "CASH BEING COUNTED...PLEASE WAIT"
                   PERFORM SHOW-BALANCE
               END-IF
           ELSE
               DISPLAY "INVALID AMOUNT."
           END-IF.

       LOGOUT-USER.
           SET LOGGED-OUT TO TRUE.
           DISPLAY "CARD EJECTED. THANK YOU FOR CHOOSING CAT BANK.".

       *> ---------------------------------------------------
       *> VISUALS
       *> ---------------------------------------------------
       DISPLAY-IDLE-SCREEN.
           DISPLAY " ".
           DISPLAY " ".
           DISPLAY "  ██████╗  █████╗ ████████╗    ██████╗  █████╗ ███╗   ██╗██╗  ██╗".
           DISPLAY " ██╔════╝ ██╔══██╗╚══██╔══╝    ██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝".
           DISPLAY " ██║      ███████║   ██║       ██████╔╝███████║██╔██╗ ██║█████╔╝ ".
           DISPLAY " ██║      ██╔══██║   ██║       ██╔══██╗██╔══██║██║╚██╗██║██╔═██╗ ".
           DISPLAY " ╚██████╗ ██║  ██║   ██║       ██████╔╝██║  ██║██║ ╚████║██║  ██╗".
           DISPLAY "  ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝".
           DISPLAY " ".
           DISPLAY "               WELCOME TO THE CAT BANK ATM".
           DISPLAY "            PLEASE INSERT CARD TO BEGIN...".
           DISPLAY " ".
           DISPLAY "             [ PRESS ENTER TO START ]".
           DISPLAY "             [ PRESS 9 TO SHUTDOWN ]".
           ACCEPT RAW-STRING.
           IF RAW-STRING(1:1) = '9'
               SET SYSTEM-SHUTDOWN TO TRUE
           END-IF.