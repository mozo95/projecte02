#display the username, password, and the host where the user was
#created.

#!/bin/bash
# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -eq 1 ]]
then
        echo 'No tienes privilegios para ejecutar este script.'
    exit 1
fi

# If the user doesn't supply at least one argument, then give them help.
# The first parameter is the user name.
# The rest of the parameters are for the account comments.
if [[ "$#" -lt 1 ]]
then
	echo "Este script requiere parametros por favor introducelos:"
	echo "EJEMPLO: ${0} [USUARIO] [COMENTARIO]"
	exit 1
fi
# Generate a password.
password() {
	PASSWORD=$(date | sha256sum)
}
# Create the user.
useradd -c "${2}" -m "${1}" >/dev/null
# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
   	echo 'La creación de usuario ha sufrido un error'
    exit 1
fi
password
# Change the password.
# Force password change on first login.
echo -e $PASSWORD"\n"$PASSWORD | passwd $1 -e
# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
  	echo 'La asignacion de contraseña ha sufrido un error'
    exit 1
fi
# Display the username, password, and the host where the user was created.
echo -e "\n El usuario $1, tiene la contraseña $PASSWORD y el host $(hostname)." 
