require './lib./night_write'
require './lib./night_read'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'


class NightReaderTest < Minitest::Test
  include Dictionary
  def setup
    ARGV.pop
    night = FileReader.new
  end

  def test_it_can_split_string_at_new_line
    night = NightReader.new
    sliced_string = night.split_at_returns("The banana \nstand")
    assert_equal ["The banana ", "stand"], sliced_string
  end

  def test_it_moves_array_to_top_middle_bottom
    night = NightReader.new
    night.move_to_top_bottom_middle(["There", "is always", "money", "in the banana", "stand", " right"])
    assert_equal "Therein the banana", night.top
    assert_equal "is alwaysstand", night.middle
    assert_equal "money right", night.bottom
  end

  def test_it_can_slice_string_into_twos
    night = NightReader.new
    night.top = "The money in"
    sliced_string_of_twos = night.slice_string_into_twos
    assert_equal ["Th", "e ", "mo", "ne", "y ", "in"], night.top
  end

  def test_it_can_sort_top_middle_bottom
    night = NightReader.new
    night.top = ["Th", "ne",]
    night.middle = ["e ", "y "]
    night.bottom = ["mo", "in"]
    assert_equal [["Th", "e ", "mo"], ["ne", "y ", "in"]], night.create_braille_key
  end

  def test_it_creates_letter_string
    night = NightReader.new
    letter_string = night.create_letter_string([[".0", "00", "0."], ["0.", "00", ".."], ["0.", ".0", ".."], ["0.", "00", "0."], ["0.", ".0", ".."]])
    assert_equal "there", letter_string
  end

  def test_it_converts_to_numbers_from_trigger
    night = NightReader.new
    num = night.convert_to_numbers_from_trigger("#abcdef")
    assert_equal "123456", num
  end

  def test_it_rescans_and_converts_words
    night = NightReader.new
    formatted_string = night.rescan_for_numbers(["The", "#ejj", "bananas,", "#bjj", "dollars"])
    assert_equal "The 500 bananas, 200 dollars", formatted_string
  end

  def test_it_converts_capital_letters
    night = NightReader.new
    capitalized_string = night.rescan_for_capitals("`the `banana")
    assert_equal ["The", "Banana"], capitalized_string
  end


end