RS EQU P2.0               ; dinh nghia RS la P2.0
RW EQU P2.1               ; dinh nghia RW la P2.1
E  EQU P2.2               ; dinh nghia E la P2.2
ORG 30H                   ; origin
      MOV DPTR,#LUT       ; di chuyen dia chi bat dau LUT vao DPTR
      CLR P3.5           ; xoa P3.0(output)
      SETB P3.2           ; set p3.1(input)
      MOV TMOD,#00100000B ; sets Timer1 la Mode2 timer 
      ACALL DINT          ; goi ham DINT
      ACALL TEXT1         ; goi ham TEXT1
MAIN:      MOV TL1,#200D       ; gan TL1 = 200
      MOV TH1,#200D       ; gan TH1 = 200
      MOV A,#00000000B    ; gan A
      SETB P3.5           ; sets P3.5(trigger)
      ACALL DELAY1      ; goi ham DELAY1 (10uS)
      CLR P3.5            ; xoa P3.5
      HERE: JNB P3.2,HERE ; lap lai o day cho den khi chan echo nhan duoc giu lieu
 BACK:SETB TR1            ; bat dau Timer1
HERE1:JNB TF1,HERE1       ; lap lai o day cho den khi Timer1 tran
      CLR TR1             ; dung Timer1
      CLR TF1             ; xoa co Timer 1
      INC A               ; Tang A
      JB P3.2,BACK        ; Nhay den ham BACK neu echo van con
      MOV R7,A            ; luu gia tri A -> R7
      ACALL SPLIT         ; goi ham SPLIT
      ACALL LINE2         ; goi ham LINE2 : dua con tro xuong dong 2
      ACALL LEVEL         ; goi ham LEVEL
      ACALL TEXT2         ; goi ham TEXT2
	  ACALL DELAY1M       ; goi ham delay 1ms
      SJMP MAIN           ; Quay lai ham MAIN

DELAY1: MOV R6,#2D        ; Gan gia tri tai R6 bang 2D
LABEL1: DJNZ R6,LABEL1    ; R6 --, va lap den khi R6 = 0
        RET               ; Quay lai ham chinh

DELAY2:MOV R0,#15D        ; R0 = 15
BACK1: MOV TH0,#00000000B ; TH0 = 00000000B 
       MOV TL0,#00000000B ; TL0 = 00000000B 
       SETB TR0           ; Bat dau dem Timer0
	   
DELAY1M:
MOV R0,#250D        ; 1mS delay
LABEL2: DJNZ R0,LABEL2
        RET
		
HERE2: JNB TF0,HERE2      ; Lap den khi tran timer 0
       CLR TR0            ; dung Timer0
       CLR TF0            ; Xoa co tran timer 0
       DJNZ R0,BACK1      ; Lap lai 15 lan de delay 1s
       RET                ; Quay lai ham chinh

TEXT1: 

MOV A,80H
ACALL CMD
       MOV A,#" "     ; Ham nay in ra chu '  OBSTACLE  AT  '
       ACALL DISPLAY
       MOV A,#" "
       ACALL DISPLAY
       MOV A,#"O" 
       ACALL DISPLAY
       MOV A,#"B"
       ACALL DISPLAY
       MOV A,#"S"
       ACALL DISPLAY
       MOV A,#"T"
       ACALL DISPLAY
       MOV A,#"A"
       ACALL DISPLAY
       MOV A,#"C"
       ACALL DISPLAY
       MOV A,#"L"
       ACALL DISPLAY
       MOV A,#"E"
       ACALL DISPLAY
       MOV A,#" "
       ACALL DISPLAY
	   MOV A,#" "
       ACALL DISPLAY
       MOV A,#"A"
       ACALL DISPLAY
	   MOV A,#"T"
       ACALL DISPLAY
	   MOV A,#" "
       ACALL DISPLAY
	   MOV A,#" "
       ACALL DISPLAY
    RET                   ; Quay lai ham chinh

 TEXT2:  MOV A,#'c'       ; Ham nay in ra chu 'cm'
    ACALL DISPLAY
    MOV A,#'m'
    ACALL DISPLAY
    RET

                          ; ham split muc dich de tach gia tri ra thanh cac chu so 
                          ; Vd 321 -> R3 = 1, R2 = 2, R1 = 3 
SPLIT:MOV A,R7
      MOV B,#100D         ; gan B = 100
      DIV AB              ; chia A cho B, phan du duoc luu trong B
      MOV R1,A            ; Gan R1
	  MOV A,B
      MOV B,#10D          ; gan B = 10
      DIV AB              ; lap lai tuong tu
      MOV R2,A            ; ...
      MOV R3,B            ; ...
      RET                 ; Quay lai ham chinh

LEVEL:

      MOV A,R1            ; Gan gia tri A = gia tri cua R1 (So thu nhat)
      ACALL ASCII         ; Ep kieu sang char
      ACALL DISPLAY       ; goi ham hien thi ra
      MOV A,R2            ; Gan gia tri A = gia tri cua R2 (So so thu 2)
      ACALL ASCII         ; Ep kieu sang char
      ACALL DISPLAY       ; goi ham hien thi ra
      MOV A,R3            ; Gan gia tri A = gia tri cua R3 (So so thu 3)
      ACALL ASCII         ; Ep kieu sang char
      ACALL DISPLAY       ; goi ham hien thi ra
      RET                 ; Quay lai ham chinh

 DINT:MOV A,#30H          
    ACALL CMD             
    MOV A,#38H           
    ACALL CMD             
    MOV A,#0CH            
    ACALL CMD             
    MOV A,#01H            
    ACALL CMD             
    MOV A,#06H            
    ACALL CMD             
    RET                   ; Quay lai ham chinh
    
LINE2:
    MOV A,#11000000B       ; Nhay xuong dong 2 can giua
    ACALL CMD             
	MOV A,#" "
    ACALL DISPLAY
	MOV A,#" "
    ACALL DISPLAY
	MOV A,#" "
    ACALL DISPLAY
	MOV A,#" "
    ACALL DISPLAY
	MOV A,#" "
    ACALL DISPLAY
    RET                   ; Quay lai ham chinh

CMD: MOV P1,A             ; di chuyen du lieu den Port 1
    CLR RS                ; Xoa chan RS
    CLR RW                ; Xoa chan RW
    SETB E                ; set chan Enable
    CLR E                 ; Xoa chan Enable
    ACALL DELAY1M           ; goi ham delay
    RET                   ; Quay lai ham chinh

DISPLAY:MOV P1,A          ; di chuyen du lieu den Port 1
    SETB RS               ; set chan RS
    CLR RW                ; Xoa chan RW cua LCD
    SETB E                ; set chan Enable cua LCD
    CLR E                 ; xoa chan Enable cua LCD
    ACALL DELAY1M         ; goi ham delay
    RET                   ; Quay lai ham chinh

ASCII: MOVC A,@A+DPTR     ; Ghi de gia tri trong A thanh ki tu ascii
       RET                ; Quay lai ham chinh

LUT: DB  48D              ; ascii cua "0"
     DB  49D              ; ascii cua "1"
     DB  50D              ; ascii cua "2"
     DB  51D              ; ascii cua "3"
     DB  52D              ; ascii cua "4"
     DB  53D              ; ascii cua "5"
     DB  54D              ; ascii cua "6"
     DB  55D              ; ascii cua "7"
     DB  56D              ; ascii cua "8"
     DB  57D              ; ascii cua "9"

    END                   ; Ket thuc chuong trinh