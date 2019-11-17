#!/bin/bash
password() {
  PASSWORD=$(date | sha265sum)
}

# Make sure the script is being executed with superuser privileges.
if [ $(id -u) -eq 0 ]; then 
    # Get the username (login).
	read -p "Introduce el usuario : " nombre
    # Get the real name (contents for the description field).
    read -p "Introduce el comentario : " com
    # Check if the user exists
	egrep "^$nombre" /etc/passwd >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo -e "\n El usuario $nombre existe!"
		exit 1
	else
        # Create the user
		useradd -m $nombre -c $com 
        # Check to see if the useradd command succeeded
        [ $? -eq 0 ] && echo "Se ha añadido el usuario al sistema." || echo "No se ha añadido el usuario al sistema."
        #Set the password. 
        password 
        echo -e "$PASSWORD" | passwd $nombre
        # Check to see if the passwd command succeeded.
        [ $? -eq 0 ] && echo -e "\n La contraseña se ha establecido" || echo -e "\n La contraseña no se ha podido establecer." 
        #Force password change on first login.
        passwd -e $nombre  
        #Display the username, password, and the host where the user was created.
        echo -e "\n El usuario $nombre, tiene la contraseña $PASSWORD y el host $(hostname)." 
	fi
else
	echo 'No tienes privilegios para ejecutar este script.'
	exit 2
fi