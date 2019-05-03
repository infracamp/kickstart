# Bash scripting 101

Styleguides:

- https://google.github.io/styleguide/shell.xml

## Packing whole config-files in an ENV-Argument:

To append whole files (including newlines) use `$(cat some/file.txt)`
inside the quoted env-name. (The whole env is paced in double-quotes `"`)

```
docker run --net host -e "CONF_JSON=$(cat path/to/file)" [container]
```

Use `awk '1' [input-file]` to generate a single line representation to
use in stack or .env files.



## If

```
if [[ "$someVar" == "xyz" ]]
then

fi;

```


## Read command

`IFS` is a variable used by `read`: 

```bash
#!/bin/bash
# setupapachevhost.sh - Apache webhosting automation demo script
file=/tmp/domains.txt

# set the Internal Field Separator to |
IFS='|'
while read -r domain ip webroot ftpusername
do
        printf "*** Adding %s to httpd.conf...\n" $domain
        printf "Setting virtual host using %s ip...\n" $ip
        printf "DocumentRoot is set to %s\n" $webroot
        printf "Adding ftp access for %s using %s ftp account...\n\n" $domain $ftpusername
	
done < "$file"
```

Further readings: (https://bash.cyberciti.biz/guide/$IFS)


## Error Handling


```
# Use traps in functions and subcalls
set -o errtrace

trap 'on_error $LINENO' ERR;
PROGNAME=$(basename $0)
PROGPATH="$( cd "$(dirname "$0")" ; pwd -P )"   # The absolute path to kickstart.sh

function on_error () {
    echo "Error: ${PROGNAME} on line $1" 1>&2
    exit 1
}
```