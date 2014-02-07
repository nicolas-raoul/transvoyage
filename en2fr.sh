#!/bin/bash
# Translate an article from English Wikivoyage to French Wikivoyage
#
# Usage:
# - Use Ubuntu or another Linux. Might work on Mac too.
# - Download latest CSV from https://sourceforge.net/projects/wikivoyage/files/Listings-as-CSV/
# - Put the CSV in the same directory as this script
# - If you want to generate Toronto, execute in a terminal: ./en2fr.sh Toronto
# - The last output line tells you the output file. Open that file and paste to Wikivoyage.
#
# TODO
# Sub-section budget,splurge,etc
# Upload result to Wikivoyage
# Link in Wikidata
# Improve IsPartOf: name in local language, go up if does not exist


TITLE=$1
CSV="enwikivoyage-20140205-listings.csv"
OUT=`mktemp`
DESTINATION_LANGUAGE="fr"

# Download live English wikicode for non-POI data
WIKICODE=`mktemp`
wget --quiet -O $WIKICODE "https://en.wikivoyage.org/w/index.php?title=$TITLE&action=raw"

# Find the wider area this destination is part of.
ISPARTOF=`grep -i -m 1 "IsPartOf" $WIKICODE | sed -e "s/.*sPartOf|//" | sed -e "s/}.*//"`
echo $ISPARTOF
# http://www.wikidata.org/w/api.php?action=wbgetentities&sites=enwikivoyage&titles=Prague&props=
# ISPARTOF_WIKIDATA=`wget --quiet -O - "http://www.wikidata.org/w/api.php?action=wbgetentities&sites=enwikivoyage&titles=$ISPARTOF&format=xml&props=" | tr "\n" " " | sed -e "s/.*id=\"//" | sed -e "s/\".*//"`
#LOCALIZED_ISPARTOF=`wget --quiet -O - "http://www.wikidata.org/w/api.php?action=wbgetentities&sites=enwikivoyage&titles=$ISPARTOF&languages=$DESTINATION_LANGUAGE&props=labels&format=xml" | tr "\n" " " | sed -e "s/.*title=\"//" | sed -e "s/\".*//"`     does not work on Toronto
#echo $LOCALIZED_ISPARTOF

# Find images contained in each section
SECTION=""
IMAGES=`mktemp`
cat $WIKICODE | grep "^==\|^\[\[File:" | while read LINE; do
  if [[ "$LINE" =~ ^==Understand ]]
  then
    SECTION="understand"
  elif [[ "$LINE" =~ ^==Get\ in ]]
  then
    SECTION="getin"
  elif [[ "$LINE" =~ ^==Get\ around ]]
  then
    SECTION="getaround"
  elif [[ "$LINE" =~ ^==See ]]
  then
    SECTION="see"
  elif [[ "$LINE" =~ ^==Do ]]
  then
    SECTION="do"
  elif [[ "$LINE" =~ ^==Buy ]]
  then
    SECTION="buy"
  elif [[ "$LINE" =~ ^==Eat ]]
  then
    SECTION="eat"
  elif [[ "$LINE" =~ ^==Drink ]]
  then
    SECTION="drink"
  elif [[ "$LINE" =~ ^==Sleep ]]
  then
    SECTION="sleep"
  elif [[ "$LINE" =~ File ]]
  then
    IMAGE=`echo $LINE | sed -e "s/thumbnail|.*\]\]/thumb\]\]/"| sed -e "s/thumb|.*\]\]/thumb\]\]/"`
    echo $IMAGE >> $IMAGES$SECTION
  fi
done 

echo "{{Bannière page}}
{{Info Ville
| nom=$TITLE
| nom local=
| région=
| image=
| légende image=
| rivière=
| superficie=
| population=
| population agglomération=
| année population= 
| altitude=
| latitude=
| longitude=
| zoom=
| code postal=
| indicatif=
| adresse OT=
| horaire OT=
| téléphone OT=
| numéro gratuit OT=
| email OT=
| facebook OT=
| twitter OT=
| URL OT=
| URL officiel=
| URL touristique=
}}

'''$TITLE''' est une ville dans [[$ISPARTOF]].

== Comprendre ==" > $OUT
cat "${IMAGES}understand" >> $OUT 2>/dev/null

echo "== Aller ==" >> $OUT
cat "${IMAGES}getin" >> $OUT 2>/dev/null

echo "== Circuler ==" >> $OUT
cat "${IMAGES}getaround" >> $OUT 2>/dev/null

# Parse POIs
POIS=`mktemp`
POIS_SEE=`mktemp`
POIS_DO=`mktemp`
POIS_BUY=`mktemp`
POIS_EAT=`mktemp`
POIS_DRINK=`mktemp`
POIS_SLEEP=`mktemp`
grep "^\"$TITLE\"" $CSV | sed -e "s/^\"$TITLE\";//" > $POIS
grep "^\"see\"" $POIS | sed -e "s/^\"see\";//" > $POIS_SEE
grep "^\"do\"" $POIS | sed -e "s/^\"do\";//" > $POIS_DO
grep "^\"buy\"" $POIS | sed -e "s/^\"buy\";//" > $POIS_BUY
grep "^\"eat\"" $POIS | sed -e "s/^\"eat\";//" > $POIS_EAT
grep "^\"drink\"" $POIS | sed -e "s/^\"drink\";//" > $POIS_DRINK
grep "^\"sleep\"" $POIS | sed -e "s/^\"sleep\";//" > $POIS_SLEEP

echo "
== Voir ==" >> $OUT
cat "${IMAGES}see" >> $OUT 2>/dev/null
while read POI; do
  POI=`echo $POI | sed -e 's/";"/切/g'`
  IFS='切' read -ra DETAILS <<< "$POI"
  NAME=`echo ${DETAILS[0]} | sed -e "s/\"//"`
  ALT=${DETAILS[1]}
  ADDRESS=${DETAILS[2]}
  DIRECTIONS=${DETAILS[3]}
  PHONE=${DETAILS[4]}
  TOLLFREE=${DETAILS[5]}
  EMAIL=${DETAILS[6]}
  FAX=${DETAILS[7]}
  URL=${DETAILS[8]}
  HOURS=${DETAILS[9]}
  CHECKIN=${DETAILS[10]}
  CHECKOUT=${DETAILS[11]}
  IMAGE=${DETAILS[12]}
  PRICE=${DETAILS[13]}
  LAT=${DETAILS[14]}
  LON=${DETAILS[15]}
  CONTENT=${DETAILS[16]}
  echo "* {{Voir
| nom=$NAME | alt=$ALT | url=$URL | wikipédia= | facebook= | twitter= | email=$EMAIL
| adresse=$ADDRESS | latitude=$LAT | longitude=$LON | direction=
| image=$IMAGE
| téléphone=$PHONE | téléphone portable= | numéro gratuit=$TOLLFREE | fax=$FAX | horaire= | prix=
| description=
}}" >> $OUT
done < $POIS_SEE

echo "
== Faire ==" >> $OUT
cat "${IMAGES}do" >> $OUT 2>/dev/null
while read POI; do
  POI=`echo $POI | sed -e 's/";"/切/g'`
  IFS='切' read -ra DETAILS <<< "$POI"
  NAME=`echo ${DETAILS[0]} | sed -e "s/\"//"`
  ALT=${DETAILS[1]}
  ADDRESS=${DETAILS[2]}
  DIRECTIONS=${DETAILS[3]}
  PHONE=${DETAILS[4]}
  TOLLFREE=${DETAILS[5]}
  EMAIL=${DETAILS[6]}
  FAX=${DETAILS[7]}
  URL=${DETAILS[8]}
  HOURS=${DETAILS[9]}
  CHECKIN=${DETAILS[10]}
  CHECKOUT=${DETAILS[11]}
  IMAGE=${DETAILS[12]}
  PRICE=${DETAILS[13]}
  LAT=${DETAILS[14]}
  LON=${DETAILS[15]}
  CONTENT=${DETAILS[16]}
  echo "* {{Faire
| nom=$NAME | alt=$ALT | url=$URL | wikipédia= | facebook= | twitter= | email=$EMAIL
| adresse=$ADDRESS | latitude=$LAT | longitude=$LON | direction=
| image=$IMAGE
| téléphone=$PHONE | téléphone portable= | numéro gratuit=$TOLLFREE | fax=$FAX | horaire= | prix=
| description=
}}" >> $OUT
done < $POIS_DO

echo "
== Acheter ==" >> $OUT
cat "${IMAGES}buy" >> $OUT 2>/dev/null
while read POI; do
  POI=`echo $POI | sed -e 's/";"/切/g'`
  IFS='切' read -ra DETAILS <<< "$POI"
  NAME=`echo ${DETAILS[0]} | sed -e "s/\"//"`
  ALT=${DETAILS[1]}
  ADDRESS=${DETAILS[2]}
  DIRECTIONS=${DETAILS[3]}
  PHONE=${DETAILS[4]}
  TOLLFREE=${DETAILS[5]}
  EMAIL=${DETAILS[6]}
  FAX=${DETAILS[7]}
  URL=${DETAILS[8]}
  HOURS=${DETAILS[9]}
  CHECKIN=${DETAILS[10]}
  CHECKOUT=${DETAILS[11]}
  IMAGE=${DETAILS[12]}
  PRICE=${DETAILS[13]}
  LAT=${DETAILS[14]}
  LON=${DETAILS[15]}
  CONTENT=${DETAILS[16]}
  echo "* {{Acheter
| nom=$NAME | alt=$ALT | url=$URL | wikipédia= | facebook= | twitter= | email=$EMAIL
| adresse=$ADDRESS | latitude=$LAT | longitude=$LON | direction=
| image=$IMAGE
| téléphone=$PHONE | téléphone portable= | numéro gratuit=$TOLLFREE | fax=$FAX | horaire= | prix=
| description=
}}" >> $OUT
done < $POIS_BUY

echo "
== Manger ==" >> $OUT
cat "${IMAGES}eat" >> $OUT 2>/dev/null
while read POI; do
  POI=`echo $POI | sed -e 's/";"/切/g'`
  IFS='切' read -ra DETAILS <<< "$POI"
  NAME=`echo ${DETAILS[0]} | sed -e "s/\"//"`
  ALT=${DETAILS[1]}
  ADDRESS=${DETAILS[2]}
  DIRECTIONS=${DETAILS[3]}
  PHONE=${DETAILS[4]}
  TOLLFREE=${DETAILS[5]}
  EMAIL=${DETAILS[6]}
  FAX=${DETAILS[7]}
  URL=${DETAILS[8]}
  HOURS=${DETAILS[9]}
  CHECKIN=${DETAILS[10]}
  CHECKOUT=${DETAILS[11]}
  IMAGE=${DETAILS[12]}
  PRICE=${DETAILS[13]}
  LAT=${DETAILS[14]}
  LON=${DETAILS[15]}
  CONTENT=${DETAILS[16]}
  echo "* {{Manger
| nom=$NAME | alt=$ALT | url=$URL | wikipédia= | facebook= | twitter= | email=$EMAIL
| adresse=$ADDRESS | latitude=$LAT | longitude=$LON | direction=
| image=$IMAGE
| téléphone=$PHONE | téléphone portable= | numéro gratuit=$TOLLFREE | fax=$FAX | horaire= | prix=
| description=
}}" >> $OUT
done < $POIS_EAT

echo "
== Boire un verre / Sortir ==" >> $OUT
cat "${IMAGES}drink" >> $OUT 2>/dev/null
while read POI; do
  POI=`echo $POI | sed -e 's/";"/切/g'`
  IFS='切' read -ra DETAILS <<< "$POI"
  NAME=`echo ${DETAILS[0]} | sed -e "s/\"//"`
  ALT=${DETAILS[1]}
  ADDRESS=${DETAILS[2]}
  DIRECTIONS=${DETAILS[3]}
  PHONE=${DETAILS[4]}
  TOLLFREE=${DETAILS[5]}
  EMAIL=${DETAILS[6]}
  FAX=${DETAILS[7]}
  URL=${DETAILS[8]}
  HOURS=${DETAILS[9]}
  CHECKIN=${DETAILS[10]}
  CHECKOUT=${DETAILS[11]}
  IMAGE=${DETAILS[12]}
  PRICE=${DETAILS[13]}
  LAT=${DETAILS[14]}
  LON=${DETAILS[15]}
  CONTENT=${DETAILS[16]}
  echo "* {{Boire
| nom=$NAME | alt=$ALT | url=$URL | wikipédia= | facebook= | twitter= | email=$EMAIL
| adresse=$ADDRESS | latitude=$LAT | longitude=$LON | direction=
| image=$IMAGE
| téléphone=$PHONE | téléphone portable= | numéro gratuit=$TOLLFREE | fax=$FAX | horaire= | prix=
| description=
}}" >> $OUT
done < $POIS_DRINK

echo "
== Se loger ==" >> $OUT
cat "${IMAGES}sleep" >> $OUT 2>/dev/null
while read POI; do
  POI=`echo $POI | sed -e 's/";"/切/g'`
  IFS='切' read -ra DETAILS <<< "$POI"
  NAME=`echo ${DETAILS[0]} | sed -e "s/\"//"`
  ALT=${DETAILS[1]}
  ADDRESS=${DETAILS[2]}
  DIRECTIONS=${DETAILS[3]}
  PHONE=${DETAILS[4]}
  TOLLFREE=${DETAILS[5]}
  EMAIL=${DETAILS[6]}
  FAX=${DETAILS[7]}
  URL=${DETAILS[8]}
  HOURS=${DETAILS[9]}
  CHECKIN=${DETAILS[10]}
  CHECKOUT=${DETAILS[11]}
  IMAGE=${DETAILS[12]}
  PRICE=${DETAILS[13]}
  LAT=${DETAILS[14]}
  LON=${DETAILS[15]}
  CONTENT=${DETAILS[16]}
  echo "* {{Se loger
| nom=$NAME | alt=$ALT | url=$URL | wikipédia= | facebook= | twitter= | email=$EMAIL
| adresse=$ADDRESS | latitude=$LAT | longitude=$LON | direction=
| image=$IMAGE
| téléphone=$PHONE | téléphone portable= | numéro gratuit=$TOLLFREE | fax=$FAX | horaire= | prix=
| description=
}}" >> $OUT
done < $POIS_SLEEP

echo "
== Communiquer ==

== Aux environs ==

{{Avancement|statut=esquisse|type=ville}}
{{Dans|$ISPARTOF}}
" >> $OUT

# Template saying the article is a translation from English Wikivoyage.
OLDID=`wget --quiet -O - "http://en.wikipedia.org/w/api.php?action=query&prop=info&format=xml&titles=Main%20Page" | tr "\n" " " | sed -e "s/.*lastrevid=\"//" | sed -e "s/\".*//"`
echo "{{Traduction/Référence|projet=Wikivoyage|en|$TITLE|$OLDID}}" >> $OUT

echo "[[en:$TITLE]] <!-- Please add this page to Wikidata then remove this line, thank you! https://www.wikidata.org/wiki/Special:ItemByTitle?wb-itembytitle-sitename=enwikivoyage -->" >> $OUT

echo "New article written to: $OUT"

# Add a link "Hydrogen" from the English page to "Wasserstoff" at the German page:
# https://www.wikidata.org/w/api.php?action=wblinktitles&fromsite=enwiki&fromtitle=Hydrogen&tosite=dewiki&totitle=Wasserstoff
