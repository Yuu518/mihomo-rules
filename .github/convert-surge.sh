#!/bin/bash

mkdir -p geoip
./mosdns v2dat unpack-ip -o ./geoip/ geoip.dat
list=($(ls ./geoip | sed 's/geoip_//g' | sed 's/\.txt//g'))
for ((i = 0; i < ${#list[@]}; i++)); do
	#	echo "${list[i]}"
	mv ./geoip/geoip_${list[i]}.txt ./geoip/${list[i]}.list
	sed -i -E 's/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2})/IP-CIDR,\1/g' ./geoip/${list[i]}.list
	sed -i '/^IP-CIDR,/! s/^/IP-CIDR6,/' ./geoip/${list[i]}.list    
done

mkdir -p geosite
./mosdns v2dat unpack-domain -o ./geosite/ geosite.dat
list=($(ls ./geosite | sed 's/geosite_//g' | sed 's/\.txt//g'))
for ((i = 0; i < ${#list[@]}; i++)); do
	#	echo "${list[i]}"
	mv ./geosite/geosite_${list[i]}.txt ./geosite/${list[i]}.list
	sed -i '/^#/d' geosite/${list[i]}.list
	sed -i '/^keyword:/d' geosite/${list[i]}.list
	sed -i '/^regexp:/d' geosite/${list[i]}.list
	sed -i '/^full:/!s/^/DOMAIN-SUFFIX,/' ./geosite/${list[i]}.list
	sed -i 's/^full:/DOMAIN,/g' ./geosite/${list[i]}.list
done
