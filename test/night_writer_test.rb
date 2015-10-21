require 'night_writer/night_writer'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

class NightWriterTest < Minitest::Test
  include Dictionary
  def setup
    ARGV.pop
    night = FileReader.new
  end

  def test_it_can_read_file
    night = NightWriter.new
    ARGV << "sample.txt"
    assert_equal "This is your first sample. 768 lkj 2932 ld", night.reader.read
  end

  def test_letters_convert_to_braille
    night = NightWriter.new
    night.convert_non_digit_to_braille("pizza")
    assert_equal "00.00.0.0.", night.top
    assert_equal "0.0..0.0..", night.middle
    assert_equal "0...0000..", night.bottom
  end

  def test_punctuation_convert_to_braille
    night = NightWriter.new
    night.convert_non_digit_to_braille("!',-.?")
    assert_equal "............", night.top
    assert_equal "00..0...000.", night.middle
    assert_equal "0.0...00.000", night.bottom
  end

  def test_letters_and_punctuation_convert_to_braille
    night = NightWriter.new
    night.convert_non_digit_to_braille("pizza!?")
    assert_equal "00.00.0.0.....", night.top
    assert_equal "0.0..0.0..000.", night.middle
    assert_equal "0...0000..0.00", night.bottom
  end

  def test_spaces_convert_to_braille_with_other_text
    night = NightWriter.new
    night.convert_non_digit_to_braille("pi za")
    assert_equal "00.0..0.0.", night.top
    assert_equal "0.0....0..", night.middle
    assert_equal "0.....00..", night.bottom
  end

  def test_spaced_letters_punctuation_convert_to_braille
    night = NightWriter.new
    night.convert_non_digit_to_braille("pi za!")
    assert_equal "00.0..0.0...", night.top
    assert_equal "0.0....0..00", night.middle
    assert_equal "0.....00..0.", night.bottom
  end

  def test_it_adds_shift_character_for_capital_letters
    night = NightWriter.new
    new_string = night.add_shift_for_capital_character("There's Always Money in the")
    assert_equal new_string, "`there's `always `money in the"
  end

  def test_it_converts_letters_with_capitals_to_braille
    night = NightWriter.new
    shift_with_letters = night.add_shift_for_capital_character("The")
    night.convert_non_digit_to_braille(shift_with_letters)
    assert_equal "...00.0.", night.top
    assert_equal "..0000.0", night.middle
    assert_equal ".00.....", night.bottom
  end

  def test_it_adds_number_trigger
    night = NightWriter.new
    new_string = night.add_number_trigger("there are 90 dollars and 10 bananas")
    assert_equal new_string, "there are #90 dollars and #10 bananas"
  end

  def test_it_converts_numbers
  night = NightWriter.new
  num_trigger_with_string = night.add_number_trigger("911")
  night.convert_digit_to_braille(num_trigger_with_string)
  assert_equal ".0.00.0.", night.top
  assert_equal ".00.....", night.middle
  assert_equal "00......", night.bottom
  end

  def test_it_converts_numbers_and_letters
    night = NightWriter.new
    string_num_ready = night.add_number_trigger("91 pizzas")
    night.determine_digit_or_non_to_covert(string_num_ready)
    assert_equal ".0.00...00.00.0.0..0", night.top
    assert_equal ".00.....0.0..0.0..0.", night.middle
    assert_equal "00......0...0000..0.", night.bottom
  end

  def test_it_converts_numbers_letters_and_capitals
    night = NightWriter.new
    num_ready = night.add_number_trigger("The 91 pizzas")
    num_and_cap_ready = night.add_shift_for_capital_character(num_ready)
    night.determine_digit_or_non_to_covert(num_and_cap_ready)
    assert_equal "...00.0....0.00...00.00.0.0..0", night.top
    assert_equal "..0000.0...00.....0.0..0.0..0.", night.middle
    assert_equal ".00.......00......0...0000..0.", night.bottom
  end

  def test_it_creates_single_string_with_correct_line_breaks
    night = NightWriter.new
    night.top = "aaaaaaaaaabbbbbbbbbbccccccccccdddddddddd" +
                "eeeeeeeeeeffffffffffgggggggggghhhhhhhhhh"
    night.middle = "aaaaaaaaaabbbbbbbbbbccccccccccdddddddddd" +
                   "eeeeeeeeeeffffffffffgggggggggghhhhhhhhhh"
    night.bottom = "aaaaaaaaaabbbbbbbbbbccccccccccdddddddddd" +
                   "eeeeeeeeeeffffffffffgggggggggghhhhhhhhhh"
                   binding.pry
    assert_equal "aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhh\naaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhh\naaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhh\n", night.create_single_string
  end
end
