# mirage.sh
<h4>A simple command line interface for mirage.photos written in POSIX compliant 
shell.</h4>

![](https://mirage.re/c1ED8A6FFffdb49C.webm)

### Features
- Makes it easier to create scripts that upload to mirage.photos
- Interact with mirage.photos through your favourite programs with scripts
- Only depends on curl and POSIX utilities

### Non-features
- Built-in support for external programs like dmenu
- Built-in support for copying to the X clipboard
- Verbose output

### Setup
The script requires you set your mirage.photos upload key as an environment
variable. This variable being $MIRAGE_KEY. It's up to you to secure your key.

You can run the script (it's portable) or stick the script somewhere in $PATH. 
I personally stick it in ~/.local/bin.

### Usage
Some people are new to Unix and don't understand why there isn't built-in
support for things like copy+paste. This is intentional. This is intended to be
used like a Unix program. This means you can use outputs of this script with
other programs. For example, if you want to copy the link to your clipboard
you can use xclip like so:

```./mirage.sh -d mirage.re -u skeleton.gif | xclip -selection clipboard```

This will put the output of the command into your clipboard.

There are example scripts in the example folder (I use some of the scripts in
there) that might have functionality you want pre-written. We have examples for
a domain selection menu with dmenu, and an example script that downloads the 
lastest domains and saves it to a file named 'domains'

If you'd like to see some examples, such as a dmenu implementation and a simple
script to fetch domains and save them to a file, check out the [snippets for this 
repository](https://gitgud.io/webb/mirage.sh/snippets).

### Planned Features
- Ability to fetch existing uploads
- No domain set will remove the domain from the print
- Perhaps a rewrite in C?
