# zabbix-ssl-check
It will accept paramethers where -s is the SNI, -d is the hostname and -p is the port:

* This will just check for the first SSL cert served through 443
```
./ssl_expiry.sh -d opsweb01.example.com
```

* This will check for the first certificate served on on 4443
```
./ssl_expiry.sh -d opsweb01.example.com -p 4443
```

* This will check for the certificate for the service oc.example.com served on port 8443
```
./ssl_expiry.sh -s oc.example.com -d opsweb01.example.com -p 8443
```
