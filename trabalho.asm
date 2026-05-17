.data
msg1: .asciiz"\nQual o primeiro ano?"
msg2: .asciiz"\nQual o segundo ano?"
msg3: .asciiz"\nDiferença de anos maior que 1000, digite novamente"
msg4: .asciiz"\nNúmero negativo, digite novamente"
msg5: .asciiz"\nO ano 0 não existe, tente novamente"
msg6: .asciiz"\nDiferença negativa, tente novamente"
msg7: .asciiz"\nA quantidade de anos bissextos entre os dois anos é: "

.text
main:
li $s0, 1000
li $s1, 0
li $s2, 4
li $s3, 0
li $s4, 1
li $s5, 10000
li $s7, 100
li $t7, 400
ano1:
#pegar o primeiro ano
li $v0, 4
la $a0, msg1
syscall
li $v0, 5
syscall
add $t0, $v0, 0
bgt $t4, $zero, troca_maior

ano2:
#pegar o segundo ano
li $v0, 4
la $a0, msg2
syscall
li $v0, 5
syscall
add $t1, $v0, 0

troca_maior:
#coloca o primeiro no $t4 e o segundo no $t5, assim ele tenta fazer a conta se for menor-maior
mul $t4, $t4, $zero
mul $t5, $t5, $zero
add $t4, $t0, 0
add $t5, $t1, 0
beq $t4, $zero, erro
beq $t5, $zero, erro1
blt $t4, $zero, erro2
blt $t5, $zero, erro3

verificacao: 
#verificação do loop $t3, caso tenha sido maior, reseta seu valor
mul $t3, $t3, $zero
sub $t3, $t5, $t4
# caso maior que 1000(s0) ou menor que 0, ele dá mensagem de erro e caso não seja, ele vai pra segunda verificação
bgt $t3, $s0, erro4
blt $t3, $zero, verificacao_negativo
ble $t3, $s0, verificacao_bissexto

erro: 
# se o primeiro ano ter um valor=0, pede ele de novo
li $v0, 4
la $a0, msg5
syscall
j ano1

erro1:
# se o segundo ano ter um valor=0, pede ele de novo
li $v0, 4
la $a0, msg5
syscall
j ano2

erro2:
# se o primeiro ano for negativo, ele pede de novo
li $v0, 4
la $a0, msg4
syscall
j ano1

erro3:
# se o segundo ano for negativo, ele pede de novo
li $v0, 4
la $a0, msg4
syscall
j ano2

erro4:
# se a diferença for +1000, ele pede o segundo número de novo
li $v0, 4
la $a0, msg3
syscall
j ano2

erro5:
# se a diferença continuar negativa nos 2 casos, ele volta
li $v0, 4
la $a0, msg6
syscall
mul $t4, $t4, $zero
mul $t5, $t5, $zero
j ano1


verificacao_negativo:
# se a diferença der -0, ele inverte os valores para ver se a ordem está do maior-menor, caso seja, passa, caso não, volta
add $t6, $t4, 0
add $t4, $t5, 0
add $t5, $t6, 0
sub $t6, $t5, $t4
ble $t6, $zero, erro5
ble $t6, $s0, verificacao_bissexto
bgt $t6, $s0, erro4

verificacao_bissexto:
#verifica se o número que começa, é bissexto, se for, ele conta 1 no adicao_bissexto, caso não, ele roda
div $t4, $s2
mfhi $s6
beq $s6, $zero, verifica_100
bgt $s6, $zero, roda

adicao_bissexto:
#primeiro verifica se o número já é maior que o segundo ano, se for, para, senão, continua
bgt $t4, $t5, corretor
add $t4, $t4, $s4
add $s1, $s1, $s4
ble $t4, $t5, loop

roda:
# se o ano não for bissexto, ele roda o contador
bgt $t4, $t5, corretor
add $t4, $t4, $s4

loop:
# vai dividindo o menor ano por 4, caso ele seja bissexto, vai pro "adicao_bissexto", caso contrário, vai pro "roda"
div $t4, $s2
mfhi $s6
beq $s6, $zero, verifica_100
j roda

verifica_100:
# nos verifica e adiciona é pra casos de anos como 1300, que são divisíveis por 4 mas não por 400 (ou seja, não são bissextos), acumulando e vai pro corrige
div $t4, $s7
mfhi $t8
beq $t8, $zero, verifica_400
beq $s6, $zero, adicao_bissexto

verifica_400:
add $k0, $k0, $s4
div $t4, $t7
mfhi $t9
beq $t9, $zero, adiciona_400
bne $t9, $zero, adicao_bissexto

adiciona_400:
add $s3, $s3, $s4
j adicao_bissexto

corretor:
# aqui ele subtrai os anos como 1300, e adiciona os anos 1000, 1400, 1800 etc. Por serem de fato bissextos
sub $s1, $s1, $k0
add $s1, $s1, $s3

final:
# printa o final
li $v0, 4
la $a0, msg7
syscall
li $v0, 1
add $a0, $s1, 0
syscall
