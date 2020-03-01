#!/bin/sh
unset domain

check_if_key_is_set() {
  if [ -z "$MIRAGE_KEY" ]; then
    printf "ERROR: An upload key has not been supplied! Please set the MIRAGE_KEY environment variable!\n"
    exit
 fi
}
check_if_file_exists() {
  if [ ! -f "$1" ]; then
    printf "ERROR: The file specified doesn't exist!\n"
    exit
  fi
}
print_usage() {
  printf "Usage: %s <options>\n-d: domain to use\n-f: fetch the latest domains and print result\n-s: url to shorten \n-u: file to upload\n" "$0"
  exit
}

if [ -z $1 ]; then
  print_usage
fi

while getopts ":fd:s:u:" opt; do
  case $opt in
    f)
      curl -s https://api.mirage.re/domains | grep -m1 -oP '\"domain\"\s*:\s*"\K[^\"]+'
      exit
      ;;
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
    
    s)
      check_if_key_is_set
      printf "%s\n" "$(curl -s -X POST -d "host=$domain" -d "key=$MIRAGE_KEY" -d "url=$OPTARG" https://api.mirage.re/shorten)"
      exit
      ;;
    u)
      check_if_key_is_set
      check_if_file_exists "$OPTARG"
      printf "%s\n" "$(curl -s -F "file=@$OPTARG" -F "key=$MIRAGE_KEY" -F "host=$domain" https://api.mirage.re/upload)"
      exit
      ;;
  esac
done
print_usage
