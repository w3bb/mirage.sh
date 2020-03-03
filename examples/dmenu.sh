#!/bin/sh
if [ -z "$1" ]; then
  printf "Please specify a file!\n"
  exit
fi

inputfile=$(realpath $1)
domain="$(cat domains | dmenu -i -l 20 -fn 'Inconsolata:pixelsize=24')"
output="$(mirage -d $domain -u $inputfile)"

case $output in https\:\/\/*)
  printf "%s" "$output" | xclip -sel clipboard
  exit
esac

printf "%s" "$output" 
