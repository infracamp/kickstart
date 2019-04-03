# Workarounds

## The "Get my IP / hostname" - Problem

```
hostname -I         => Not supported by alpine
hostname -i / -I    => Not supported by MAC OS -> wrong (internal interface on Ubuntu)
host                => Not default alpine / default on MAC OS
```