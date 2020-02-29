inputfile=$(realpath $1)
domain="$(<domains  dmenu -i -l 20 -fn 'Inconsolata:pixelsize=24')"
output="$(mirage -d $domain $inputfile)"

case $output in https\:\/\/*)
  printf "%s" "$output" | xclip -sel clipboard
  exit
esac

printf "%s" "$output" 
