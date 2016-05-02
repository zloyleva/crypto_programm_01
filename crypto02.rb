class Crypto

	@abc_up = ("A".."Z").to_a
	@abc_low = ("a".."z").to_a
	@crypto_string = ""
	@result_array = []

	def self.code_simbol(change_step, one_char)
		if one_char == " " || one_char == "." || one_char == "," || one_char == "-" || one_char == "?" || one_char == "!" || one_char == "`" || one_char == "\""
			@crypto_string = one_char
		else	
			if @abc_low.index(one_char)
				coding_simbol(one_char, change_step, @abc_low)
			else
				coding_simbol(one_char, change_step, @abc_up)
			end
		end
	end

	def self.coding_simbol(item, change_step, array_simbol)
		index = array_simbol.index(item)
		index += change_step
		index -= array_simbol.size if index > array_simbol.size - 1
		@crypto_string = array_simbol[index]
	end

	def self.count_char(string_Crypto)
	@result_array = []
		@abc_low.each do |item|
			count = 0
			string_Crypto.chars.collect {|one_char| count += 1 if one_char == item}#funct count
			@result_array << [item, count]
		end	
		return @result_array
	end

end

require 'sinatra'

get '/' do
	erb :index
end

post '/' do
	@string_Crypto = ""
	@out_array = []
	@div_out = ""

	input_string = params[:crypto_string]
	change_step = params[:offset].strip.to_i
	@string_Crypto = input_string.chars.collect{|one_char| Crypto.code_simbol(change_step, one_char)}.join
	@out_array = Crypto.count_char(@string_Crypto.downcase)

	@out_array.each do |item_for_div|
		@div_out += "<div class=\"color\" style=\"height: #{item_for_div[1]}px \"><div class=\"item\">#{item_for_div[0]}:#{item_for_div[1]}</div></div>\n"
	end

	output_file = File.open("text.txt", "a")
	output_file.write "Input text: #{input_string}\nOffset: #{change_step}\nEncoding string: #{@string_Crypto}"
	output_file.close

	erb :index

end