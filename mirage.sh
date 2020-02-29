#!/bin/sh

unset domain
unset last
for last; do true; done

while getopts ":fd:" opt; do
  case $opt in
    d)
      domain=$OPTARG
      ;;
    \?)
      echo "ERROR: Invalid option: -$OPTARG" >&2
      exit
      ;;
    :)
      echo "ERROR: Option -$OPTARG requires an argument." >&2
      exit
      ;;
    f)
      curl -s https://api.mirage.re/domains | grep -m1 -oP '\"domain\"\s*:\s*"\K[^\"]+'
      exit
      ;;
  esac
done

if [ -z $1 ]; then
  printf "Usage: %s <options> [url]\n-d: set domain to upload to\n-f: request domains and print response\n" "$0"
  exit
fi

for last; do true; done

if [ -z "$MIRAGE_KEY" ]; then
  printf "ERROR: An upload key has not been supplied! Please set the MIRAGE_KEY environment variable!\n"
  exit

elif [ "$last" = "-f" ] || [ "$last" = "" ] || [ "$domain" = "$last" ]; then
  printf "ERROR: Please specify a file!\n"
  exit

elif [ ! -f "$last" ]; then
  printf "ERROR: That file doesnt exist!\n"
  exit

elif [ "$domain" = "" ] || [ "$domain" = "$last" ]; then
  printf "ERROR: Please specify a domain!\n"
  exit

fi

printf "%s\n" "$(curl -s -F "file=@$last" -F "key=$MIRAGE_KEY" -F "host=$domain" https://api.mirage.re/upload)"

