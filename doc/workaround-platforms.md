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