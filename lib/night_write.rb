#!/usr/bin/env ruby

require 'pry'
class FileReader
  def read
    filename = ARGV[0]
    (File.read(filename))
  end
end

module Dictionary
  ALPHABET_TO_BRAILLE = {
    "a" => ["0.", "..", ".."],
    "b" => ["0.", "0.", ".."],
    "c" => ["00", "..", ".."],
    "d" => ["00", ".0", ".."],
    "e" => ["0.", ".0", ".."],
    "f" => ["00", "0.", ".."],
    "g" => ["00", "00", ".."],
    "h" => ["0.", "00", ".."],
    "i" => [".0", "0.", ".."],
    "j" => [".0", "00", ".."],
    "k" => ["0.", "..", "0."],
    "l" => ["0.", "0.", "0."],
    "m" => ["00", "..", "0."],
    "n" => ["00", ".0", "0."],
    "o" => ["0.", ".0", "0."],
    "p" => ["00", "0.", "0."],
    "q" => ["00", "00", "0."],
    "r" => ["0.", "00", "0."],
    "s" => [".0", "0.", "0."],
    "t" => [".0", "00", "0."],
    "u" => ["0.", "..", "00"],
    "v" => ["0.", "0.", "00"],
    "w" => [".0", "00", ".0"],
    "x" => ["00", "..", "00"],
    "y" => ["00", ".0", "00"],
    "z" => ["0.", ".0", "00"],
    " " => ["..", "..", ".."],
    "!" => ["..", "00", "0."],
    "'" => ["..", "..", "0."],
    "," => ["..", "0.", ".."],
    "-" => ["..", "..", "00"],
    "." => ["..", "00", ".0"],
    "?" => ["..", "0.", "00"],
    "`" => ["..", "..", ".0"], #shift for capitals
    "#" => [".0", ".0", "00"]
  }

  BRAILLE_TO_ALPHABET = ALPHABET_TO_BRAILLE.invert

  NUMBER_TO_BRAILLE = {
    "#" => [".0", ".0", "00"],
    "0" => [".0", "00", ".."],
    "1" => ["0.", "..", ".."],
    "2" => ["0.", "0.", ".."],
    "3" => ["00", "..", ".."],
    "4" => ["00", ".0", ".."],
    "5" => ["0.", ".0", ".."],
    "6" => ["00", "0.", ".."],
    "7" => ["00", "00", ".."],
    "8" => ["0.", "00", ".."],
    "9" => [".0", "0.", ".."],
    " " => ["..", "..", ".."]
  }

  BRAILLE_TO_NUMBER = NUMBER_TO_BRAILLE.invert

  LETTERS_TO_NUMBERS = {
    "j" => "0",
    "a" => "1",
    "b" => "2",
    "c" => "3",
    "d" => "4",
    "e" => "5",
    "f" => "6",
    "g" => "7",
    "h" => "8",
    "i" => "9",
    "`" => "`"
  }
end

module FileWriter
  def write
    filename_output = ARGV[1]
    File.open(filename_output, "w")
  end
end

class NightWriter
  include Dictionary
  include FileWriter
  attr_accessor :reader, :string, :top, :middle, :bottom


  def initialize
    @reader = FileReader.new
    @top = ""
    @middle = ""
    @bottom = ""
  end


# create method to determine which table to execute on




  #
  # def chunk(string, number_of_characters)
  #   string.delete "\n"
  #   string.chars.each_slice(number_of_characters).map(&:join)
  # end

  def add_shift_for_capital_character(string)
    shifted_text = string.gsub(/[A-Z]/) {|letter| "`" + letter.downcase}
    shifted_text
  end

  def add_number_trigger(string)
    new_string = string.split(" ")
    string_with_number = []
    new_string.each do |element|
      if element[0] >= "0" && element[0] <= "9"
        string_with_number << "#" + element
      else
        string_with_number << element
      end
    end
    string_with_number.join(' ')
  end

  def convert_digit_to_braille(string)
    string.each_char do |char|
      @top << "#{NUMBER_TO_BRAILLE[char][0]}"
      @middle << "#{NUMBER_TO_BRAILLE[char][1]}"
      @bottom << "#{NUMBER_TO_BRAILLE[char][2]}"

    end
  end


  def convert_non_digit_to_braille(string)
    string.each_char do |char|
      @top << "#{ALPHABET_TO_BRAILLE[char][0]}"
      @middle << "#{ALPHABET_TO_BRAILLE[char][1]}"
      @bottom << "#{ALPHABET_TO_BRAILLE[char][2]}"
    end
  end

  def create_single_string
    new_string = ""
      loop do
      break if @top == ""
      #binding.pry
      new_string += top[0..79] + "\n" +
                    middle[0..79] + "\n" +
                    bottom[0..79] + "\n"
      break if @top[80..-1] == nil
      @top = top[80..-1]
      @middle = middle[80..-1]
      @bottom = bottom[80..-1]
    end
    return new_string
  end

  def determine_digit_or_non_to_covert(string)
    string.delete "\n"
    array_string = string.split(" ")
    array_string.each do |word|
      if word == array_string[-1]
        if word[0] == "#"
          convert_digit_to_braille(word)
        else
          convert_non_digit_to_braille(word)
        end
      elsif word[0] == "#"
        convert_digit_to_braille(word + " ")
      else
        convert_non_digit_to_braille(word + " ")
      end
    end
  end
end





if __FILE__ == $0
night = NightWriter.new
text = night.reader.read
shifted_text = night.add_shift_for_capital_character(text)
numbered_and_shifted_text = night.add_number_trigger(shifted_text)
braille_multi_variable_text = night.determine_digit_or_non_to_covert(numbered_and_shifted_text)
converted_text = night.create_single_string
binding.pry
night.write.write(converted_text)
puts ARGV
end
