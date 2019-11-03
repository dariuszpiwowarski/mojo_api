A simple Mojolicious app

To install dependencies run "carton install"

To run the app "carton exec morbo script/mojo_api"

Create a user:

curl -i -X POST http://127.0.0.1:3000/register -d '{"email":"darek@darek.pl"}'

{"data":{"email":"darek@darek.pl","token":"N7vJOZRfF2PrFMhCpIt4"},"message":"Email added","status":"success"}

Get IP info:

Instant info:

curl -i http://127.0.0.1:3000/ip_lookup/instant -H "Authorization: Bearer N7vJOZRfF2PrFMhCpIt4" -H 'X-Real-IP: 213.180.141.140'

{"data":{"as":"AS12990 Ringier Axel Springer Polska Sp. z o.o.","city":"Warsaw","country":"Poland","countryCode":"PL","isp":"Ringier Axel Springer Polska Sp. z o.o.","lat":52.2297,"lon":21.0122,"org":"Grupa Onet.pl SA - Anycast Services","query":"213.180.141.140","region":"14","regionName":"Mazovia","status":"success","timezone":"Europe\/Warsaw","zip":""},"message":"","status":"success"}

Wait X(10) seconds and get info:

curl -i http://127.0.0.1:3000/ip_lookup/10 -H "Authorization: Bearer N7vJOZRfF2PrFMhCpIt4" -H 'X-Real-IP: 213.180.141.140'

X-Real-IP is usefull when you run it on your localhost and your ip is 127.0.0.1. :)

