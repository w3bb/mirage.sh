#!/bin/sh
unset domain
unset will_fetch
unset file_to_upload
unset url_to_shorten

check_if_key_is_set() {
  if [ -z "$MIRAGE_KEY" ]; then
    printf "ERROR: An upload key has not been supplied! Please set the MIRAGE_KEY environment variable!\n"
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
      will_fetch=1
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
      url_to_shorten=$OPTARG
      ;;
    u)
      file_to_upload=$OPTARG
      ;;
  esac
done

if [ ! -z ${file_to_upload+x} ] && [ ! -z ${url_to_shorten+x} ] || [ ! -z ${url_to_shorten+x} ] && [ ! -z ${will_fetch+x} ] || [ ! -z ${file_to_upload+x} ] && [ ! -z ${will_fetch+x} ] ; then
  printf "ERROR: Multiple operations have been selected, please only select one.\n"
  exit
elif [ ! -z ${file_to_upload+x} ]; then
  check_if_key_is_set
  if [ ! -f "$file_to_upload" ]; then
    printf "ERROR: The file specified doesn't exist!\n"
    exit
  fi
  printf "%s\n" "$(curl -s -F "file=@$file_to_upload" -F "key=$MIRAGE_KEY" -F "host=$domain" https://api.mirage.re/upload)"
  exit

elif [ ! -z ${url_to_shorten+x} ]; then
  check_if_key_is_set
  printf "%s\n" "$(curl -s -X POST -d "host=$domain" -d "key=$MIRAGE_KEY" -d "url=$url_to_shorten" https://api.mirage.re/shorten)"
  exit

elif [ ! -z ${will_fetch+x} ]; then
  printf "%s\n" "$(curl -s https://api.mirage.re/domains | grep -m1 -oP '\"domain\"\s*:\s*"\K[^\"]+')"
  exit
fi

print_usage
