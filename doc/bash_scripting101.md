# Bash scripting 101


## Packing whole config-files in an ENV-Argument:

To append whole files (including newlines) use `$(cat some/file.txt)`
inside the quoted env-name. (The whole env is paced in double-quotes `"`)

```
docker run --net host -e "CONF_JSON=$(cat path/to/file)" [container]
```

Use `awk '1' [input-file]` to generate a single line representation to
use in stack or .env files.


### Examples

```
#!/bin/bash

OPTIONS="-e CONF_FILE=" $(printf %q "`cat doc/smtp-config.json`")





## Read command

`IFS` is a variable used by `read`: 

```
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