#!/bin/bash

# Set variables:
SERVER=YourDefaultServerHere
PRINTER=unset
DRIVER=unset

#Help function
function usage()
{
   echo ""
   echo "Usage: add_printer [ -s | --server ] [ -p | --printer PRINTER ] [ -d | --driver ]"
   exit 2 # Exit script after printing help
}

#If a driver wasn't selected pull the know driver
function select_driver()
{
   echo "/Library/Printers/PPDs/Contents/Resources/Xerox\ AltaLink\ $1.gz"
}

PARSED_ARGUMENTS=$(getopt -n "$0" -o sp:d -a --long server,printer:,driver -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

echo "PARSED_ARGUMENTS is $PARSED_ARGUMENTS"
eval set -- "$PARSED_ARGUMENTS"

while :
do
  case "$1" in
    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;
    -s | --server)   SERVER="$2"                      ; shift 2 ;;
    -p | --printer)  PRINTER="$2"                     ; shift 2 ;;
    -d | --driver)   DRIVER=select_driver "$2"        ; shift 2 ;;
    # If invalid options were passed, then getopt should have reported an error,
    # which we checked as VALID_ARGUMENTS when getopt was called...
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done

echo "We made it"
echo "$SERVER"
echo "$PRINTER"
echo "$DRIVER"

exit 1

'
cupsctl --share-printers
sudo lpadmin -p $printerName -v lpd://$printServer/$printerName/ -m /Library/Printers/PPDs/Contents/Resources/Xerox\ AltaLink\ $printerDriver.gz -o printer-is-shared=true -D "$printerName" -L "$printername" -E
'