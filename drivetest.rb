#!/usr/bin/ruby


# Get a list of all attached disks from diskutil
def disklist

	disks = `ls -al /dev/disk* | egrep '.*disk[0-9]+$'`

	disk_array = disks.split("\n")

	@identifiers = []

	disk_array.each do |line|
		@identifiers << line.match(/\/dev\/.*$/)[0]
	end

	# puts @identifiers.class
end


# get relevant info about each disk to show to the user.
def disk_details

	@disk_info_list = []

	@identifiers.each do |i|
		unless i == "/dev/disk0" or i == "/dev/disk1"
			dump = `diskutil info #{i}`

			size = dump.match(/Total Size.*/)[0].gsub("               "," ").gsub(/GB .*/,"GB")

			info = i + "\n" + size + "\n"

			@disk_info_list << info

		end

	end

end


# Ask the user which disk they want info for.
def pick_disk

	# set up the data with these methods.
	disklist
	disk_details

	puts "Which disk would you like SMART info for?\n\n"

	(1..@disk_info_list.count).each do |num|

			puts "#{num}:\n#{@disk_info_list[num-1]}\n"

	end

	print "Enter an item number: "

	@selected_disk = gets.chomp.strip.to_i

	system 'clear'

	puts "you're getting info for:   #{@identifiers[@selected_disk+1]}"

	get_smart(@identifiers[@selected_disk+1])
	
end


# Pull the SMART data for the disk in question, format and output the relevant data.
def get_smart(disk)

	# system 'clear'
		begin
			smart_dump = `smartctl -a -T permissive #{disk}`
		rescue => e
			puts "Failed to retrieve drive info. Reason:\n"
			puts e
			puts "Press enter to continue..."
			gets
			system 'clear'
			pick_disk
		end

	family = smart_dump.match(/Model Family.*$/)[0]
	model = smart_dump.match(/Device Model.*$/)[0]
	serial = smart_dump.match(/Serial Number.*$/)[0]
	capacity = smart_dump.match(/User Capacity.*$/)[0]
	assessment = smart_dump.match(/.*overall-health.*$/)[0]
	
	if smart_dump.match(/.*Reallocated_Sector_Ct.*$/)
		reallocated = smart_dump.match(/.*Reallocated_Sector_Ct.*$/)[0]
	end

	if smart_dump.match(/.*Media_Wearout_Indicator.*$/)
		wearout = smart_dump.match(/.*Media_Wearout_Indicator.*$/)[0]
	end

	puts family
	puts model
	puts serial
	puts capacity
	puts 
	puts "-----------------------------------------------------"
	puts 
	puts assessment
	puts 
	puts "-----------------------------------------------------"
	puts
	puts reallocated
	puts wearout if wearout
	puts

	print "would you like to test another disk? Y/N: "

	response = gets.chomp.strip.downcase

	case response
	when "y"
		puts "Insert a new drive. When it's powered on, press enter."
		gets
		system 'clear'
		pick_disk
	when "n"
		exit!
	else
		puts "I don't know what that is, exiting."
		exit!
	end

end










system 'clear'

pick_disk






# @disk_info_list.each do |disk|
# 	puts disk
# end

# puts @list.class

# puts "#{@list}"

