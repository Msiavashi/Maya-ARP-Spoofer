# Maya-ARP-Spoofer
a yet very simple arp poisoner . i try to keep improving it though :)

#INSTALLING PAKCETFU
first you need to install packetfu gem
if you have rubygems installed just do this : 
	$: gem install packetfu

# USAGE

ruby Maya -vM {victim_mac} -vI {victim_internal_ip} -g {default_gateway}

#EXAMPLE

sudo ruby Maya.rb -vM 50:2E:5C:D0:AC:F3 -vI 192.168.0.106 -g 192.168.0.1

