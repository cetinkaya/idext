require "test_helper"

class IdexTest < Test::Unit::TestCase
  def test_version
    assert_equal "0.0.1", Idext::VERSION
  end

  def test_data_extraction
    dir = "images"
    cdir = "classimages"
    segment_width = 10
    segment_height = 10
    data_separator = ","
    output_filename = "datafile.txt"
    with_column_names = true
    Idext.extract_data_from_images(dir, cdir,
                                   segment_width, segment_height,
                                   data_separator,
                                   output_filename, with_column_names)
  end
end
