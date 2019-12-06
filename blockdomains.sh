#! /bin/bash
domainList=$(<$1)
for domain in $(echo $domainList | tr -d '"' | tr "," "\n"); do
    hostOutput=$(host $domain)
    addresses=$(echo $hostOutput | grep -P '(\d*\.){3}\d*' -o)

    echo "Blocking domain $domain's addresses: $addresses"

    for address in $addresses; do
        iptables -A INPUT -s $address -j DROP
        iptables -A OUTPUT -s $address -j DROP
    done

    iptables-save >/etc/iptables/rules.v4
done
