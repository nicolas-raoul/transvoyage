# Translate an article from English Wikivoyage to French Wikivoyage
# Needs CSV file generated by wikivoyage2osm
#
# TODO
# download live English wikicode for non-POI data
# find images, copy them to appropriate sections with no legend
# banner

TITLE="Aarhus"
CSV="../wikivoyage2osm/enwikivoyage-20140101-pages-articles.xml.csv"

# Download live English wikicode for non-POI data
WIKICODE=`mktemp`
#wget -O - "https://en.wikivoyage.org/w/index.php?title=Aarhus&action=edit" | sed -n '/wpAutoSummary/,$p' |sed -n '/<\/textarea>/q;p' > $WIKICODE
WIKICODE=html3

# Find first image of the page, to use in infobox
FIRST_IMAGE=`grep -m 1 "\[\[File:" $WIKICODE | sed -e "s/.*\[\[File://" | sed -e "s/\]\]//" | sed -e "s/|.*//"`
ISPARTOF=`grep -i -m 1 "IsPartOf" $WIKICODE | sed -e "s/.*IsPartOf|//" | sed -e "s/}.*//"`

# Find images contained in each section
# TODO

echo "{{Bannière page}}
{{Info Ville
| nom=
| nom local=
| région=
| image=$FIRST_IMAGE
| légende image=
| rivière=
| superficie=
| population=
| population agglomération=
| année population= 
| altitude=
| latitude=
| longitude=
| zoom=14
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

== Comprendre ==

== Aller ==

== Circuler ==
"

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

echo ""
echo "== Voir =="
while read POI; do
  IFS=';' read -ra DETAILS <<< "$POI"
  NAME=${DETAILS[0]}
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
| adresse=$ADDRESS | latitude=$LAT | longitude=$LONG | direction=$DIRECTIONS
| image=$IMAGE
| téléphone=$PHONE | téléphone portable= | numéro gratuit=$TOLLFREE | fax=$FAX | horaire= | prix=
| description=
}}"
done < $POIS_SEE

echo ""
echo "== Faire =="
while read POI; do
  IFS=';' read -ra DETAILS <<< "$POI"
  NAME=${DETAILS[0]}
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
| adresse=$ADDRESS | latitude=$LAT | longitude=$LONG | direction=$DIRECTIONS
| image=$IMAGE
| téléphone=$PHONE | téléphone portable= | numéro gratuit=$TOLLFREE | fax=$FAX | horaire= | prix=
| description=
}}"
done < $POIS_DO

echo ""
echo "== Acheter =="
while read POI; do
  IFS=';' read -ra DETAILS <<< "$POI"
  NAME=${DETAILS[0]}
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
| adresse=$ADDRESS | latitude=$LAT | longitude=$LONG | direction=$DIRECTIONS
| image=$IMAGE
| téléphone=$PHONE | téléphone portable= | numéro gratuit=$TOLLFREE | fax=$FAX | horaire= | prix=
| description=
}}"
done < $POIS_BUY

echo ""
echo "== Manger =="
while read POI; do
  IFS=';' read -ra DETAILS <<< "$POI"
  NAME=${DETAILS[0]}
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
| adresse=$ADDRESS | latitude=$LAT | longitude=$LONG | direction=$DIRECTIONS
| image=$IMAGE
| téléphone=$PHONE | téléphone portable= | numéro gratuit=$TOLLFREE | fax=$FAX | horaire= | prix=
| description=
}}"
done < $POIS_EAT

echo ""
== Boire un verre / Sortir ==
while read POI; do
  IFS=';' read -ra DETAILS <<< "$POI"
  NAME=${DETAILS[0]}
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
| adresse=$ADDRESS | latitude=$LAT | longitude=$LONG | direction=$DIRECTIONS
| image=$IMAGE
| téléphone=$PHONE | téléphone portable= | numéro gratuit=$TOLLFREE | fax=$FAX | horaire= | prix=
| description=
}}"
done < $POIS_DRINK

echo ""
echo "== Se loger =="
while read POI; do
  IFS=';' read -ra DETAILS <<< "$POI"
  NAME=${DETAILS[0]}
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
| adresse=$ADDRESS | latitude=$LAT | longitude=$LONG | direction=$DIRECTIONS
| image=$IMAGE
| téléphone=$PHONE | téléphone portable= | numéro gratuit=$TOLLFREE | fax=$FAX | horaire= | prix=
| description=
}}"
done < $POIS_SLEEP

echo "
== Communiquer ==

== Aux environs ==

{{Dans|$ISPARTOF}}
"
