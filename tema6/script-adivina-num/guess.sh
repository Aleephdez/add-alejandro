#! /bin/bash

random_number=$((RANDOM%10+1))
 
number_guess=0

while [ $number_guess -ne $random_number ]
do

    echo -e "[+] Introduzca un número del 1 al 10: \c"
    read number_guess
    
    if [ $number_guess -ne $random_number ]; then
        attempts=$((attempts+1))
    fi

    if [ $number_guess -lt $random_number ]; then
        echo "[-] El número introducido es menor"
    elif [ $number_guess -gt $random_number ]; then
        echo "[-] El número introducido es mayor"
    fi

done
 
echo "[*] ¡Has acertado! El número es $random_number. Has fallado $attempts veces"