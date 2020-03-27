#!/bin/sh
unset domain
unset will_fetch
unset file_to_upload
unset url_to_shorten
unset argument_tick
unset fetch_raw 

error_conflicting() {
  printf "ERROR: Multiple operations selected. Please choose one operation to execute.\n"
  exit 1
}

argument_tick() {
  if [ -n "$argument_tick" ]; then error_conflicting; else argument_tick="set"; fi
}

check_if_key_is_set() {
  [ -z "$MIRAGE_KEY" ] && printf "ERROR: An upload key has not been supplied! Please set the MIRAGE_KEY environment variable!\n" && exit 1
}

print_usage() {
  printf "Usage: %s <options>\n-d: domain to use\n-f: fetch the latest domains and print result\n-r: use only the raw response of -f (use this if you want to parse the json on your own)\n-s: url to shorten \n-u: file to upload\n" "$0"
  exit 1
}

[ -z "$1" ] && print_usage

while getopts ":fd:s:u:r" opt; do
  case $opt in
    f)
      argument_tick; will_fetch=1
      ;;
    d)
      domain=$OPTARG
      ;;
    \?)
      printf "ERROR: Invalid option: -$%s\n" "$OPTARG"
      exit
      ;;
    :)
      printf "ERROR: Option -%s requires an argument.\n" "$OPTARG"
      exit
      ;;
    s)
      argument_tick; url_to_shorten=$OPTARG
      ;;
    u)
      argument_tick; file_to_upload=$OPTARG
      ;;
    r)
      fetch_raw="set"
  esac
done
if [ -n "$file_to_upload" ]; then
  check_if_key_is_set
  [ ! -f "$file_to_upload" ] && printf "ERROR: The file specified doesn't exist!\n" && exit 1
  [ -z "$domain" ] && printf "ERROR: A domain has not been selected. Please select a domain" && exit 1
  printf "%s\n" "$(curl -F "file=@$file_to_upload" -F "key=$MIRAGE_KEY" -F "host=$domain" https://api.mirage.re/upload)"
  exit

elif [ -n "$url_to_shorten" ]; then
  check_if_key_is_set
  printf "%s\n" "$(curl -s -X POST -d "host=$domain" -d "key=$MIRAGE_KEY" -d "url=$url_to_shorten" https://api.mirage.re/shorten)"
  exit

elif [ -n "$will_fetch" ]; then
  curl_output="$(curl -s https://api.mirage.re/domains)" 
  [ -z "$fetch_raw" ] && printf "%s" "$curl_output" | grep -m1 -oP '\"domain\"\s*:\s*"\K[^\"]+' || printf "%s\n" "$curl_output"
  exit
fi

print_usage
exit 1
