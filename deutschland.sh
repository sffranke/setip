#!/bin/bash
# made by chat-gpt :)

# Erstelle neue ipset-Tabellen für deutsche und portugiesische IP-Adressen
ipset create de hash:net
ipset create pt hash:net
ipset create localnet hash:net
ipset create room131 hash:net

# Lade IP-Adressbereiche für Deutschland und Portugal von ipdeny.com herunter
wget -O - https://www.ipdeny.com/ipblocks/data/countries/de.zone | ipset restore
wget -O - https://www.ipdeny.com/ipblocks/data/countries/pt.zone | ipset restore

# Füge lokale IP-Adressbereiche (192.168.0.0/16) und Raum 131.*.*.* hinzu
ipset add localnet 192.168.0.0/16
ipset add room131 131.0.0.0/8

# Erstelle Firewall-Regel, die nur Verbindungen von den erstellten ipset-Tabellen erlaubt
iptables -A INPUT -m set --match-set de src -j ACCEPT
iptables -A INPUT -m set --match-set pt src -j ACCEPT
iptables -A INPUT -m set --match-set localnet src -j ACCEPT
iptables -A INPUT -m set --match-set room131 src -j ACCEPT
iptables -A INPUT -j DROP
