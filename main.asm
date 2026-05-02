INCLUDE Irvine32.inc
Includelib Winmm.lib

PlaySound PROTO,
              pszSound:PTR BYTE,
              hmod:DWORD,
              fdwSound:DWORD

.data


;File Handling
BUFFER_SIZE = 5000
filehandle dd ?
filename db "scores.txt",0

filebuffer db BUFFER_SIZE dup(0)
bytesRead  dd 0

keypress db 0                   ; or "keypress.wav",0
backkey  db "Press ENTER to go back",0

strname1 db "Name: ",0
strname db 20 dup(" ")
stringlength DWORD ?

levelstr db 2 dup(0)

scorestr db 6 dup(0)

SND_ALIAS    DWORD 00010000h ; Define constant for sound alias flag
SND_RESOURCE DWORD 00040005h ; Define constant for sound resource flag
SND_FILENAME DWORD 00020000h ; Define constant for sound filename flag
SND_ASYNC    DWORD 0001h     ; Define constant for asynchronous sound flag


paddleSound BYTE "sounds/Boing.wav",0
powerupSound BYTE "sounds/Saucer.wav",0
collisionSound BYTE "sounds/Swordswi.wav",0
firstHitSound BYTE "sounds/Ao-Laser.wav",0
secondHitSound BYTE "sounds/Glass.wav",0
thirdHitSound BYTE "sounds/Wowpulse.wav",0
groundCollisionSound BYTE "sounds/Byeball.wav",0
StartGameSound BYTE "sounds/Sweepdow.wav",0



;color dw yellow+(magenta*16)
color dw red+(yellow*16)

;Paddle Length
SCREEN_WIDTH = 120

;The score to win
Win_score = 12100  ;200

; dynamic erase buffer (max length = 15)
eraseBuffer     db 15 dup(" "), 0

; this will store the *current* paddle length
paddle_length   db ?

; PAGES
titlepage byte 0ah, 0ah, 0ah
    BYTE "    ########  ########  ####  ######  ##    ##    ########  ########  ########    ###    ##    ## ######## ########     ",0ah
    BYTE "    ##     ## ##     ##  ##  ##    ## ##   ##     ##     ## ##     ## ##         ## ##   ##   ##  ##       ##     ##    ",0ah
    BYTE "    ##     ## ##     ##  ##  ##       ##  ##      ##     ## ##     ## ##        ##   ##  ##  ##   ##       ##     ##    ",0ah
    BYTE "    ########  ########   ##  ##       #####       ########  ########  ######   ##     ## #####    ######   ########     ",0ah
    BYTE "    ##     ## ##   ##    ##  ##       ##  ##      ##     ## ##   ##   ##       ######### ##  ##   ##       ##   ##      ",0ah
    BYTE "    ##     ## ##    ##   ##  ##    ## ##   ##     ##     ## ##    ##  ##       ##     ## ##   ##  ##       ##    ##     ",0ah
    BYTE "    ########  ##     ## ####  ######  ##    ##    ########  ##     ## ######## ##     ## ##    ## ######## ##     ##    ",0ah
    byte "                                                                                                        ", 0ah, 0ah, 0ah
    byte "                                                       _    _                                         ", 0ah
    byte "                                                      / \  / \                                        ", 0ah
    byte "                                                     ( B |  Y )                                       ", 0ah
    byte "                                                      \_/  \_/                                        ", 0ah
    byte "   _    _    _    _    _     _     _    _    _    _    _    _     _     _    _    _    _   _    _    _    _    _    _", 0ah
    byte "  / \ // \ // \ // \ // \   / \   / \ // \ // \ // \ // \ // \   / \   / \ // \ // \ // \ / \ // \ // \ // \ // \ // \ ", 0ah
    byte " ( S |  A |  G |  A |  R | ( ~ ) | S |  U |  F |  Y |  A |  N ) ( ~ ) | A |  B |  D |  U | R |  E |  H |  M |  A |  N )", 0ah
    byte "  \_/ \__/ \__/ \__/ \\_/   \_/   \_/ \__/ \__/ \__/ \__/ \__/   \_/   \_/ \__/ \__/ \__/ \_/ \__/ \__/ \__/ \__/ \__/ ", 0ah
    byte "                                                                                                      ", 0ah
    byte "                                                                                                      ", 0ah
    byte "                                             Press Any Key to start                     ", 0

nameEnter byte 0ah,0ah,0ah
    BYTE "    ########  ########  ####  ######  ##    ##    ########  ########  ########    ###    ##    ## ######## ########     ",0ah
    BYTE "    ##     ## ##     ##  ##  ##    ## ##   ##     ##     ## ##     ## ##         ## ##   ##   ##  ##       ##     ##    ",0ah
    BYTE "    ##     ## ##     ##  ##  ##       ##  ##      ##     ## ##     ## ##        ##   ##  ##  ##   ##       ##     ##    ",0ah
    BYTE "    ########  ########   ##  ##       #####       ########  ########  ######   ##     ## #####    ######   ########     ",0ah
    BYTE "    ##     ## ##   ##    ##  ##       ##  ##      ##     ## ##   ##   ##       ######### ##  ##   ##       ##   ##      ",0ah
    BYTE "    ##     ## ##    ##   ##  ##    ## ##   ##     ##     ## ##    ##  ##       ##     ## ##   ##  ##       ##    ##     ",0ah
    BYTE "    ########  ##     ## ####  ######  ##    ##    ########  ##     ## ######## ##     ## ##    ## ######## ##     ##    ",0ah
    byte "                                                                                                          ", 0ah
    byte "                                                                                                        ", 0ah, 0ah, 0ah
    byte "                                                                                                      ",0ah
    byte "                        ##### ##  ## ###### ##### ######               ##  ##  ####  ##   # #####     ",0ah
    byte "                        ##    ### ##   ##   ##    ##   ##              ### ## ##  ## ### ## ##        ",0ah
    byte "                        ####  ## ###   ##   ####  #######              ## ### ###### ## # # ####      ",0ah
    byte "                        ##    ##  ##   ##   ##    ##    ##             ##  ## ##  ## ##   # ##        ",0ah
    byte "                        ##### ##  ##   ##   ##### ##     ##            ##  ## ##  ## ##   # #####     ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah,0ah
    byte "                                                   Enter Your Name:           ",0ah
    byte "                                                                    ",0ah
    byte "                                                           ",0


menustr1 byte 0ah,0ah,0ah
    BYTE "    ########  ########  ####  ######  ##    ##    ########  ########  ########    ###    ##    ## ######## ########     ",0ah
    BYTE "    ##     ## ##     ##  ##  ##    ## ##   ##     ##     ## ##     ## ##         ## ##   ##   ##  ##       ##     ##    ",0ah
    BYTE "    ##     ## ##     ##  ##  ##       ##  ##      ##     ## ##     ## ##        ##   ##  ##  ##   ##       ##     ##    ",0ah
    BYTE "    ########  ########   ##  ##       #####       ########  ########  ######   ##     ## #####    ######   ########     ",0ah
    BYTE "    ##     ## ##   ##    ##  ##       ##  ##      ##     ## ##   ##   ##       ######### ##  ##   ##       ##   ##      ",0ah
    BYTE "    ##     ## ##    ##   ##  ##    ## ##   ##     ##     ## ##    ##  ##       ##     ## ##   ##  ##       ##    ##     ",0ah
    BYTE "    ########  ##     ## ####  ######  ##    ##    ########  ##     ## ######## ##     ## ##    ## ######## ##     ##    ",0ah
    byte "                                                                                                           ",0ah
    byte "                                                                                                          ",0ah,0ah,0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                   -> START GAME",0ah
    byte "                                                      INSTRUCTIONS",0ah
    byte "                                                      HIGHSCORES",0
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah,0ah

menustr2 byte 0ah,0ah,0ah
    BYTE "    ########  ########  ####  ######  ##    ##    ########  ########  ########    ###    ##    ## ######## ########     ",0ah
    BYTE "    ##     ## ##     ##  ##  ##    ## ##   ##     ##     ## ##     ## ##         ## ##   ##   ##  ##       ##     ##    ",0ah
    BYTE "    ##     ## ##     ##  ##  ##       ##  ##      ##     ## ##     ## ##        ##   ##  ##  ##   ##       ##     ##    ",0ah
    BYTE "    ########  ########   ##  ##       #####       ########  ########  ######   ##     ## #####    ######   ########     ",0ah
    BYTE "    ##     ## ##   ##    ##  ##       ##  ##      ##     ## ##   ##   ##       ######### ##  ##   ##       ##   ##      ",0ah
    BYTE "    ##     ## ##    ##   ##  ##    ## ##   ##     ##     ## ##    ##  ##       ##     ## ##   ##  ##       ##    ##     ",0ah
    BYTE "    ########  ##     ## ####  ######  ##    ##    ########  ##     ## ######## ##     ## ##    ## ######## ##     ##    ",0ah
    byte "                                                                                                           ",0ah
    byte "                                                                                                          ",0ah,0ah,0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                      START GAME",0ah
    byte "                                                   -> INSTRUCTIONS",0ah
    byte "                                                      HIGHSCORES",0
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah,0ah

menustr3 byte 0ah,0ah,0ah
    BYTE "    ########  ########  ####  ######  ##    ##    ########  ########  ########    ###    ##    ## ######## ########     ",0ah
    BYTE "    ##     ## ##     ##  ##  ##    ## ##   ##     ##     ## ##     ## ##         ## ##   ##   ##  ##       ##     ##    ",0ah
    BYTE "    ##     ## ##     ##  ##  ##       ##  ##      ##     ## ##     ## ##        ##   ##  ##  ##   ##       ##     ##    ",0ah
    BYTE "    ########  ########   ##  ##       #####       ########  ########  ######   ##     ## #####    ######   ########     ",0ah
    BYTE "    ##     ## ##   ##    ##  ##       ##  ##      ##     ## ##   ##   ##       ######### ##  ##   ##       ##   ##      ",0ah
    BYTE "    ##     ## ##    ##   ##  ##    ## ##   ##     ##     ## ##    ##  ##       ##     ## ##   ##  ##       ##    ##     ",0ah
    BYTE "    ########  ##     ## ####  ######  ##    ##    ########  ##     ## ######## ##     ## ##    ## ######## ##     ##    ",0ah
    byte "                                                                                                           ",0ah
    byte "                                                                                                          ",0ah,0ah,0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                      START GAME",0ah
    byte "                                                      INSTRUCTIONS",0ah
    byte "                                                   -> HIGHSCORES",0
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah,0ah

gameOverStr1 byte 0ah,0ah,0ah
    BYTE "    ########  ########  ####  ######  ##    ##    ########  ########  ########    ###    ##    ## ######## ########     ",0ah
    BYTE "    ##     ## ##     ##  ##  ##    ## ##   ##     ##     ## ##     ## ##         ## ##   ##   ##  ##       ##     ##    ",0ah
    BYTE "    ##     ## ##     ##  ##  ##       ##  ##      ##     ## ##     ## ##        ##   ##  ##  ##   ##       ##     ##    ",0ah
    BYTE "    ########  ########   ##  ##       #####       ########  ########  ######   ##     ## #####    ######   ########     ",0ah
    BYTE "    ##     ## ##   ##    ##  ##       ##  ##      ##     ## ##   ##   ##       ######### ##  ##   ##       ##   ##      ",0ah
    BYTE "    ##     ## ##    ##   ##  ##    ## ##   ##     ##     ## ##    ##  ##       ##     ## ##   ##  ##       ##    ##     ",0ah
    BYTE "    ########  ##     ## ####  ######  ##    ##    ########  ##     ## ######## ##     ## ##    ## ######## ##     ##    ",0ah
    byte "                                                                                                            ",0ah
    byte "                                                                                                      ",0ah,0ah,0ah
    BYTE "                   ##    ##  #######  ##     ##    ##        #######   ######  ########               ",0ah
    BYTE "                    ##  ##  ##     ## ##     ##    ##       ##     ## ##    ## ##                     ",0ah
    BYTE "                     ####   ##     ## ##     ##    ##       ##     ## ##       ##                     ",0ah
    BYTE "                      ##    ##     ## ##     ##    ##       ##     ##  ######  ######                 ",0ah
    BYTE "                      ##    ##     ## ##     ##    ##       ##     ##       ## ##                     ",0ah
    BYTE "                      ##    ##     ## ##     ##    ##       ##     ## ##    ## ##                     ",0ah
    BYTE "                      ##     #######   #######     ########  #######   ######  ########               ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                         PRESS ANY KEY TO FINISH PROGRAM                              ",0ah
    byte "                                                                    ",0ah,0


gameOverStr2 byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                          ",0ah
    byte "                                                                                                            ",0ah
    byte "                                                                                                         ",0ah
    byte "                                                                                                      ",0ah
    byte "                                           _    _    _    _    _                                         ",0ah
    byte "                                          / \ // \ // \ // \ // \                                        ",0ah
    byte "                                         ( B |  R |  I |  C |  K )                                      ",0ah
    byte "                                          \_/\\__/\\__/\\__/\\__/                                     ",0ah,0ah,0ah
    byte "                                      _    _    _    _    _    _    _                                 ",0ah
    byte "                                     / \ // \ // \ // \ // \ // \ // \                                ",0ah
    byte "                                    ( B |  R |  E |  A |  K |  E |  R )                               ",0ah
    byte "                                     \_/\\__/\\__/\\__/\\__/\\__/\\__/                                ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah,0ah
    byte "                                         G  A  M  E   O  V  E  R",0ah
    byte "                                              Go back to start",0ah
    byte "                                            ->close game",0

PauseStr1 byte "                                                                                                  ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                          ",0ah
    byte "                                                                                                            ",0ah
    byte "                                                                                                         ",0ah
    byte "                                                                                                      ",0ah
    byte "                                           _    _    _    _    _                                         ",0ah
    byte "                                          / \ // \ // \ // \ // \                                        ",0ah
    byte "                                         ( B |  R |  I |  C |  K )                                      ",0ah
    byte "                                          \_/\\__/\\__/\\__/\\__/                                     ",0ah,0ah,0ah
    byte "                                      _    _    _    _    _    _    _                                 ",0ah
    byte "                                     / \ // \ // \ // \ // \ // \ // \                                ",0ah
    byte "                                    ( B |  R |  E |  A |  K |  E |  R )                               ",0ah
    byte "                                     \_/\\__/\\__/\\__/\\__/\\__/\\__/                                ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah,0ah
    byte "                                             P  A  U  S  E  D",0ah
    byte "                                               ->Resume",0ah
    byte "                                             Go back to menu ",0ah
    byte "                                                                    ",0ah,0

PauseStr2 byte "                                                                                                  ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                          ",0ah
    byte "                                                                                                            ",0ah
    byte "                                                                                                         ",0ah
    byte "                                                                                                      ",0ah
    byte "                                           _    _    _    _    _                                         ",0ah
    byte "                                          / \ // \ // \ // \ // \                                        ",0ah
    byte "                                         ( B |  R |  I |  C |  K )                                      ",0ah
    byte "                                          \_/\\__/\\__/\\__/\\__/                                     ",0ah,0ah,0ah
    byte "                                      _    _    _    _    _    _    _                                 ",0ah
    byte "                                     / \ // \ // \ // \ // \ // \ // \                                ",0ah
    byte "                                    ( B |  R |  E |  A |  K |  E |  R )                               ",0ah
    byte "                                     \_/\\__/\\__/\\__/\\__/\\__/\\__/                                ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah,0ah
    byte "                                             P  A  U  S  E  D",0ah
    byte "                                                 Resume",0ah
    byte "                                           ->Go back to menu ",0ah
    byte "                                                                    ",0ah,0

WinnerStr byte 0ah,0ah,0ah
    BYTE "    ########  ########  ####  ######  ##    ##    ########  ########  ########    ###    ##    ## ######## ########     ",0ah
    BYTE "    ##     ## ##     ##  ##  ##    ## ##   ##     ##     ## ##     ## ##         ## ##   ##   ##  ##       ##     ##    ",0ah
    BYTE "    ##     ## ##     ##  ##  ##       ##  ##      ##     ## ##     ## ##        ##   ##  ##  ##   ##       ##     ##    ",0ah
    BYTE "    ########  ########   ##  ##       #####       ########  ########  ######   ##     ## #####    ######   ########     ",0ah
    BYTE "    ##     ## ##   ##    ##  ##       ##  ##      ##     ## ##   ##   ##       ######### ##  ##   ##       ##   ##      ",0ah
    BYTE "    ##     ## ##    ##   ##  ##    ## ##   ##     ##     ## ##    ##  ##       ##     ## ##   ##  ##       ##    ##     ",0ah
    BYTE "    ########  ##     ## ####  ######  ##    ##    ########  ##     ## ######## ##     ## ##    ## ######## ##     ##    ",0ah
    byte "                                                                                                            ",0ah
    byte "                                                                                                      ",0ah,0ah,0ah
    byte "                              ##    ##  #######  ##     ##    ##      ##  #######  ##    ##           ",0ah
    BYTE "                               ##  ##  ##     ## ##     ##    ##  ##  ## ##     ## ###   ##           ",0ah
    BYTE "                                ####   ##     ## ##     ##    ##  ##  ## ##     ## ####  ##           ",0ah
    BYTE "                                 ##    ##     ## ##     ##    ##  ##  ## ##     ## ## ## ##           ",0ah
    BYTE "                                 ##    ##     ## ##     ##    ##  ##  ## ##     ## ##  ####           ",0ah
    BYTE "                                 ##    ##     ## ##     ##    ##  ##  ## ##     ## ##   ###           ",0ah
    BYTE "                                 ##     #######   #######      ###  ###   #######  ##    ##           ",0ah,0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                                                                                      ",0ah
    byte "                                         PRESS ANY KEY TO FINISH PROGRAM                              ",0ah
    byte "                                                                    ",0ah,0

instructionPage byte 0ah, 0ah, 0ah
    byte "                                                I N S T R U C T I O N S",0ah,0ah
    byte "                                                                      ",0ah
    byte "                              1. Your goal is to clear each Level by DESTROYING ALL BRICKS ",0ah
    byte "                                                2. You have 3 Lives",0ah
    byte "                                             3. Hit the Ball with the Paddle",0ah
    byte "                                         4. If You lose all lives, game is over!",0ah,0ah
    byte "                                                                   ",0ah
    byte "                                                                   ",0ah
    byte "                                                       Controls:",0ah
    byte "                                              1. Press 'A' to move left",0ah
    byte "                                              2. Press 'D' to move Right",0ah
    byte "                                              3. Press 'P' to Pause",0ah
    byte "                                                                          ",0ah,0ah
    byte "                                                     Extra Life '+':",0ah
    byte "                       This treat is hidden in the third level, Find a way to it and save your skin!",0ah,0ah
    byte "                                                                  ",0ah
    byte "                                                                  ",0ah
    byte "                                                                 ",0ah
    byte "                                                                                ",0ah,0ah
    byte "                                                Press Enter to go back ",0ah,0ah
    byte "                                          ",0

; ----------------------------
; End of UI STRINGS
; ----------------------------



switchlevel2 db 1
switchlevel3 db 0



ground BYTE "------------------------------------------------------------------------------------------------------------------------",0
ground1 BYTE "|",0ah,0
ground2 BYTE "|",0
xline db ?
yline db ?
temp db ?




menu db "---      MENU      ---",0AH,0
sel    db "-- Select a Level --", 0AH, 0
menul1 db "Press Enter to start game ", 0 
menul2 db "Press 'L'' to select a level ", 0
menul3 db "Press 'I' to Open Instructions ", 0
menul4 db "Press 'S' to display Scores ", 0
menul5 db "Press 'x' to exit game ", 0
;MenuM db ?


strpause db "XX XX", 0ah,0
press db "Press P to resume",0
v db 240



paddle db "***************",0
paddle2 db "**********",0
removepaddle db "               ",0


inputChar db ?

thickness_y db ?
thickness_x db ?

ballx db 50
bally db 12

padx db 50
pady db 27

ballanglex db 0
ballangley db 1


;vertex variables
vertexx1 db ?
vertexx2 db ?
vertexy1 db ?
vertexy2 db ?

tx db ?
ty db ?


;level 1 blocks stats
l1_b1_stat db 1
l1_b2_stat db 1
l1_b3_stat db 1
l1_b4_stat db 1
l1_b5_stat db 1
l1_b6_stat db 1
l1_b7_stat db 1
l1_b8_stat db 1
l1_b9_stat db 1
l1_b10_stat db 1
stat db 1


;level 2 blocks stats
l2_b1_stat db 2
l2_b2_stat db 2
l2_b3_stat db 2
l2_b4_stat db 2
l2_b5_stat db 2
l2_b6_stat db 2
l2_b7_stat db 2
l2_b8_stat db 2
l2_b9_stat db 2
l2_b10_stat db 2
l2_b11_stat db 2
l2_b12_stat db 2
l2_b13_stat db 2
l2_b14_stat db 2
l2_b15_stat db 2
l2_b16_stat db 2
l2_b17_stat db 2
l2_b18_stat db 2
stat2 db 1


;level 3 blocks stats
l3_b1_stat db 3
l3_b2_stat db 3
l3_b3_stat db 3
l3_b4_stat db 3
l3_b5_stat db 3
l3_b6_stat db 3
l3_b7_stat db 3
l3_b8_stat db 3
l3_b9_stat db 3
l3_b10_stat db 3
l3_b11_stat db 3
l3_b12_stat db 3
l3_b13_stat db 3
l3_b14_stat db 3
l3_b15_stat db 3
l3_b16_stat db 3
l3_b17_stat db 3
l3_b18_stat db 3
l3_b19_stat db 3
l3_b20_stat db 3
l3_b21_stat db 3
l3_b22_stat db 3
l3_b23_stat db 3
l3_b24_stat db 3
l3_b25_stat db 3
stat3 db 1
blocksdestroyed db 0




;lives, score and level
lives db "LIVES: ",0
score db "SCORE: ",0
level db "LEVEL: ",0
life_count db 3
score_count dd 0
level_count db 1


bonus db '^',0
bonusx db 60
bonusy db 10
bonustaken db 0



formatString db "Name: %s Level: %d SCORE: %d", 0
formattedString db 256 dup(?)
newline db 13, 10, 0  


.code


;File Handling
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    file_handling proc

    push ebx
    push esi
    push edi

    mov edx, offset filename
    invoke CreateFile, edx, GENERIC_WRITE, FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov filehandle, eax
    cmp filehandle, INVALID_HANDLE_VALUE
    je error_exit

    invoke SetFilePointer, filehandle, 0, 0, FILE_END
    test eax, eax
    js error_exit

    ; format text
    mov edx, offset formatString
    mov eax, offset strname
    movzx ebx, level_count
    mov ecx, score_count
    lea edi, formattedString
    invoke wsprintfA, edi, edx, eax, ebx, ecx
    mov ebp, eax           ; <-- string length

    ; append newline "\r\n"
    mov edi, offset formattedString
    add edi, ebp
    mov esi, offset newline
    mov ecx, 2
    rep movsb
    add ebp, 2             ; <-- final write length

    ; write correct number of bytes
    mov eax, filehandle
    mov edx, offset formattedString
    mov ecx, ebp
    call writetofile

    test eax, eax
    js error_exit

    invoke CloseHandle, filehandle

    pop edi
    pop esi
    pop ebx
    ret

error_exit:
    pop edi
    pop esi
    pop ebx
    invoke ExitProcess, 1
    ret

file_handling endp

filereading PROC

    ; open file for reading
    mov edx, offset filename
    invoke CreateFile, edx, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov filehandle, eax
    cmp eax, INVALID_HANDLE_VALUE
    je read_error

    ; read file into buffer
    invoke ReadFile, filehandle, addr filebuffer, BUFFER_SIZE, addr bytesRead, NULL

    ; close file
    invoke CloseHandle, filehandle

    ; return number of bytes in EAX
    mov eax, bytesRead
    ret

read_error:
    xor eax, eax     ; return 0 bytes on error
    ret

filereading ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Pause
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PAUSESCREEN PROC

    mov esi, 1
    mov ecx, 6

    loopinf2:

    mov eax, 0 
    mov  eax, blue
    add eax, esi
    call SetTextColor
    mov dl, 19
    mov dh,10
    mov  ebx, esi
    add dh, bl
    call Gotoxy
    mov edx,OFFSET strpause
    call WriteString
    inc esi

    loop loopinf2

    mov ax, white
    call settextcolor
    mov dl, 50
    mov dh, 13
    call gotoxy
    mov edx, offset press
    call writestring

    mov esi, 1
    mov ecx, 6

    
    loopinfi:

    mov eax, 0 
    mov  eax, blue
    add eax, esi
    call SetTextColor
    mov dl,100
    mov dh,10
    mov  ebx, esi
    add dh, bl
    call Gotoxy
    mov edx,OFFSET strpause
    call WriteString
    inc esi

    loop loopinfi 
    
    
    pti:
    call ReadChar
    mov inputChar,al
    cmp inputChar, "p"
    je glut
    jmp pti

    glut:
    
    mov inputChar, ";"
    mov esi, 1
    mov ecx, 6
           
    loopzero:

    mov eax, 0 
    mov  eax, black
    call SetTextColor
    mov dl,100
    mov dh,10
    mov  ebx, esi
    add dh, bl
    call Gotoxy
    mov edx,OFFSET strpause
    call WriteString
    inc esi

    loop loopzero

    mov inputChar, ";"
    mov esi, 1
    mov ecx, 6
           
    loopzero2:

    mov eax, 0 
    mov  eax, black
    call SetTextColor
    mov dl,19
    mov dh,10
    mov  ebx, esi
    add dh, bl
    call Gotoxy
    mov edx,OFFSET strpause
    call WriteString
    inc esi

    loop loopzero2


    RETURN:

    mov ax, black
    call settextcolor
    mov dl, 50
    mov dh, 13
    call gotoxy
    mov edx, offset press
    call writestring

    RET
    PAUSESCREEN ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Display Game Title, Input Name, and Menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Changed to Temuri UI

MAINMENU PROC

    call clrscr

    mov eax, dword ptr color
    call settextcolor

    ; Display title screen
    mov edx, offset titlepage
    call clrscr
    call writestring

    ; Play start sound
    INVOKE PlaySound, OFFSET StartGameSound, NULL, 20001H

    mov eax, 0

    ; Wait for key press
    call readchar

    cmp al, "-"                      ; If "-" pressed, jump to namenter
    jne namenter

    
    mov eax, 0
    call MAINMENU

namenter:
    
    mov eax, 0

    ; Show name and menu screens
    call nameScreen
    call menuScreen
    call ClearScreen

    ret



    MainMenu Endp


    nameScreen PROC
    mov eax, dword ptr color
    call settextcolor

    mov edx, offset nameEnter
    call clrscr
    call writestring

    ; Read the user input string (name)
    mov edx, offset strname
    mov ecx, sizeof strname
    call readstring
    mov stringlength, eax         ; Store the length of the input string

    ; Play keypress sound
    mov eax, SND_ASYNC
    or eax, SND_FILENAME
    

    ret
nameScreen ENDP

menuScreen PROC

menuprinting1:
    mov eax, dword ptr color
    call settextcolor
    mov edx, offset menustr1
    call clrscr
    call writestring

    call readchar
    cmp al, 0Dh
    je start
    cmp al, 's'
    je menuprinting2

    
    jmp menuprinting1

menuprinting2:
    mov eax, dword ptr color
    call settextcolor
    mov edx, offset menustr2
    call clrscr
    call writestring

    call readchar
    cmp al, 0Dh
    je instruct
    cmp al, 's'
    je menuprinting3
    cmp al, 'w'
    je menuprinting1

    
    jmp menuprinting2

menuprinting3:
    mov eax, dword ptr color
    call settextcolor
    mov edx, offset menustr3
    call clrscr
    call writestring

    call readchar
    cmp al, 0Dh
    je option3Action
    cmp al, 'w'
    je menuprinting2

    
    jmp menuprinting3

instruct:
    
    call Instructions_UI
    jmp menuprinting1

option3Action:
    
    call highscreen
    jmp menuprinting1

start:
    
    call clrscr
    ret

menuScreen ENDP

highscreen PROC

    ; Clear screen
    call clrscr

    ; Read file (must load into filebuffer and return size in EAX)
    call filereading      
    mov esi, offset filebuffer    ; ESI = pointer to file buffer
    mov ebx, eax                  ; EBX = number of bytes read

    ; Set initial display position
    mov dh, 2                     ; row starting position
    mov dl, 5                     ; column starting position

display_loop:
    cmp ebx, 0
    je display_back_key           ; no more bytes, exit loop

    ; Move cursor for this line
    call gotoxy

    ; Print characters until newline or buffer ends
print_chars:
    cmp byte ptr [esi], 0
    je display_back_key            ; null terminator ? end of file

    cmp byte ptr [esi], 13         ; '\r' ?
    je skip_cr

    cmp byte ptr [esi], 10         ; '\n' ?
    je next_line

    mov al, [esi]
    call writechar

    inc esi
    dec ebx
    jmp print_chars

skip_cr:
    inc esi
    dec ebx
    jmp print_chars

next_line:
    inc esi
    dec ebx

    inc dh                         ; move down 1 line
    jmp display_loop

; ---------------------
; Display BACK key info
; ---------------------
display_back_key:
    mov dl, 5
    mov dh, 25                    ; bottom of screen
    call gotoxy
    mov edx, offset backkey
    call writestring

wait_key:
    call readchar
    cmp al, 0Dh
    je exit_hs

    call highscreen               ; redraw
exit_hs:
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    ret

highscreen ENDP


Instructions_UI PROC
    mov eax, dword ptr color
    call settextcolor
    mov edx, offset instructionPage
    call clrscr
    call writestring

    ; Wait for user input (space to return)
    call readchar
    cmp al, 0Dh 
    je return       

    ; Recursive call if space is pressed
    call Instructions_UI

return:
    mov eax, 0
    mov ebx, 0
    mov ecx, 0
    mov edx, 0
    ret
Instructions_UI ENDP


ClearScreen PROC
    mov edi, 2
    L1:
    dec edi
    cmp edi, 0
    je return_label
    call clrscr

    mov  eax, brown
    call SetTextColor
    mov ecx, 14
    mov dl, 33
    mov dh, 6
    call gotoxy
    mov ecx, 13
    mov dl, 83
    mov dh, 6
    call gotoxy

    mov ecx, 50
    mov dl, 34
    mov dh, 6
    call gotoxy

    mov ecx, 50
    mov dl, 34
    mov dh, 19
    call gotoxy

    
    ; menu lines
    mov  eax,  14
    call SetTextColor
    mov dl,48
    mov dh,5
    call Gotoxy
    mov edx,OFFSET menu
    

    mov  eax, red
    call SetTextColor
    mov dl,45
    mov dh,8
    call Gotoxy
    mov edx,OFFSET menul1
    
    mov  eax, blue
    call SetTextColor
    mov dl,45
    mov dh,10
    call Gotoxy
    mov edx,OFFSET menul2
    
    mov  eax, green
    call SetTextColor
    mov dl,45
    mov dh,12
    call Gotoxy
    mov edx,OFFSET menul3
    
    mov  eax, lightcyan
    call SetTextColor
    mov dl,45
    mov dh,14
    call Gotoxy
    mov edx,OFFSET menul4
    
    mov  eax, white
    call SetTextColor
    mov dl,45
    mov dh,16
    call Gotoxy
    mov edx,OFFSET menul5

    mov al,0
    jmp L1
    
    return_label:
    ret
    ClearScreen Endp

; UI Functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Redraw grid if grid erased
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawleftline proc
    
    push eax
    
    mov eax,red+(red*16)
    call settextcolor

    mov dh,3
    mov ecx,27
    l1:
    mov dl,0
    call Gotoxy
    mov al,'|'
    call writechar
    inc dh
    loop l1

    pop eax

    ret
    drawleftline endp


drawrightline proc
    
    push eax
    
    mov eax,red+(red*16)
    call settextcolor

    mov dh,3
    mov ecx,27
    l1:
    mov dl,119
    call Gotoxy
    mov al,'|'
    call writechar
    inc dh
    loop l1

    pop eax

    ret
    drawrightline endp


drawroof proc
    
    push eax

    mov eax,red+(red*16)
    call settextcolor
    
    mov dl,0
    mov dh,2
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString

    pop eax

    ret
    drawroof endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Level1 ball direction checks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

updateballdirectionaftercontactwithpaddle PROC
    ; Clear registers (optional)
    xor eax,eax
    xor ebx,ebx
    xor ecx,ecx
    xor edx,edx

    ; Calculate paddle edges
    mov al,padx
    dec al               ; left edge - 1
    mov cl,padx
    add cl,15            ; right edge = padx + paddle length (15)

    mov bl,pady
    dec bl               ; paddle row -1 for collision detection

    ; Check Y coordinate (ball row) first
    cmp bally,bl
    je checkx1
    jmp ballnotonpaddle

checkx1:
    cmp ballx,al
    jge checkx2
    jmp ballmissingpaddle

checkx2:
    cmp ballx,cl
    jle ballonpaddle
    jmp ballmissingpaddle

; ????????? Ball Hits Paddle ?????????
ballonpaddle:
    mov al,ballx
    mov bl,padx
    sub al,bl           ; distance from left edge

    ; Determine contact segment
    cmp al,2
    jle leftmostcontact
    cmp al,5
    jle leftcontact
    cmp al,9
    jle centrecontact
    cmp al,12
    jle rightcontact
    cmp al,15           ; FIXED: paddle length=15 ? max index=14
    jle rightmostcontact

; ????? Paddle Contact Responses ?????
leftmostcontact:
    INVOKE PlaySound, OFFSET paddleSound, NULL, 11h
    mov ballanglex,-2
    mov ballangley,-1
    jmp enforce_bounds1

leftcontact:
    INVOKE PlaySound, OFFSET paddleSound, NULL, 11h
    mov ballanglex,-1
    mov ballangley,-1
    jmp enforce_bounds1

centrecontact:
    INVOKE PlaySound, OFFSET paddleSound, NULL, 11h
    mov ballanglex,0
    mov ballangley,-1
    jmp enforce_bounds1

rightcontact:
    INVOKE PlaySound, OFFSET paddleSound, NULL, 11h
    mov ballanglex,1
    mov ballangley,-1
    jmp enforce_bounds1

rightmostcontact:
    INVOKE PlaySound, OFFSET paddleSound, NULL, 11h
    mov ballanglex,2
    mov ballangley,-1
    jmp enforce_bounds1

; ????????? Ball Missed Paddle ?????????
ballnotonpaddle:
ballmissingpaddle:
    jmp endfunc1

; ????????? ENFORCE SCREEN BOUNDARIES ?????????
enforce_bounds1:
    cmp ballx,1
    jge check_right1
    mov ballx,1

check_right1:
    cmp ballx,119        ; screen width -1
    jle endfunc1
    mov ballx,119

endfunc1:
    call updateBall
    call drawrightline
    ret

updateballdirectionaftercontactwithpaddle ENDP

    ; New Code after correctness

    updateballdirectionaftercontactwithpaddle2 PROC
    ; Clear registers (optional)
    xor eax,eax
    xor ebx,ebx
    xor ecx,ecx
    xor edx,edx

    ; Calculate paddle edges
    mov al,padx
    dec al               ; left edge - 1
    mov cl,padx
    add cl,10            ; right edge = padx + paddle2 length

    mov bl,pady
    dec bl               ; paddle row -1 for collision detection

    ; Check Y coordinate (ball row) first
    cmp bally,bl
    je checkx1
    jmp ballnotonpaddle

checkx1:
    cmp ballx,al
    jge checkx2
    jmp ballmissingpaddle

checkx2:
    cmp ballx,cl
    jle ballonpaddle
    jmp ballmissingpaddle

; ????????? Ball Hits Paddle ?????????
ballonpaddle:
    mov al,ballx
    mov bl,padx
    sub al,bl           ; distance from left edge

    ; Determine contact segment
    cmp al,2
    jle leftmostcontact
    cmp al,4
    jle leftcontact
    cmp al,6
    jle centrecontact
    cmp al,8
    jle rightcontact
    cmp al,10            ; FIXED: paddle length =10, max index = 9
    jle rightmostcontact

; ????? Paddle Contact Responses ?????
leftmostcontact:
    INVOKE PlaySound, OFFSET paddleSound, NULL, 11h
    mov ballanglex,-2
    mov ballangley,-1
    jmp enforce_bounds

leftcontact:
    INVOKE PlaySound, OFFSET paddleSound, NULL, 11h
    mov ballanglex,-1
    mov ballangley,-1
    jmp enforce_bounds

centrecontact:
    INVOKE PlaySound, OFFSET paddleSound, NULL, 11h
    mov ballanglex,0
    mov ballangley,-1
    jmp enforce_bounds

rightcontact:
    INVOKE PlaySound, OFFSET paddleSound, NULL, 11h
    mov ballanglex,1
    mov ballangley,-1
    jmp enforce_bounds

rightmostcontact:
    INVOKE PlaySound, OFFSET paddleSound, NULL, 11h
    mov ballanglex,2
    mov ballangley,-1
    jmp enforce_bounds

; ????????? Ball Missed Paddle ?????????
ballnotonpaddle:
ballmissingpaddle:
    jmp endfunc

; ????????? ENFORCE SCREEN BOUNDARIES ?????????
enforce_bounds:
    cmp ballx,1
    jge check_right
    mov ballx,1

check_right:
    cmp ballx,119        ; screen width -1
    jle endfunc
    mov ballx,116

endfunc:
    call updateBall
    call drawrightline
    ret

updateballdirectionaftercontactwithpaddle2 ENDP


updateballdirectionaftercontactwithleftwall proc

    mov eax,0
    mov ebx,0
    mov ecx,0
    mov edx,0

    mov al,ballx
    mov bl,bally

    cmp bally,27
    jg dead

    cmp bally,3
    jge checkx
    jmp endfunc

    checkx:
    cmp ballx,2
    jle leftwallcontact
    jmp endfunc

    leftwallcontact:
    INVOKE PlaySound, OFFSET collisionSound, NULL, 11h
    mov al,ballanglex
    mov cl,-1
    imul cl
    
    mov ballanglex,al
    call drawleftline
    jmp endfunc

    dead:

    endfunc:

    ret
    updateballdirectionaftercontactwithleftwall endp

; New Function

updateballdirectionaftercontactwithrightwall PROC
    mov eax,0
    mov ebx,0
    mov ecx,0
    mov edx,0

    ; Ball hits right wall at x >= 119
    cmp ballx,118
    jl endfunc          ; no contact

rightwallcontact:
    ; play sound
    INVOKE PlaySound, OFFSET collisionSound, NULL, 11h

    ; reflect angle
    mov al, ballanglex
    neg al
    mov ballanglex, al

    ; ***** IMPORTANT FIX *****
    ; Push ball back inside playfield
    mov ballx,117        ; keep ball inside boundary

endfunc:
    ret

updateballdirectionaftercontactwithrightwall ENDP


updateballdirectionaftercontactwithroof proc

    mov eax,0
    mov ebx,0
    mov ecx,0
    mov edx,0

    mov al,ballx
    mov bl,bally

    cmp bally,4
    jl roofcontact
    jmp endfunc

    roofcontact:
     INVOKE PlaySound, OFFSET collisionSound, NULL, 11h
    mov bally,3
    mov al,ballangley
    mov cl,-1
    imul cl
    mov ballangley,al

    call drawroof
    jmp endfunc

    endfunc:

    ret
    updateballdirectionaftercontactwithroof endp


checkground proc

    mov eax,0
    mov ebx,0
    mov ecx,0
    mov edx,0

    mov al,ballx
    mov bl,bally

    cmp bally,27
    jg groundcontact
    jmp endfunc

    groundcontact:
    
    INVOKE PlaySound, OFFSET groundCollisionSound, NULL, 11h

    dec life_count
    call draw_lives
    call updateball
    call updatepaddle

    ;draw ground 1 again because it disappears after ground collision
    mov eax,red+(red * 16)
    call SetTextColor

    mov dl,0
    mov dh,28
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString

    mov ballanglex,0
    mov ballangley,1
    mov padx,50
    mov pady,27

    ; Make sure ball is at center of the paddle
    mov al, paddle_length
    shr al, 1               ; paddle_length/2
    add al, padx

    mov ballx, al      ; 50         ; padx + paddlelength/2
    
    cmp switchlevel3, 1
    jne skip_this
    mov bally, 16
    jmp move_further
    
    skip_this:
    mov bally,12

    move_further:
    mov eax,1000

    call delay

    jmp endfunc

    endfunc:

    ret
    checkground endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Input checks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


uuserInput PROC

    ;max_x = SCREEN_WIDTH - paddle_length

    ; ????????????? Delay Based on Level ????????????????
    cmp switchlevel3, 1
    je lvl3
    cmp switchlevel2, 1
    je lvl2

lvl1:
    mov eax, 180
    jmp after_delay

lvl2:
    mov eax, 150
    jmp after_delay

lvl3:
    mov eax, 100

after_delay:
    call Delay

    ; ????????????? Read Input ????????????????
    call ReadKey
    mov inputChar, al

    cmp inputChar, "p"
    je PauseScreen

    cmp inputChar, "a"
    je moveLeft

    cmp inputChar, "d"
    je moveRight

    jmp endInput

; ??????????????? Move Right ???????????????????????????
moveRight:

    call updatePaddle     ; erase old paddle

    ; dynamic right boundary:
    movzx eax, paddle_length
    mov ebx, 119   ;120           ; screen width
    sub ebx, eax           ; right_limit = 120 - paddle_length

    cmp padx, bl
    jge endInput           ; block excessive move

    add padx, 3            ; move by +3 (your original speed)
    jmp endInput

; ??????????????? Move Left ????????????????????????????
moveLeft:

    call updatePaddle     ; erase old paddle

    cmp padx, 2
    jle endInput          ; block excessive move

    sub padx, 3           ; move by -3
    jmp endInput

endInput:
    ret

uuserInput ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Ball and Paddle movements
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveball PROC
         
    mov al,ballanglex
    mov bl,ballangley

    add ballx,al
    add bally,bl

    ret
    moveball ENDP


updateBall PROC
    
    mov ax, black
    call setTextColor

    mov al, " "
    mov dl, ballx
    mov dh, bally
    call gotoxy
    call WriteChar
    
    ret 
    updateBall ENDP


drawball proc
    
    mov eax, red+ (black*16)
    call SetTextColor
    ;xor eax, eax
    ;mov ax, black
    ;call setTextColor
    mov al, "O"
    mov dl, ballx
    mov dh, bally
    call gotoxy
    call writechar
    
    ret
    drawball ENDP


    ; New Update Paddle function

updatePaddle PROC

    ; create correct length erase string on the fly
    movzx ecx, paddle_length
    mov edi, offset eraseBuffer

fill_spaces:
    mov byte ptr [edi], ' '
    inc edi
    loop fill_spaces

    mov byte ptr [edi], 0  ; null-terminate eraseBuffer

    ; draw erase buffer at paddle's previous position
    mov ax, black + (black*16)
    call SetTextColor

    mov dl, padx
    mov dh, pady
    call Gotoxy

    mov edx, offset eraseBuffer
    call WriteString

    ret
    call drawrightline ; Called here because it was being bugged in printing
updatePaddle ENDP


drawpaddle2 PROC

    mov ax, yellow+(yellow*16)
    call SetTextColor
    
    mov dl, padx
    mov dh, pady
    call gotoxy

    mov edx, offset paddle2
    call writestring
    
    ret
    drawpaddle2 ENDP

    ; New Drawpaddle Function

drawPaddle PROC

    mov ax, yellow + (yellow * 16)
    call SetTextColor

    mov dl, padx
    mov dh, pady
    call Gotoxy

    ; select correct paddle based on paddle_length
    mov al, paddle_length
    cmp al, 15
    je draw_level1

draw_level2:
    mov edx, offset paddle2
    jmp draw_now

draw_level1:
    mov edx, offset paddle

draw_now:
    call WriteString
    ret

drawPaddle ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Drawing Border and Blocks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawgrid proc

    mov eax,red+(red * 16)
    call SetTextColor

    ;draw roof
    mov dl,0
    mov dh,3
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString

    ;draw ground 1
    mov dl,0
    mov dh,28
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString
    ;draw ground 2
    mov dl,0
    mov dh,29
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString

    ;draw left wall and ground
    mov ecx,27
    mov dh,3
    l1:
    mov dl,0
    call Gotoxy
    mov edx,OFFSET ground1
    call WriteString
    loop l1

    ;draw right wall
    mov ecx,27
    mov dh,3
    ;mov temp,dh
    l2:
    ;mov dh,temp
    mov dl,119
    call Gotoxy
    mov edx,OFFSET ground2
    call WriteString
    inc dh
    loop l2    

    ret
    drawgrid ENDP


horizontal_line proc
    
    mov dl,xline
    mov dh,yline
    call gotoxy
    mov al,"-"
    
    movzx ebx,thickness_y
    l1draw1:
    cmp ebx,0
    je f1
    
    movzx ecx,thickness_x
    l1draw2:
    call writechar
    inc dl
    loop l1draw2
    
    mov edx,offset ground1
    call writestring
    dec ebx
    inc yline
    mov dl,xline
    mov dh,yline
    call gotoxy
    jmp l1draw1
    
    f1:
    
    ret
    horizontal_line endp


draw_lvl1_blocks proc
    
    ; block 1
    mov eax, blue+(blue*16)
    call settextcolor
    mov xline, 1
    mov yline, 3
    mov thickness_x, 22
    mov thickness_y, 3
    call horizontal_line


    ; block 2
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 24
    mov yline, 3
    mov thickness_x, 22
    mov thickness_y, 3
    call horizontal_line


    ; block 3
    mov eax, blue+(blue*16)
    call settextcolor
    mov xline, 47
    mov yline, 3
    mov thickness_x, 22
    mov thickness_y, 3
    call horizontal_line


    ; block 4
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 70
    mov yline, 3
    mov thickness_x, 22
    mov thickness_y, 3
    call horizontal_line


    ; block 5
    mov eax, blue+(blue*16)
    call settextcolor
    mov xline, 93
    mov yline, 3
    mov thickness_x, 25
    mov thickness_y, 3
    call horizontal_line

    ;block 6
    mov eax, 11+(11*16)
    call settextcolor
    mov xline, 1
    mov yline, 6
    mov thickness_x, 22
    mov thickness_y, 3
    call horizontal_line

    ;block 7
    mov eax, 10+(10*16)
    call settextcolor
    mov xline, 24
    mov yline, 6
    mov thickness_x, 22
    mov thickness_y, 3
    call horizontal_line

    ; block8
    mov eax, 11+(11*16)
    call settextcolor
    mov xline, 47
    mov yline, 6
    mov thickness_x, 22
    mov thickness_y, 3
    call horizontal_line

    ;block 9
    mov eax, 10+(10*16)
    call settextcolor
    mov xline, 70
    mov yline, 6
    mov thickness_x, 22
    mov thickness_y, 3
    call horizontal_line

    ;block 10
    mov eax, 11+(11*16)
    call settextcolor
    mov xline, 93
    mov yline, 6
    mov thickness_x, 25
    mov thickness_y, 3
    call horizontal_line
    
    ret
    draw_lvl1_blocks endp


draw_lvl2_blocks proc

    ; block 1
    mov eax, blue+(blue*16)
    call settextcolor
    mov xline, 1
    mov yline, 3
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 2
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 14
    mov yline, 3
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 3
    mov eax, blue+(blue*16)
    call settextcolor
    mov xline, 27
    mov yline, 3
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 4
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 40
    mov yline, 3
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 5
    mov eax, blue+(blue*16)
    call settextcolor
    mov xline, 53
    mov yline, 3
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 6
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 66
    mov yline, 3
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 7
    mov eax, blue+(blue*16)
    call settextcolor
    mov xline, 79
    mov yline, 3
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 8
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 92
    mov yline, 3
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 9
    mov eax, blue+(blue*16)
    call settextcolor
    mov xline, 105
    mov yline, 3
    mov thickness_x, 13
    mov thickness_y, 3
    call horizontal_line

    ; block 10
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 1
    mov yline, 6
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 11
    mov eax, blue+(blue*16)
    call settextcolor
    mov xline, 14
    mov yline, 6
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 12
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 27
    mov yline, 6
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 13
    mov eax, blue+(blue*16)
    call settextcolor
    mov xline, 40
    mov yline, 6
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 14
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 53
    mov yline, 6
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 15
    mov eax, blue+(blue*16)
    call settextcolor
    mov xline, 66
    mov yline, 6
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 16
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 79
    mov yline, 6
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 17
    mov eax, blue+(blue*16)
    call settextcolor
    mov xline, 92
    mov yline, 6
    mov thickness_x, 12
    mov thickness_y, 3
    call horizontal_line

    ; block 18
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 105
    mov yline, 6
    mov thickness_x, 13
    mov thickness_y, 3
    call horizontal_line
    
    ret
    draw_lvl2_blocks endp


draw_lvl3_blocks proc
    
    ; block 1
    mov eax, lightCyan+(lightCyan*16)
    call settextcolor
    mov xline, 1
    mov yline, 3
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 2
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 13
    mov yline, 3
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 3
    mov eax, lightCyan+(lightCyan*16)
    call settextcolor
    mov xline, 25
    mov yline, 3
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 4
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 37
    mov yline, 3
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line
    
    ; block 5
    mov eax, lightCyan+(lightCyan*16)
    call settextcolor
    mov xline, 49
    mov yline, 3
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 6
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 61
    mov yline, 3
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 7
    mov eax, lightCyan+(lightCyan*16)
    call settextcolor
    mov xline, 73
    mov yline, 3
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 8
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 85
    mov yline, 3
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 9
    mov eax, lightCyan+(lightCyan*16)
    call settextcolor
    mov xline, 97
    mov yline, 3
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 10
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 109
    mov yline, 3
    mov thickness_x, 9
    mov thickness_y, 3
    call horizontal_line

    ; block 11
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 1
    mov yline, 6
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 12
    mov eax, lightCyan+(lightCyan*16)
    call settextcolor
    mov xline, 13
    mov yline, 6
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 13
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 25
    mov yline, 6
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 14
    mov eax, lightCyan+(lightCyan*16)
    call settextcolor
    mov xline, 37
    mov yline, 6
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line
    
    ; block 15
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 49
    mov yline, 6
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 16
    mov eax, lightCyan+(lightCyan*16)
    call settextcolor
    mov xline, 61
    mov yline, 6
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 17
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 73
    mov yline, 6
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 18
    mov eax, lightCyan+(lightCyan*16)
    call settextcolor
    mov xline, 85
    mov yline, 6
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 19
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 97
    mov yline, 6
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 20
    mov eax, lightCyan+(lightCyan*16)
    call settextcolor
    mov xline, 109
    mov yline, 6
    mov thickness_x, 9
    mov thickness_y, 3
    call horizontal_line

    ; block 21
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 31
    mov yline, 9
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line
    
    ; block 22
    mov eax, lightCyan+(lightCyan*16)
    call settextcolor
    mov xline, 43
    mov yline, 9
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 23
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 55
    mov yline, 9
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ; block 24
    mov eax, lightCyan+(lightCyan*16)
    call settextcolor
    mov xline, 67
    mov yline, 9
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line
    
    ; block 25
    mov eax, cyan+(cyan*16)
    call settextcolor
    mov xline, 79
    mov yline, 9
    mov thickness_x, 11
    mov thickness_y, 3
    call horizontal_line

    ret
    draw_lvl3_blocks endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Level1 Blocks Checks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_lvl1_blocks proc
    
    ; block 1
    mov al,l1_b1_stat
    mov stat,al
    mov vertexx1, 1
    mov vertexx2, 23
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,22
    mov ty,3
    call l1_blocks_check
    mov al,stat
    mov l1_b1_stat,al

    ;block 2
    mov al,l1_b2_stat
    mov stat,al
    mov vertexx1, 24
    mov vertexx2, 46
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,22
    mov ty,3
    call l1_blocks_check
    mov al,stat
    mov l1_b2_stat,al

    ; block 3
    mov al,l1_b3_stat
    mov stat,al
    mov vertexx1, 47
    mov vertexx2, 69
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,22
    mov ty,3
    call l1_blocks_check
    mov al,stat
    mov l1_b3_stat,al

    ; block 4
    mov al,l1_b4_stat
    mov stat,al
    mov vertexx1, 70
    mov vertexx2, 92
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,22
    mov ty,3
    call l1_blocks_check
    mov al,stat
    mov l1_b4_stat,al

    ; block 5
    mov al,l1_b5_stat
    mov stat,al
    mov vertexx1, 93
    mov vertexx2, 118
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,25
    mov ty,3
    call l1_blocks_check
    mov al,stat
    mov l1_b5_stat,al

    ;block 6
    mov al,l1_b6_stat
    mov stat,al
    mov vertexx1, 1
    mov vertexx2, 23
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,22
    mov ty,3
    call l1_blocks_check
    mov al,stat
    mov l1_b6_stat,al

    ;block 7
    mov al,l1_b7_stat
    mov stat,al
    mov vertexx1, 24
    mov vertexx2, 46
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,22
    mov ty,3
    call l1_blocks_check
    mov al,stat
    mov l1_b7_stat,al
    
    ; block 8
    mov al,l1_b8_stat
    mov stat,al
    mov vertexx1, 47
    mov vertexx2, 69
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,22
    mov ty,3
    call l1_blocks_check
    mov al,stat
    mov l1_b8_stat,al

    ;block 9
    mov al,l1_b9_stat
    mov stat,al
    mov vertexx1, 70
    mov vertexx2, 92
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,22
    mov ty,3
    call l1_blocks_check
    mov al,stat
    mov l1_b9_stat,al

    ;block 10
    mov al,l1_b10_stat
    mov stat,al
    mov vertexx1, 93
    mov vertexx2, 118
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,25
    mov ty,3
    call l1_blocks_check
    mov al,stat
    mov l1_b10_stat,al


    ret
    check_lvl1_blocks endp


l1_blocks_check proc
    
    cmp stat,0
    je blockdestroyed

    downcheck:
    mov al, vertexy2
    cmp bally,al
    jl checkdowny1
    jmp leftcheck

    checkdowny1:
    mov al, vertexy1
    cmp bally,al
    jge checkdownx1
    jmp leftcheck

    checkdownx1:
    mov al, vertexx1
    cmp ballx,al
    jge checkdownx2
    jmp leftcheck

    checkdownx2:
    mov al, vertexx2
    cmp ballx, al
    jle contactwithbottomofblock
    jmp leftcheck

    contactwithbottomofblock:
    mov al,ballangley
    mov cl,-1
    imul cl
    mov ballangley,al
    dec stat
    jmp checkcomplete





    leftcheck:
    mov al, vertexx1
    dec al
    cmp ballx, al 
    jge checkleftx1
    jmp rightcheck

    checkleftx1:
    mov al, vertexx2
    cmp ballx, al
    jl checklefty1
    jmp rightcheck

    checklefty1:
    mov al, vertexy1
    ;inc al
    cmp bally,al
    jge checklefty2
    jmp rightcheck

    checklefty2:
    mov al, vertexy2
    dec al
    cmp bally, al 
    jle contactwithleftofblock
    jmp rightcheck

    contactwithleftofblock:
    mov al,ballanglex
    mov cl,-1
    imul cl
    mov ballanglex,al
    dec stat
    jmp checkcomplete





    rightcheck:
    mov al, vertexx2
    inc al
    cmp ballx, al
    jle checkrightx1
    jmp upcheck

    checkrightx1:
    mov al, vertexx1
    inc al
    cmp ballx, al 
    jg checkrighty1
    jmp upcheck

    checkrighty1:
    mov al, vertexy1
    ;inc al
    cmp bally, al
    jge checkrighty2
    jmp upcheck

    checkrighty2:
    mov al, vertexy2
    dec al
    cmp bally, al
    jle contactwithrightofblock
    jmp upcheck

    contactwithrightofblock:
    mov al,ballanglex
    mov cl,-1
    imul cl
    mov ballanglex,al
    dec stat
    jmp checkcomplete





    upcheck:
    mov al, vertexy1
    cmp bally,al
    jge checkupy1
    jmp checkcomplete

    checkupy1:
    mov al, vertexy2
    dec al
    dec al
    cmp bally, al
    jle checkupx1
    jmp checkcomplete

    checkupx1:
    mov al, vertexx1
    ;dec al
    cmp ballx, al
    jge checkupx2
    jmp checkcomplete

    checkupx2:
    mov al, vertexx2
    ;inc al
    cmp ballx, al
    jle contactwithtopofblock
    jmp checkcomplete

    contactwithtopofblock:
    mov al,ballangley
    mov cl,-1
    imul cl
    mov ballangley,al
    dec stat
    jmp checkcomplete





    checkcomplete:
    cmp stat,0
    jne blocknotdestroyed
    
    INVOKE PlaySound, OFFSET thirdHitSound, NULL, 11h

    add score_count,100
    cmp score_count,1000
    jne cont
    mov bl, 1
    mov switchlevel2, bl
    ret
    cont:
    push eax
    mov eax, black+(black*16)
    call settextcolor
    mov al,vertexx1
    mov xline, al
    mov al,vertexy1
    inc al
    mov yline, al
    mov al,tx
    mov bl,ty
    mov thickness_x, al
    mov thickness_y, bl
    call horizontal_line
    pop eax


    blockdestroyed:

    blocknotdestroyed:
    
    ret
    l1_blocks_check endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Level2 Blocks Checks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; New function implmentation

changecolor PROC
    push eax
    push ebx
    push ecx

    movzx eax, stat3     ; eax = remaining hits for THIS brick

    cmp eax, 3
    je freshColor        ; full HP ? lightCyan

    cmp eax, 2
    je damaged1          ; 2 hits left ? lightMagenta

    cmp eax, 1
    je damaged2          ; 1 hit left ? gray

    jmp done             ; 0 ? do nothing (brick will be removed)

freshColor:
    mov eax, lightCyan+(lightCyan*16) ;11          ; lightCyan
    jmp apply

damaged1:
    mov eax, lightMagenta+(lightMagenta*16) ;13          ; lightMagenta
    jmp apply

damaged2:
    mov eax, gray+(gray*16)  ;7           ; gray

apply:
    call SetTextColor

    ; now draw brick with new color
    mov  al, vertexx1
    mov  xline, al
    mov  al, vertexy1
    inc  al
    mov  yline, al
    mov  al, tx
    mov  bl, ty
    mov  thickness_x, al
    mov  thickness_y, bl
    call horizontal_line

done:
    pop ecx
    pop ebx
    pop eax
    ret

changecolor ENDP


check_lvl2_blocks proc

    ; block 1
    mov al,l2_b1_stat
    mov stat2,al
    mov vertexx1, 1
    mov vertexx2, 13
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b1_stat,al

    ;block 2
    mov al,l2_b2_stat
    mov stat2,al
    mov vertexx1, 14
    mov vertexx2, 26
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b2_stat,al

    ; block 3
    mov al,l2_b3_stat
    mov stat2,al
    mov vertexx1, 27
    mov vertexx2, 39
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b3_stat,al

    ; block 4
    mov al,l2_b4_stat
    mov stat2,al
    mov vertexx1, 40
    mov vertexx2, 52
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b4_stat,al

    ; block 5
    mov al,l2_b5_stat
    mov stat2,al
    mov vertexx1, 53
    mov vertexx2, 65
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b5_stat,al

    ;block 6
    mov al,l2_b6_stat
    mov stat2,al
    mov vertexx1, 66
    mov vertexx2, 78
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b6_stat,al

    ;block 7
    mov al,l2_b7_stat
    mov stat2,al
    mov vertexx1, 79
    mov vertexx2, 91
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b7_stat,al
    
    ; block 8
    mov al,l2_b8_stat
    mov stat2,al
    mov vertexx1, 92
    mov vertexx2, 104
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b8_stat,al

    ;block 9
    mov al,l2_b9_stat
    mov stat2,al
    mov vertexx1, 105
    mov vertexx2, 118
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,13
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b9_stat,al

    ;block 10
    mov al,l2_b10_stat
    mov stat2,al
    mov vertexx1, 1
    mov vertexx2, 13
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b10_stat,al

    ;block 11
    mov al,l2_b11_stat
    mov stat2,al
    mov vertexx1, 14
    mov vertexx2, 26
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b11_stat,al

    ; block 12
    mov al,l2_b12_stat
    mov stat2,al
    mov vertexx1, 27
    mov vertexx2, 39
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b12_stat,al

    ; block 13
    mov al,l2_b13_stat
    mov stat2,al
    mov vertexx1, 40
    mov vertexx2, 52
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b13_stat,al

    ; block 14
    mov al,l2_b14_stat
    mov stat2,al
    mov vertexx1, 53
    mov vertexx2, 65
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b14_stat,al

    ;block 15
    mov al,l2_b15_stat
    mov stat2,al
    mov vertexx1, 66
    mov vertexx2, 78
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b15_stat,al

    ;block 16
    mov al,l2_b16_stat
    mov stat2,al
    mov vertexx1, 79
    mov vertexx2, 91
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b16_stat,al
    
    ; block 17
    mov al,l2_b17_stat
    mov stat2,al
    mov vertexx1, 92
    mov vertexx2, 104
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,12
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b17_stat,al

    ;block 18
    mov al,l2_b18_stat
    mov stat2,al
    mov vertexx1, 105
    mov vertexx2, 118
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,13
    mov ty,3
    call l2_blocks_check
    mov al,stat2
    mov l2_b18_stat,al

    ret
    check_lvl2_blocks endp


l2_blocks_check proc
    
    cmp stat2,0
    je blockdestroyed

    downcheck:
    mov al, vertexy2
    cmp bally,al
    jl checkdowny1
    jmp leftcheck

    checkdowny1:
    mov al, vertexy1
    cmp bally,al
    jge checkdownx1
    jmp leftcheck

    checkdownx1:
    mov al, vertexx1
    cmp ballx,al
    jge checkdownx2
    jmp leftcheck

    checkdownx2:
    mov al, vertexx2
    cmp ballx, al
    jle contactwithbottomofblock
    jmp leftcheck

    contactwithbottomofblock:
    ;New stuff adding
    cmp stat2, 2
    jne never_mind_bottom
    INVOKE PlaySound, OFFSET secondHitSound, NULL, 11h

    never_mind_bottom:

    mov al,ballangley
    mov cl,-1
    imul cl
    mov ballangley,al
    dec stat2
    call changecolor
    jmp checkcomplete





    leftcheck:
    mov al, vertexx1
    dec al
    cmp ballx, al 
    jge checkleftx1
    jmp rightcheck

    checkleftx1:
    mov al, vertexx2
    cmp ballx, al
    jl checklefty1
    jmp rightcheck

    checklefty1:
    mov al, vertexy1
    ;inc al
    cmp bally,al
    jge checklefty2
    jmp rightcheck

    checklefty2:
    mov al, vertexy2
    dec al
    cmp bally, al 
    jle contactwithleftofblock
    jmp rightcheck

    contactwithleftofblock:
    ;New stuff adding
    cmp stat2, 2
    jne never_mind_left
    INVOKE PlaySound, OFFSET secondHitSound, NULL, 11h

    never_mind_left:

    mov al,ballanglex
    mov cl,-1
    imul cl
    mov ballanglex,al
    dec stat2
    call changecolor
    jmp checkcomplete





    rightcheck:
    mov al, vertexx2
    inc al
    cmp ballx, al
    jle checkrightx1
    jmp upcheck

    checkrightx1:
    mov al, vertexx1
    inc al
    cmp ballx, al 
    jg checkrighty1
    jmp upcheck

    checkrighty1:
    mov al, vertexy1
    ;inc al
    cmp bally, al
    jge checkrighty2
    jmp upcheck

    checkrighty2:
    mov al, vertexy2
    dec al
    cmp bally, al
    jle contactwithrightofblock
    jmp upcheck

    contactwithrightofblock:
    ;New stuff adding
    cmp stat2, 2
    jne never_mind_right
    INVOKE PlaySound, OFFSET secondHitSound, NULL, 11h

    never_mind_right:

    mov al,ballanglex
    mov cl,-1
    imul cl
    mov ballanglex,al
    dec stat2
    call changecolor
    jmp checkcomplete





    upcheck:
    mov al, vertexy1
    cmp bally,al
    jge checkupy1
    jmp checkcomplete

    checkupy1:
    mov al, vertexy2
    dec al
    dec al
    cmp bally, al
    jle checkupx1
    jmp checkcomplete

    checkupx1:
    mov al, vertexx1
    ;dec al
    cmp ballx, al
    jge checkupx2
    jmp checkcomplete

    checkupx2:
    mov al, vertexx2
    ;inc al
    cmp ballx, al
    jle contactwithtopofblock
    jmp checkcomplete

    contactwithtopofblock:
    ;New stuff adding
    cmp stat2, 2
    jne never_mind_top
    INVOKE PlaySound, OFFSET secondHitSound, NULL, 11h

    never_mind_top:

    mov al,ballangley
    mov cl,-1
    imul cl
    mov ballangley,al
    dec stat2
    call changecolor
    jmp checkcomplete





    checkcomplete:
    ;cmp stat2,1
    ;je changecolor

    cmp stat2,0
    jne blocknotdestroyed
    
    INVOKE PlaySound, OFFSET thirdHitSound, NULL, 11h

    add score_count,200
    cmp score_count,4600
    jne cont
    mov bl, 1
    mov switchlevel3, bl
    ret

    cont:
    push eax
    mov eax, black+(black*16)
    call settextcolor
    mov al,vertexx1
    mov xline, al
    mov al,vertexy1
    inc al
    mov yline, al
    mov al,tx
    mov bl,ty
    mov thickness_x, al
    mov thickness_y, bl
    call horizontal_line
    pop eax
    jmp blockdestroyed


    ;changecolor:
    ;call colorchange

    blockdestroyed:

    blocknotdestroyed:
    
    ret
    l2_blocks_check endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Level3 Blocks Checks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
checkpaddle proc
    
    mov eax,0
    mov ebx,0
    mov ecx,0
    mov edx,0

    mov al,padx
    dec al
    mov cl,padx
    add cl,15

    mov bl,pady
    dec bl

    cmp bonusy,bl
    je checkx1
    jmp ballnotonpaddle
    
    checkx1:
    cmp bonusx,al
    jge checkx2
    jmp ballmissingpaddle

    checkx2:
    cmp bonusx,cl
    jle ballonpaddle
    jmp ballmissingpaddle





    ballonpaddle:
    inc life_count
    mov bonustaken,1

    mov dl,bonusx
    mov dh,bonusy
    call gotoxy

    push eax

    mov eax,black+(black*16)
    call settextcolor
    mov al,' '
    call writechar

    pop eax
     
    jmp endfunc


    ballnotonpaddle:

    ballmissingpaddle:

    endfunc:

    ret
    checkpaddle endp


drawobject proc

    cmp bonusy,27
    jg ending
    
    push eax

    mov dl,bonusx
    mov dh,bonusy
    call gotoxy

    mov eax,red+(black*16)
    call settextcolor

    mov al,'+'
    call writechar

    pop eax

    jmp notending

    ending:
    mov bonustaken,1

    push eax

    mov dl,bonusx
    mov dh,bonusy
    call gotoxy

    mov eax,black+(black*16)

    mov al,' '
    call writechar

    pop eax

    notending:

    ret
    drawobject endp


updateobject proc

    push eax

    mov dl,bonusx
    mov dh,bonusy
    call gotoxy

    mov eax,black+(black*16)
    call settextcolor

    mov al,' '
    call writechar

    inc bonusy
    call drawobject

    pop eax

    ret
    updateobject endp


lvl3bonus proc

    cmp bonustaken,1
    je done

    call updateobject

    call checkpaddle

    done:

    ret
    lvl3bonus endp


destroyrandomblocks proc

    cmp l3_b15_stat,0                   ;cmp l3_b23_stat,0
    jne dontdestroy

    call lvl3bonus
    ; Commented deleting random blocks because it's casuing score to halt
    dontdestroy:

    ret
    destroyrandomblocks endp


check_lvl3_blocks proc

    ; block 1
    mov al,l3_b1_stat
    mov stat3,al
    mov vertexx1, 1
    mov vertexx2, 12
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b1_stat,al

    ;block 2
    mov al,l3_b2_stat
    mov stat3,al
    mov vertexx1, 13
    mov vertexx2, 24
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b2_stat,al

    ; block 3
    mov al,l3_b3_stat
    mov stat3,al
    mov vertexx1, 25
    mov vertexx2, 36
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b3_stat,al

    ; block 4
    mov al,l3_b4_stat
    mov stat3,al
    mov vertexx1, 37
    mov vertexx2, 48
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b4_stat,al

    ; block 5
    mov al,l3_b5_stat
    mov stat3,al
    mov vertexx1, 49
    mov vertexx2, 60
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b5_stat,al

    ;block 6
    mov al,l3_b6_stat
    mov stat3,al
    mov vertexx1, 61
    mov vertexx2, 72
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b6_stat,al

    ;block 7
    mov al,l3_b7_stat
    mov stat3,al
    mov vertexx1, 73
    mov vertexx2, 84
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b7_stat,al
    
    ; block 8
    mov al,l3_b8_stat
    mov stat3,al
    mov vertexx1, 85
    mov vertexx2, 96
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b8_stat,al

    ;block 9
    mov al,l3_b9_stat
    mov stat3,al
    mov vertexx1, 97
    mov vertexx2, 108
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b9_stat,al

    ;block 10
    mov al,l3_b10_stat
    mov stat3,al
    mov vertexx1, 109
    mov vertexx2, 118
    mov vertexy1, 2
    mov vertexy2, 7
    mov tx,9
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b10_stat,al

    ; block 11
    mov al,l3_b11_stat
    mov stat3,al
    mov vertexx1, 1
    mov vertexx2, 12
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b11_stat,al

    ;block 12
    mov al,l3_b12_stat
    mov stat3,al
    mov vertexx1, 13
    mov vertexx2, 24
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b12_stat,al

    ; block 13
    mov al,l3_b13_stat
    mov stat3,al
    mov vertexx1, 25
    mov vertexx2, 36
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b13_stat,al

    ; block 14
    mov al,l3_b14_stat
    mov stat3,al
    mov vertexx1, 37
    mov vertexx2, 48
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b14_stat,al

    ; block 15
    mov al,l3_b15_stat
    mov stat3,al
    mov vertexx1, 49
    mov vertexx2, 60
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b15_stat,al

    ;block 16
    mov al,l3_b16_stat
    mov stat3,al
    mov vertexx1, 61
    mov vertexx2, 72
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b16_stat,al

    ;block 17
    mov al,l3_b17_stat
    mov stat3,al
    mov vertexx1, 73
    mov vertexx2, 84
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b17_stat,al
    
    ; block 18
    mov al,l3_b18_stat
    mov stat3,al
    mov vertexx1, 85
    mov vertexx2, 96
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b18_stat,al

    ;block 19
    mov al,l3_b19_stat
    mov stat3,al
    mov vertexx1, 97
    mov vertexx2, 108
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b19_stat,al

    ;block 20
    mov al,l3_b20_stat
    mov stat3,al
    mov vertexx1, 109
    mov vertexx2, 118
    mov vertexy1, 5
    mov vertexy2, 10
    mov tx,9
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b20_stat,al

    ; block 21
    mov al,l3_b21_stat
    mov stat3,al
    mov vertexx1, 31
    mov vertexx2, 42
    mov vertexy1, 8
    mov vertexy2, 13
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b21_stat,al
    
    ; block 22
    mov al,l3_b22_stat
    mov stat3,al
    mov vertexx1, 43
    mov vertexx2, 54
    mov vertexy1, 8
    mov vertexy2, 13
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b22_stat,al

    ; block 23
    mov al,l3_b23_stat
    mov stat3,al
    mov vertexx1, 55
    mov vertexx2, 66
    mov vertexy1, 8
    mov vertexy2, 13
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b23_stat,al
    call destroyrandomblocks

    ; block 24
    mov al,l3_b24_stat
    mov stat3,al
    mov vertexx1, 67
    mov vertexx2, 78
    mov vertexy1, 8
    mov vertexy2, 13
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b24_stat,al
    
    ; block 25
    mov al,l3_b25_stat
    mov stat3,al
    mov vertexx1, 79
    mov vertexx2, 90
    mov vertexy1, 8
    mov vertexy2, 13
    mov tx,11
    mov ty,3
    call l3_blocks_check
    mov al,stat3
    mov l3_b25_stat,al

    ret
    check_lvl3_blocks endp


l3_blocks_check proc
    
    cmp stat3,0
    je blockdestroyed

    downcheck:
    mov al, vertexy2
    cmp bally,al
    jl checkdowny1
    jmp leftcheck

    checkdowny1:
    mov al, vertexy1
    cmp bally,al
    jge checkdownx1
    jmp leftcheck

    checkdownx1:
    mov al, vertexx1
    cmp ballx,al
    jge checkdownx2
    jmp leftcheck

    checkdownx2:
    mov al, vertexx2
    cmp ballx, al
    jle contactwithbottomofblock
    jmp leftcheck

    contactwithbottomofblock:
    ;New stuff adding
    cmp stat3, 3
    jne  kahin_aur_bottom
    INVOKE PlaySound, OFFSET firstHitSound, NULL, 11h
    kahin_aur_bottom:
    cmp stat3, 2
    jne never_mind_bottom
    INVOKE PlaySound, OFFSET secondHitSound, NULL, 11h

    never_mind_bottom:

    mov al,ballangley
    mov cl,-1
    imul cl
    mov ballangley,al
    dec stat3
    call changecolor
    jmp checkcomplete





    leftcheck:
    mov al, vertexx1
    dec al
    cmp ballx, al 
    jge checkleftx1
    jmp rightcheck

    checkleftx1:
    mov al, vertexx2
    cmp ballx, al
    jl checklefty1
    jmp rightcheck

    checklefty1:
    mov al, vertexy1
    ;inc al
    cmp bally,al
    jge checklefty2
    jmp rightcheck

    checklefty2:
    mov al, vertexy2
    dec al
    cmp bally, al 
    jle contactwithleftofblock
    jmp rightcheck

    contactwithleftofblock:
    ;New stuff adding
    cmp stat3, 3
    jne  kahin_aur_left
    INVOKE PlaySound, OFFSET firstHitSound, NULL, 11h
    kahin_aur_left:
    cmp stat3, 2
    jne never_mind_left
    INVOKE PlaySound, OFFSET secondHitSound, NULL, 11h

    never_mind_left:

    mov al,ballanglex
    mov cl,-1
    imul cl
    mov ballanglex,al
    dec stat3
    call changecolor
    jmp checkcomplete





    rightcheck:
    mov al, vertexx2
    inc al
    cmp ballx, al
    jle checkrightx1
    jmp upcheck

    checkrightx1:
    mov al, vertexx1
    inc al
    cmp ballx, al 
    jg checkrighty1
    jmp upcheck

    checkrighty1:
    mov al, vertexy1
    ;inc al
    cmp bally, al
    jge checkrighty2
    jmp upcheck

    checkrighty2:
    mov al, vertexy2
    dec al
    cmp bally, al
    jle contactwithrightofblock
    jmp upcheck

    contactwithrightofblock:
    ;New stuff adding
    cmp stat3, 3
    jne  kahin_aur_right
    INVOKE PlaySound, OFFSET firstHitSound, NULL, 11h
    kahin_aur_right:
    cmp stat3, 2
    jne never_mind_right
    INVOKE PlaySound, OFFSET secondHitSound, NULL, 11h

    never_mind_right:

    mov al,ballanglex
    mov cl,-1
    imul cl
    mov ballanglex,al
    dec stat3
    call changecolor
    jmp checkcomplete





    upcheck:
    mov al, vertexy1
    cmp bally,al
    jge checkupy1
    jmp checkcomplete

    checkupy1:
    mov al, vertexy2
    dec al
    dec al
    cmp bally, al
    jle checkupx1
    jmp checkcomplete

    checkupx1:
    mov al, vertexx1
    ;dec al
    cmp ballx, al
    jge checkupx2
    jmp checkcomplete

    checkupx2:
    mov al, vertexx2
    ;inc al
    cmp ballx, al
    jle contactwithtopofblock
    jmp checkcomplete

    contactwithtopofblock:
    ;New stuff adding
    cmp stat3, 3
    jne  kahin_aur_top
    INVOKE PlaySound, OFFSET firstHitSound, NULL, 11h
    kahin_aur_top:
    cmp stat3, 2
    jne never_mind_top
    INVOKE PlaySound, OFFSET secondHitSound, NULL, 11h

    never_mind_top:

    mov al,ballangley
    mov cl,-1
    imul cl
    mov ballangley,al
    dec stat3
    call changecolor
    jmp checkcomplete





    checkcomplete:

    cmp stat3,0
    jne blocknotdestroyed
    
    INVOKE PlaySound, OFFSET thirdHitSound, NULL, 11h

    add score_count,300
    push eax
    mov eax, black+(black*16)
    call settextcolor
    mov al,vertexx1
    mov xline, al
    mov al,vertexy1
    inc al
    mov yline, al
    mov al,tx
    mov bl,ty
    mov thickness_x, al
    mov thickness_y, bl
    call horizontal_line
    pop eax
    jmp blockdestroyed


    blockdestroyed:

    blocknotdestroyed:
    
    ret
    l3_blocks_check endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Score, Lives and Level
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
draw_lives proc
    
    call checklives
    
    mov eax, white(black* 16)
    call SetTextColor
    mov dl, 3
    mov dh, 1
    call Gotoxy
    mov edx, offset lives
    call WriteString  
    
    mov dh,1
    mov dl,11
    call gotoxy

    mov ecx,4 ; max_lives possible = 4
    l2:

    call gotoxy
    mov al,' '
    call writechar
    inc dl

    loop l2


    mov dl, 11
    mov dh,1
    call gotoxy
    mov ecx,0
    mov cl,life_count
    l1:

    call gotoxy
    mov al,'X'
    call writechar
    inc dl

    loop l1

    done:

    ret
    draw_lives endp


draw_score proc
    
    mov eax, white(black* 16)
    call SetTextColor
    mov dl, 54
    mov dh, 1
    call Gotoxy
    mov edx, offset score
    call WriteString  
    
    ;inc dl
    mov dl, 61
    mov dh, 1
    call Gotoxy

    mov eax,0
    mov eax,score_count
    call writeDec

    call checkscore

    ret
    draw_score endp


draw_level proc

    mov eax, white(black* 16)
    call SetTextColor
    mov dl, 107
    mov dh, 1
    call Gotoxy
    mov edx, offset level
    call WriteString  
    
    mov dl, 114
    mov dh, 1
    call Gotoxy

    mov eax,0
    mov al,level_count
    call writeDec   

    ret
    draw_level endp


checklives proc

    cmp life_count,0
    jne continueplaying

    call youlost

    continueplaying:

    ret
    checklives endp


checkscore proc

    cmp score_count, Win_score     ;12100
    jl continueplaying

    call youwon

    continueplaying:

    ret
    checkscore endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Win and Lose Screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Original
youwon proc

    mov eax,red+(yellow*16)
    call settextcolor

    call clrscr

    mov edx,offset WinnerStr
    call writestring

    mov dl,53
    mov dh,24
    call gotoxy
    mov edx,offset strname1
    call writestring
    mov edx,offset strname
    call writestring

    mov dl,53
    mov dh,25
    call gotoxy
    mov edx,offset score
    call writestring
    mov eax,0
    mov eax,score_count
    call writeDec

    mov dl,53
    mov dh,32
    call gotoxy

    call ReadChar
    ;call waitmsg
    call clrscr
    call file_handling
    exit

    ret
    youwon endp


youlost proc
    
    mov eax,red+(yellow*16)
    call settextcolor

    call clrscr

    mov dl,53
    mov dh, 21                  ;13
    call gotoxy

    mov edx,offset gameOverStr1
    call writestring

    mov dl,53
    mov dh, 24                     ;15
    call gotoxy
    mov edx,offset strname1
    call writestring
    mov edx,offset strname
    call writestring

    mov dl,53
    mov dh, 25                      ;16
    call gotoxy
    mov edx,offset score
    call writestring
    mov eax,0
    mov eax,score_count
    call writeDec

    mov dl,53
    mov dh,26                          ;17
    call gotoxy
    mov edx,offset level
    call writestring
    mov eax,0
    mov al,level_count
    call writeDec

    mov dl,53
    mov dh,32
    call gotoxy
    
    call ReadChar
    ;call waitmsg
    call clrscr
    call file_handling
    exit

    ret
    youlost endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;Add Delay
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Delayy PROC
    push ecx
    mov ecx, 50000000 ; Adjust this value to control the delay
    delay_loop:
    loop delay_loop
    pop ecx
    ret
    Delayy ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main PROC

call clrscr

call MainMenu

call clrscr

cmp switchlevel2, 1
    je bhaaglevel2
    cmp switchlevel3, 1
    je bhaaglevel3


        ; Switch to Level 1 paddle
        mov paddle_length, 15

        mov padx,50
        mov pady,27

        ; Make sure ball is at center of the paddle
        mov al, paddle_length
        shr al, 1               ; paddle_length/2
        add al, padx

        mov ballx, al      ; 50         ; padx + paddlelength/2
        mov bally,12 

call drawgrid          ; draws grid


call draw_lvl1_blocks       ; draws blocks


    gameloop:
        cmp switchlevel2, 1
        je bhaaglevel2

        call draw_lives
        
        call draw_score
    
        call draw_level

        ; Switch to Level 1 paddle
        mov paddle_length, 15
    
        call drawpaddle        ; draws paddle
    
        call drawball          ; draws ball

        call drawleftline

        call drawroof
        
        call uuserInput         ; checks user input
    
    
        call updateballdirectionaftercontactwithpaddle
    
        call updateballdirectionaftercontactwithleftwall
    
        call updateballdirectionaftercontactwithrightwall
    
        call updateballdirectionaftercontactwithroof
    
        call checkground
    
    
        call check_lvl1_blocks
      
    
        call updateBall        ; removes previous position of ball by " " on previous co-ordinates
    
        call moveball          ; moves the ball downward
        
    
    
        
        jmp gameloop


  
        bhaaglevel2:

        mov ballanglex,0
        mov ballangley,1

        call clrscr
        call waitmsg

        ; Switch to Level 2 paddle
        mov paddle_length, 10

        mov padx,52   ; Because it 5 units smaller then the paddle of level1
        mov pady,27

        ; Make sure ball is at center of the paddle
        mov al, paddle_length
        shr al, 1               ; paddle_length/2
        add al, padx

        mov ballx, al      ; 50         ; padx + paddlelength/2
        mov bally,12        

        mov level_count,2
        mov score_count,1000

        call drawgrid          ; draws grid



call draw_lvl2_blocks

    gameloop2:
    cmp switchlevel3, 1
    je bhaaglevel3

        call draw_lives
        
        call draw_score
    
        call draw_level

        ; Switch to Level 2 paddle
        mov paddle_length, 10
    
        call drawpaddle

        call drawball          ; draws ball

        call drawleftline

        call drawroof
        
        call uuserInput         ; checks user input
    
    
        call updateballdirectionaftercontactwithpaddle2
    
        call updateballdirectionaftercontactwithleftwall
    
        call updateballdirectionaftercontactwithrightwall
    
        call updateballdirectionaftercontactwithroof
    
        call checkground     
       
        call check_lvl2_blocks
    
        call updateBall        ; removes previous position of ball by " " on previous co-ordinates
    
        call moveball          ; moves the ball downward
        
    
    
        
        jmp gameloop2




        bhaaglevel3:

        mov ballanglex,0
        mov ballangley,1

        call clrscr
        call waitmsg

        ; Switch to Level 3 paddle
        mov paddle_length, 15

        mov padx,50
        mov pady,27

        ; Make sure ball is at center of the paddle
        mov al, paddle_length
        shr al, 1               ; paddle_length/2
        add al, padx

        mov ballx, al      ; 50         ; padx + paddlelength/2
        mov bally, 16      ;Increase because level 3 is big  ;12 

        mov level_count,3
        mov score_count,4600

        call drawgrid          ; draws grid



call draw_lvl3_blocks


    gameloop3:

        call draw_lives
        
        call draw_score
    
        call draw_level

        ; Switch to Level 3 paddle
        mov paddle_length, 15
    
        call drawpaddle        ; draws paddle
    
        call drawball          ; draws ball

        call drawleftline

        call drawroof
        
        call uuserInput         ; checks user input
    
    
        call updateballdirectionaftercontactwithpaddle
    
        call updateballdirectionaftercontactwithleftwall
    
        call updateballdirectionaftercontactwithrightwall
    
        call updateballdirectionaftercontactwithroof
    
        call checkground
    
    
     
    
        
       
        call check_lvl3_blocks
    
      
    
        call updateBall        ; removes previous position of ball by " " on previous co-ordinates
    
        call moveball          ; moves the ball downward
        
    
    
        
        jmp gameloop3




 exitGame:

    call clrscr

    call file_handling

    exit

main ENDP
END main