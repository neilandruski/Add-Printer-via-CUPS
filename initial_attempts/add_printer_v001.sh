#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -s printServer -p printerName -d printerDriver"
   echo -e "\t-a define which print server to use ex. print01.ua.lan"
   echo -e "\t-b define the printer name to be added"
   echo -e "\t-c define which printer driver is needed"
   exit 1 # Exit script after printing help
}

printServer=print01.ua.lan

while getopts "s:p:d:" opt
do
   case "$opt" in
      s ) printServer="$OPTARG" ;;
      p ) printerName="$OPTARG" ;;
      d ) printerDriver="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$printServer" ] || [ -z "$printerName" ] || [ -z "$printerDriver" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "$printServer"
echo "$printerName"
echo "$printerDriver"

cupsctl --share-printers
sudo lpadmin -p $printerName -v lpd://$printServer/$printerName/ -m /Library/Printers/PPDs/Contents/Resources/Xerox\ AltaLink\ $printerDriver.gz -o printer-is-shared=true -D "$printerName" -L "$printername" -E
