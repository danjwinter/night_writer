require "./lib/night_write"

class FileReader
  def read
    filename = ARGV[0]
    (File.read(filename))
  end
end

class NightReader
  include Dictionary
  include FileWriter
  attr_reader :reader, :string, :top, :middle, :bottom, :braille_key
  attr_writer :top, :bottom, :middle

  def initialize
    @reader = FileReader.new
    @top = ""
    @middle = ""
    @bottom = ""
  end

  def split_at_returns(string)
    string.split("\n")
  end

  def move_to_top_bottom_middle(array)
    until array.length == 0 do
      @top << array.shift
      @middle << array.shift
      @bottom << array.shift
    end
  end

  def slice_string_into_twos
    @top = @top.scan(/.{2}/)
    @middle = @middle.scan(/.{2}/)
    @bottom = @bottom.scan(/.{2}/)
  end

  def create_braille_key
    braille_keys = []
    @top.each_index do |i|
      braille_keys[i] = [top[i], middle[i], bottom[i]]
    end
    braille_keys
  end

  def create_letter_string(braille_keys)
    letter_string = ""
    braille_keys.each do |key|
      letter_string << BRAILLE_TO_ALPHABET[key]
    end
    letter_string
  end

  def rescan_for_capitals(string)
    arr = []
    segmented_words = string.split
    segmented_words.each_with_index do |word|
      if word[0] == "`"
        arr << word[1..-1].capitalize!
      else
        arr << word
      end
    end
    arr
  end

  def rescan_for_numbers(arr)
    numbered_string = ""
    arr.each do |word|
      if word[0] == "#"
        numbered_string << convert_to_numbers_from_trigger(word) + " "
      else
        numbered_string << word + " "
      end
    end
    numbered_string[0..-2]
  end

  def convert_to_numbers_from_trigger(word)
    num = ""
    word.delete!("#")
    word.each_char do |char|
      num << LETTERS_TO_NUMBERS[char]
    end
    num
  end
end

if __FILE__ == $0
night = NightReader.new
text = night.reader.read
split_text = night.split_at_returns(text)
bisected_at_three_lines = night.move_to_top_bottom_middle(split_text)
sliced_into_twos = night.slice_string_into_twos
braille_key = night.create_braille_key
first_pass_letters = night.create_letter_string(braille_key)
capitalized_string = night.rescan_for_capitals(first_pass_letters)
final_string = night.rescan_for_numbers(capitalized_string)
night.write.write(final_string)
puts "Created '#{ARGV[1]}' containing #{final_string.length} characters."
end