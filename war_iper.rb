#!/usr/bin/env ruby

require 'net/ping'

def port_open?(ip, port)
  begin
    Timeout::timeout(1) do
      begin
        s = TCPSocket.new(ip, port)
        s.close
        return true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        return false
      end
    end
  rescue Timeout::Error
  end

  return false
end


subnet = "192.168.1."
(1..254).each do |i|
  target = subnet + i.to_s
  if port_open?(target, 22)
    puts "#{target} --> alive WITH SSH"
  elsif Net::Ping::External.new(target).ping?
    puts "#{target} --> alive: #{target}, scanning"
    puts %x{nmap #{target} --host-timeout 5}
  else
    puts "...#{target} (dead)"
  end
end
