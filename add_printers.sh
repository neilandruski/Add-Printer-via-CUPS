#!/bin/bash

# Set variables:
SERVER=YourDefaultPrintServerHere
PRINTER=
DRIVER=

#TODO: Set up dict of printer:drivers

#Testing print function call.
#Options passed in are printed first then the needed options to confirm correct input.
info()
{
  echo "$*"
  echo "$SERVER"
  echo "$PRINTER"
  echo "$DRIVER"
}

#Checks if there are no argument is passed to an option
needs_arg() { if [[ -z "$OPTARG" ]]; then usage; fi; }

#Help function
usage()
{
  echo $*
  echo ""
  echo -e "Usage: $0 [ -s,--server=<STRING> ] [ -p,--printer=<STRING> ] [ -d,--driver=<STRING> ]"
  echo -e "\t-s,--server  assign server to use. optional"
  echo -e "\t-p,--printer assign printer to be used. MANDITORY"
  echo -e "\t-d,--driver  assign what model driver to use. optional."
  echo ""
  exit 2 # Exit script after printing help
}

#TODO: Choose driver by Printer name
#If a driver wasn't selected, pull the know driver from the dictionary
select_driver()
{
   DRIVER="/Library/Printers/PPDs/Contents/Resources/Xerox\ AltaLink\ $1.gz"
}

#Checks printer drivers exist, exit otherwise.
listdrivers=$(lpinfo -m | grep AltaLink) #list available drivers and grep for our models
if [[ -z "$listdrivers" ]]; then
  usage "Pease install the drivers for the AltaLink series printers"
fi

while getopts s:p:d:-: OPT; do
  # support long options: https://stackoverflow.com/a/28466267/519360
  if [[ "$OPT" = "-" ]]; then # long option: reformulate OPT and OPTARG
    OPT="${OPTARG%%=*}"       # extract long option name
    OPTARG="${OPTARG#$OPT}"   # extract long option argument (may be empty)
    OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
  fi
  case "$OPT" in
    s | server )   needs_arg; SERVER="$OPTARG" ;;
    p | printer )  needs_arg; PRINTER="$OPTARG";;
    d | driver )   needs_arg; DRIVER="$OPTARG" ;;
    ??* )          usage "Unsupported option"  ;;  # bad long option
    ? )            usage "Unsupported option"  ;;  # bad short option (error reported via getopts)
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

#Testing printout
info "Initial input from User"

# If no printer is given then we can't assign driver. Exit Script.
if [[ -z "$PRINTER" ]]; then usage; fi;

#No Driver set then use printer to set it
if [[ -z "$DRIVER" ]]; then select_driver "$PRINTER"; fi;

#Testing prinitout
info "Updated driver... Going to add printer"
exit 2

#Set CUPS to allow shared printers. Then add the printer.
'
cupsctl --share-printers
sudo lpadmin -p $printerName -v lpd://$printServer/$printerName/ -m /Library/Printers/PPDs/Contents/Resources/Xerox\ AltaLink\ $printerDriver.gz -E -o printer-is-shared=true -D "$printerName" -L "$printername" 
'