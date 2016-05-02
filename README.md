# Maya-ARP-Spoofer
a yet very simple arp poisoner written in Ruby. i try to keep improving it though, so keep checking :)

just remember that there is no strong protection over inputs yet (its initial release), so try to do as the example to avoid any unexpected error

#INSTALLING PAKCETFU
first you need to install packetfu gem

if you have rubygems installed just do this : 
	$: gem install packetfu
	
second as the script uses nmap to scan the subnet so you need it to be install if you want to use the scanner:
	$: apt install nmap
	
now you're good to go ...

# USAGE
to scan the whole subnet:

	ruby Maya -s -g {your default gateway}
	
to start poisoning the ARP cashe of the victim:

	ruby Maya -i {your interface} -vI {victim_internal_ip} -g {default_gateway}
	
to start sniffing all the arp packets goes over the network:

	ruby Maya -i {your interface} -l
	
#EXAMPLE

sudo ruby Maya.rb -i 'wlo1' -vI 192.168.0.106 -g 192.168.0.1

sudo ruby Maya -s -g '192.168.0.1'

sudo ruby -i 'wlo1' -l

