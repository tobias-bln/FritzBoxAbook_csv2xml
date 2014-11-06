#!/bin/sh

ABOOK=$1
TMP=/tmp/abook.tmp

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<phonebooks>\n<phonebook>" > abook.xml

cut -d ',' -f 3 -f 8 -f 9 -f 12 -s $ABOOK | grep -v -E '(,,,$|Anzeigename)' > $TMP
# Name,TelDienst,TelPrivat,TelMobil
while read -r line
do
	echo "<contact><category />" >> abook.xml
	COUNT=0
	echo "<person><realName>`echo $line | cut -d "," -f 1`</realName></person>" >> abook.xml
	# -- begin TelWork--
	TEL=`echo $line | cut -d "," -f 2`
	if [ "$TEL" != "" ] ; then
		#echo "<number type=\"work\" quickdial=\"\" vanity=\"\" prio=\"\" id=\"$COUNT\">$TEL</number>" >> abook.xml
		TEL1=`echo "<number type=\"work\" id=\"$COUNT\">$TEL</number>"`
		COUNT=$((COUNT+1))
	else
		TEL1=""
	fi
	# --
	# -- begin TelWork--
	TEL=`echo $line | cut -d "," -f 3`
	if [ "$TEL" != "" ] ; then
		#echo "<number type=\"home\" quickdial=\"\" vanity=\"\" prio=\"\" id=\"$COUNT\">$TEL</number>" >> abook.xml
		TEL2=`echo "<number type=\"home\" id=\"$COUNT\">$TEL</number>"`
		COUNT=$((COUNT+1))
	else
		TEL2=""
	fi
	# --
	# -- begin TelWork--
	TEL=`echo $line | cut -d "," -f 4`
	if [ "$TEL" != "" ] ; then
		#echo "<number type=\"mobile\" quickdial=\"\" vanity=\"\" prio=\"\" id=\"$COUNT\">$TEL</number>" >> abook.xml
		TEL3=`echo "<number type=\"mobile\" id=\"$COUNT\">$TEL</number>"`
		COUNT=$((COUNT+1))
	else
		TEL3=""
	fi
	# --
	echo "<telephony nid=\"$COUNT\">$TEL1\n$TEL2\n$TEL3\n</telephony><services /><setup />\n</contact>" >> abook.xml

done < $TMP

echo "</phonebook>\n</phonebooks>" >> abook.xml
rm -f $TMP
