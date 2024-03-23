#!/bin/bash
#
#update these variables accordingly

udmproaddress=192.168.1.1
country=DE
organisation='My Private Network'
certificatename='HomePod'
password='password'

scp -r root@${udmproaddress}:/data/udapi-config/raddb/certs .

cd certs
openssl req -subj "/C=${country}/O=${organisation}/CN=${certificatename}" -out myclient.csr -new -newkey rsa:4096 -nodes -keyout myclient.key
openssl x509 -req -days 365 -in myclient.csr -CA server.pem -CAkey server-key.pem -CAcreateserial -out myclient.crt -sha256
openssl pkcs12 -passout "pass:${password}" -export -in myclient.crt -inkey myclient.key -out ../"${certificatename} Certificate.pfx" -legacy # -legacy Required to enter password in Apple Configurator
cp server.pem ../"Radius Server Certificate.crt"
