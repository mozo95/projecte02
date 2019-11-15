# Display the username, password, and the host where the user was
created.

#!/bin/bash
# If the user doesn't supply at least one argument, then give them help.
usage() {
# The first parameter is the user name.
# The rest of the parameters are for the account comments.
  echo "Uso: ${0} [-u USERNAME] [-c]" >&2
  echo 'Script para creacion de usuario.' >&2
  echo '  -u USER    Nombre del usuario.' >&2
  echo '  -c         Comentario.' >&2
  exit 1
}

# Generate a password.
password() {
  PASSWORD=$(date | sha265sum)
}

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -eq 0 ]]
then
  while getopts ":u:c:" OPTION
  do
    case ${OPTION} in
      u)
        u=${OPTARG}
        ;;
      c)
        c=${OPTARG}
        ;;
      *)
        usage
        ;;
    esac
  done
  # Create the user.
  # Force password change on first login.
  useradd -c "${c}" -m ${u} -e
  # Check to see if the useradd command succeeded.
  if [[ "${?}" -ne 0 ]]
  then
    echo 'La creación de usuario ha sufrido un error'
    exit 1
  fi
  # Change the password.
  echo $u":"$PASSWORD | chpasswd
  # Check to see if the passwd command succeeded.
  if [[ "${?}" -ne 0 ]]
  then
    echo 'La asignacion de contraseña ha sufrido un error'
    exit 1
  fi
  # Display the username, password, and the host where the user was created.
  echo $u
  echo $PASSWORD
  echo $HOSTNAME
else
  echo 'No tienes privilegios para ejecutar este script.'
  exit 1
fi

