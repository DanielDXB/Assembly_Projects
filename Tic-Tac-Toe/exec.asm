; Proiect PLA, X si O, @Daniel Bolontoc

mesaje segment       
    linie_noua db 13, 10, "$"
    
    tabela_joc db "_|_|_", 13, 10
               db "_|_|_", 13, 10
               db "_|_|_", 13, 10, "$"    
                  
    pointer db 9 DUP(?)  
    
    semnal_castigator db 0 
    numarul_jucatorului db "0$" 
    
    mesaj_sfarsit_de_joc db "FINAL DE JOC", 13, 10, "$"    
    jucator db "JUCATORUL $"   
    mesaj_castigator db " A CASTIGAT!$"   
    mesaj_pozitie db "Insereaza o pozitie de la tastatura 1-9: $"
ends
;----------------------------------------------------------------
start:
    ; set segment registers
    mov     ax, mesaje
    mov     ds, ax

    ; game start   
    call    pointeri_tabela    
            
mod_rulare:  
    call    video   
    
    call    afisare
    
    lea     dx, linie_noua
    call    afisare                      
    
    lea     dx, jucator
    call    afisare
    lea     dx, numarul_jucatorului
    call    afisare
    
    lea     dx, linie_noua
    call    afisare    
    
    lea     dx, tabela_joc
    call    afisare    
    
    lea     dx, linie_noua
    call    afisare    
    
    lea     dx, mesaj_pozitie    
    call    afisare            
                        
    ;citire pozitie pt inserare                   
    call    citire_de_la_tastatura
                       
    ;verificare pozitie de inserare                   
    sub     al, 49               
    mov     bh, 0
    mov     bl, al                                  
                                  
    call    actualizare_joc                                    
                                                          
    call    verificare  
                       
    ;verificare sfarsit de joc;                   
    cmp     semnal_castigator, 1  
    je      sfarsit_de_joc  
    
    call    schimbare_jucator 
            
    jmp     mod_rulare   


schimbare_jucator:   
    lea     si, numarul_jucatorului    
    xor     ds:[si], 1 
    
    ret
      
 
actualizare_joc:
    mov     bl, pointer[bx]
    mov     bh, 0
    
    lea     si, numarul_jucatorului
    
    cmp     ds:[si], "0"
    je      scrie_x     
                  
    cmp     ds:[si], "1"
    je      scrie_o              
                  
    scrie_x:
    mov     cl, "x"
    jmp     actualizare

    scrie_o:          
    mov     cl, "o"  
    jmp     actualizare    
          
    actualizare:         
    mov     ds:[bx], cl
      
    ret 
       
       
verificare:
    call    verificare_linie
    ret     
       
       
verificare_linie:     ;verificam pe linie
    mov     cx, 0
    
    functie_verificare_linie:     
    cmp     cx, 0
    je      linia_unu
    
    cmp     cx, 1
    je      linia_doi
    
    cmp     cx, 2
    je      linia_trei  
    
    call    verificare_coloana
    ret    
        
    linia_unu:     ;prima linie   
    mov     si, 0   
    jmp     verificare_linie_apelare   

    linia_doi:    ;a doua linie    
    mov     si, 3
    jmp     verificare_linie_apelare
    
    linia_trei:     ;a treia linie    
    mov     si, 6
    jmp     verificare_linie_apelare        

    verificare_linie_apelare:
    inc     cx
  
    mov     bh, 0
    mov     bl, pointer[si]
    mov     al, ds:[bx]
    cmp     al, "_"
    je      functie_verificare_linie
    
    inc     si
    mov     bl, pointer[si]    
    cmp     al, ds:[bx]
    jne     functie_verificare_linie 
      
    inc     si
    mov     bl, pointer[si]  
    cmp     al, ds:[bx]
    jne     functie_verificare_linie
                 
                         
    mov     semnal_castigator, 1
    ret         

              
verificare_coloana:
    mov     cx, 0
    
    functie_verificare_coloana:     
    cmp     cx, 0
    je      coloana_unu
    
    cmp     cx, 1
    je      coloana_doi
    
    cmp     cx, 2
    je      coloana_trei  
    
    call    verificare_diagonala
    ret    
        
    coloana_unu:    
    mov     si, 0   
    jmp     verificare_coloana_apelare   

    coloana_doi:    
    mov     si, 1
    jmp     verificare_coloana_apelare
    
    coloana_trei:    
    mov     si, 2
    jmp     verificare_coloana_apelare

    verificare_coloana_apelare:
    inc     cx
  
    mov     bh, 0
    mov     bl, pointer[si]
    mov     al, ds:[bx]
    cmp     al, "_"
    je      functie_verificare_coloana
    
    add     si, 3
    mov     bl, pointer[si]    
    cmp     al, ds:[bx]
    jne     functie_verificare_coloana 
      
    add     si, 3
    mov     bl, pointer[si]  
    cmp     al, ds:[bx]
    jne     functie_verificare_coloana
                 
                         
    mov     semnal_castigator, 1
    ret        


verificare_diagonala:
    mov     cx, 0
    
    functie_verificare_diagonala:     
    cmp     cx, 0
    je      diagonala_unu
    
    cmp     cx, 1
    je      diagonala_doi                         
    
    ret    
        
    diagonala_unu:    
    mov     si, 0                
    mov     dx, 4
    jmp     verificare_diagonala_apelare   

    diagonala_doi:    
    mov     si, 2
    mov     dx, 2
    jmp     verificare_diagonala_apelare       

    verificare_diagonala_apelare:
    inc     cx
  
    mov     bh, 0
    mov     bl, pointer[si]
    mov     al, ds:[bx]
    cmp     al, "_"
    je      functie_verificare_diagonala
    
    add     si, dx
    mov     bl, pointer[si]    
    cmp     al, ds:[bx]
    jne     functie_verificare_diagonala 
      
    add     si, dx
    mov     bl, pointer[si]  
    cmp     al, ds:[bx]
    jne     functie_verificare_diagonala
                 
                         
    mov     semnal_castigator, 1
    ret  
           

sfarsit_de_joc:        
    call    video   
    
    call    afisare

    lea     dx, mesaj_sfarsit_de_joc
    call    afisare  
    
    lea     dx, jucator
    call    afisare
    
    lea     dx, numarul_jucatorului
    call    afisare
    
    lea     dx, mesaj_castigator
    call    afisare 

    jmp     final    
  
     
pointeri_tabela:
    lea     si, tabela_joc
    lea     bx, pointer          
              
    mov     cx, 9   
    
    bucla:
    cmp     cx, 6
    je      adauga_1                
    
    cmp     cx, 3
    je      adauga_1
    
    jmp     adauga_2 
    
    adauga_1:
    add     si, 1
    jmp     adauga_2     
      
    adauga_2:                                
    mov     ds:[bx], si 
    add     si, 2
                        
    inc     bx               
    loop    bucla 
 
    ret  
         
       
afisare:      ;scrie DX  
    mov     ah, 9
    int     21h   
    
    ret 
    

video:      ;mod afisare, 10h - scurtatura BIOS
    mov     ah, 0fh
    int     10h   
    
    mov     ah, 0
    int     10h
    
    ret
       
    
citire_de_la_tastatura:  ;citire de la tastatura si scriere in AH, 21h functie DOS, citeste de la tastatura.
    mov     ah, 1       
    int     21h  
    
    ret      
      
      
final:
    jmp     final         
      

end start
