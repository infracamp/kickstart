# Problems while developing windows container

## Port ranges will kill computer

Originally kickstart should open ports 4000-4999 to the host and port 80. But this killed windows.

## Varnished links to Home-Directory

Go to Docker -> Settings ->  Shared Drives

Mark "c" as shared and klick "Reset credentials..."

