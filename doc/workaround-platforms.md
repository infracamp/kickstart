# Workarounds

## The "Get my IP / hostname" - Problem

```
hostname -I         => Not supported by alpine (ci-builds etc)
hostname -i / -I    => Not supported by MAC OS; wrong internal interface on Ubuntu)
host                => Not default alpine / default on MAC OS
    Not working to resolve local system name on Mac OS
```

MacOS Workaround:
```
ping -c 1 $(hostname) | grep icmp_seq | awk 'match($0,/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/){print substr($0, RSTART, RLENGTH)}'
```


### Using ip route list

Output on ubuntu/arch
```
default via 192.168.3.1 dev enp4s0 proto dhcp metric 100 
169.254.0.0/16 dev enp4s0 scope link metric 1000 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1
```

MacOS don't know `ip` command.