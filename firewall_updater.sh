#!/bin/bash

# IPSET
IPSET=ipset

# LIST
LIST=allowed

# If you want to add a new Exception, you need to add another element
# to the array as follow: (Uncomment the Third Element)

# Exceptions
EXCEPTION[0]='co'
EXCEPTION[1]='ca'
#EXCEPTION[2]='us'

# Let's create the list
$IPSET -exist flush $LIST
$IPSET -N $LIST hash:net -exist

# We delete the old downloaded zones
rm -f /tmp/*.zone

# We download the new zones
for ZONE in "${EXCEPTION[@]}";
do
		echo "Downloading Zone $ZONE..."
    wget -P /tmp/ http://www.ipdeny.com/ipblocks/data/countries/$ZONE.zone
done

# We add the countries into the list
find /tmp/ -type f -name "*.zone" | awk {'print "for ZONE in $(cat " $1 "); do ipset -A $LIST $ZONE; done"'} | bash
