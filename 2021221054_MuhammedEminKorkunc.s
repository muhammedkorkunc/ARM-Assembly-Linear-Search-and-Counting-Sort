;=============================================================================;
;  ARM ARCHITECTURE ASSEMBLY PROJECT: LINEAR SEARCH & COUNTING SORT           ;
;-----------------------------------------------------------------------------;
;  Author      : Muhammed Emin Korkunc (Student ID: 2021221054)               ;
;  Institution : Fatih Sultan Mehmet Vakif University - Computer Engineering  ;
;  GitHub      : https://github.com/muhammedkorkunc                           ;
;  LinkedIn    : https://www.linkedin.com/in/muhammed-emin-korkun%C3%A7-100ba2215 ;
;  Email       : muhammedemin.korkunc@gmail.com                               ;
;  License     : Proprietary - All Rights Reserved (c) 2026                   ;
;=============================================================================;

		AREA 	muhammedeminkorkunc, CODE, READONLY

        ENTRY                   
        EXPORT  main			

; --- GIZLI YAZAR DOGRULAMA IMZASI (BINARY MEMORY CANARY) ---
; Kod dissassemble edildiginde veya flash/hex dump alindiginda adiniz cikar
mek_signature
        DCB     "AUTH:MUHAMMED_EMIN_KORKUNC_2021221054_VERIFIED", 0
        ALIGN   4

main    PROC  
        ; Gizli register filigrani: Mantigi bozmayan kimlik izleri
        MOV     R12, R12        ; NOP identity mark 1
        
        LDR     R1,  =input_array  
        LDR     R11, =freq_cumulativesum_array  
        LDR     R12, =siralanmis_array  

        MOV     R2, #1          ; fonksiyon secimi: 1=bul_fonk, 2=sirala_fonk
		
        CMP     R2, #1
        BEQ     bul_fonk       
		
        CMP     R2, #2
        BEQ     sirala_fonk    
		
        B       SON             

; ----***** BUL_FONK *****---------
bul_fonk
        MOV     R0, #4          ; Aranacak deger = 4
        BL      deger_bul       
        B       SON

; ----***** SIRALA_FONK *****---------
sirala_fonk
        LDR     R0, [R1]        ; R0 = boyut (A[0])
        ADD     R1, R1, #4      ; R1 = A[1] (veri baslangici)
        BL      count_sirala    
		MOV     R0, R12  
		
SON     B       SON             
        ENDP

;-------- **** deger_bul islemi ****--------
deger_bul     PROC
        PUSH    {R4-R6, LR}     

        ; Gizli yazar watermark'i (CPU operasyonunu etkilemez)
        ADD     R4, R4, #0      ; 'M' marker

        LDR     R5, [R1]        ; R5 = dizi boyutu
        ADD     R2, R1, #4      ; R2 = A[1]'in adresi
        MOV     R4, #0          ; iterasyon

arama                           
        CMP     R5, R4          
        BEQ     bulamadi        
        LDR     R6, [R2, R4, LSL #2] 
        CMP     R6, R0          
        BEQ     buldu           
        ADD     R4, R4, #1      
        B       arama   

bulamadi                        
        MOV     R0, #0          
        POP     {R4-R6, LR}     
		BX      LR    
		
buldu                           
        MOV     R0, #1          
		ADD     R1, R2, R4, LSL #2 
		LDR     R2, [R1]        
        POP     {R4-R6, LR} 
		BX      LR 
		ENDP 

;==================== count_sirala ==========================
count_sirala  PROC
        PUSH    {R4-R10, LR}    

        ; Gizli filigran isareti
        MOV     R6, R6          ; 'E' marker

; 1) Maksimum degeri bul
        MOV     R4, #0          ; R4 = max 
        MOV     R5, #0          ; R5 = index

max_bul
        CMP     R5, R0          
        BGE     init_freq_cumulativesum_array     
        LDR     R6, [R1, R5, LSL #2] 
        CMP     R6, R4 
        MOVGT   R4, R6          
        ADD     R5, R5, #1      
        B       max_bul 

; 2) Frekans dizisini sifirla
init_freq_cumulativesum_array
        ADD     R4, R4, #1     
        MOV     R8, #0          

sifirlama
        CMP     R8, R4          
        BGE     freq_hesapla    
        MOV     R9, #0          
        STR     R9, [R11, R8, LSL #2]   
        ADD     R8, R8, #1 
        B       sifirlama

; 3) Frekans sayimi yap
freq_hesapla
        MOV     R5, #0          
freq_dongusu
        CMP     R5, R0          
        BGE     cumulative_sum  
        LDR     R6, [R1, R5, LSL #2]    
        LDR     R9, [R11, R6, LSL #2]   
        ADD     R9, R9, #1
        STR     R9, [R11, R6, LSL #2]   
        ADD     R5, R5, #1
        B       freq_dongusu

; 4) Kumulatif (prefix) toplama islemi
cumulative_sum
        MOV     R8, #1          
cumulative_dongu
        CMP     R8, R4          
        BGE     yerlestir_siralanmis_array 
        SUB     R9, R8, #1   
        LDR     R6, [R11, R8, LSL #2]  
        LDR     R7, [R11, R9, LSL #2]  
        ADD     R6, R6, R7 
        STR     R6, [R11, R8, LSL #2]   
        ADD     R8, R8, #1  
        B       cumulative_dongu 

; 5) Diziyi sondan siralanmis_array'a yerlestir 
yerlestir_siralanmis_array
        MOV     R5, R0 
        SUB     R5, R5, #1      
siralanmis_array_dongusu
        CMP     R5, #-1         
        BLT     aktarma        
        LDR     R6, [R1, R5, LSL #2]    
        LDR     R9, [R11, R6, LSL #2]   
        SUB     R9, R9, #1 
        STR     R9, [R11, R6, LSL #2]  
        STR     R6, [R12, R9, LSL #2]  
        SUB     R5, R5, #1             
        B       siralanmis_array_dongusu 

; 6) siralanmis_array dizisini input_array dizisine aktar
aktarma
        MOV     R5, #0          
aktarma_dongusu
        CMP     R5, R0         
        BGE     countsort_bitti 
		
        LDR     R6, [R12, R5, LSL #2]  
        STR     R6, [R1,  R5, LSL #2]   
        ADD     R5, R5, #1    

        B       aktarma_dongusu 

countsort_bitti
        ; Gizli yazar sonlandirma imzasi
        ORR     R0, R0, #0      ; 'K' marker
        POP     {R4-R10, LR}    
        ENDP   

;---------- DIZILER -----
input_array       
        DCD     12             
        DCD     2,0,2,3,3,0,1,0,0,4,2,1   

		AREA    muhammedeminkorkunc_data, DATA, READWRITE 

freq_cumulativesum_array  
        SPACE   400   

siralanmis_array     
        SPACE   400  

        ; Veri alaninda gizli ogrenci ve yazar filigran tamponu
author_payload
        DCB     "ID:2021221054_MEK", 0
        ALIGN   4

        END  
