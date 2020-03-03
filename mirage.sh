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

error_conflicting() {
  printf "ERROR: Multiple operations selected. Please choose one operation to execute.\n"
  exit
}

if [ -z "$1" ]; then
  print_usage
fi

while getopts ":fd:s:u:" opt; do
  case $opt in
    f)
      if [ -n "$url_to_shorten" ] || [ -n "$file_to_upload" ]; then error_conflicting; else will_fetch=1; fi
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
      if [ -n "$file_to_upload" ] || [ -n "$will_fetch" ]; then error_conflicting; url_to_shorten=$OPTARG; fi
      ;;
    u)
      if [ -n "$will_fetch" ] || [ -n "$url_to_shorten" ]; then error_conflicting; else file_to_upload=$OPTARG; fi
      ;;
  esac
done

if [ -n "${file_to_upload+x}" ]; then
  check_if_key_is_set
  if [ ! -f "$file_to_upload" ]; then
    printf "ERROR: The file specified doesn't exist!\n"
    exit
  fi
  printf "%s\n" "$(curl -s -F "file=@$file_to_upload" -F "key=$MIRAGE_KEY" -F "host=$domain" https://api.mirage.re/upload)"
  exit

elif [ -n "${url_to_shorten+x}" ]; then
  check_if_key_is_set
  printf "%s\n" "$(curl -s -X POST -d "host=$domain" -d "key=$MIRAGE_KEY" -d "url=$url_to_shorten" https://api.mirage.re/shorten)"
  exit

elif [ -n "${will_fetch+x}" ]; then
  printf "%s\n" "$(curl -s https://api.mirage.re/domains | grep -m1 -oP '\"domain\"\s*:\s*"\K[^\"]+')"
  exit
fi

print_usage
