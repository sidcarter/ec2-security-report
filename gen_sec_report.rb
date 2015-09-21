#!/usr/bin/env ruby

require 'rubygems'
require 'json'

def hash_json(j)
	
	hasharr = Array.new

	j["SecurityGroups"].each do |s|
		s["IpPermissions"].each do |p|
			p["IpRanges"].each do |i|
				h = {:groupname => s["GroupName"],:proto => p["IpProtocol"],:port => p["ToPort"], :ip => i["CidrIp"]}
				hasharr.push(h)
			end
		end
	end

	hasharr
end

begin

	# initialize constants
	FNAME="testsecgroups.txt"
	CRONLOG="sieve/sec_cronlog"
	PUB_IP="0.0.0.0/0"
	
	raise "Illegal argument(s)" if not (ARGV.length==0 or (ARGV.length==1 and ARGV[0]=="cron"))

	# open files and abort if you find any errors
	jsonfile = File.read(FNAME)
	logfile = File.open(CRONLOG,"w")

	rescue Exception => e
		abort("#{e}")

	# if all went ok, process json file and print to cron or std out based on first argument
	else
		data = Array.new
		json=JSON.parse(jsonfile)
		data=hash_json(json)

		if ARGV.length==0
			puts "Security groups that are accessible from the internet:"
			data.select { |r| r[:ip] == PUB_IP }.each { |r| printf "%-40s > %-5s %s\n",r[:groupname],r[:proto],r[:port] }
			puts "\nIP addresses with special ACLs"
			data.select { |r| r[:ip] != PUB_IP }.each { |r| puts r[:ip] }
		elsif ARGV[0]=="cron"
			puts "Writing to #{CRONLOG}"
			data.each { |r| logfile.puts "#{r[:groupname]}| #{r[:ip]}| #{r[:proto]}| #{r[:port]}" }
			logfile.close
		else
			abort("Illegal argument(s)")
		end
end
