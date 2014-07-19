# Copyright 2010, 2014 Ahmet Cetinkaya

# This file is part of Idext.

# Idext is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Idext is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Idext.  If not, see <http://www.gnu.org/licenses/>.


require "RMagick"
require_relative "pixelmatrix"


module Idext
  class Dataset
    def filenames_in(dir)
      Dir.entries(dir).find_all{ |f|
        !File.directory?(f)
      }.sort.map{|filename|
        File.join(dir, filename)
      }
    end
    
    def initialize(dir, cdir,
                   segment_width, segment_height,
                   data_separator,
                   output_filename, with_column_names)
      
      input_image_filenames = filenames_in(dir)
      @nof_images = input_image_filenames.length
      @input_images = ImageList.new(*input_image_filenames)
      
      if (cdir)
        @with_classes = true
        class_image_filenames = filenames_in(cdir)
        @class_images = ImageList.new(class_image_filenames)
      end
      
      @segment_width = segment_width
      @segment_height = segment_height

      @data_separator = data_separator
      
      @output_filename = output_filename
      @with_column_names = with_column_names
    end
  
  def title_texts 
    ["image_no", 
     "segment_pixel_count",
     "row", "column",
     "vedge_mean",
     "vedge_sd",
     "hedge_mean",
     "hedge_sd",
     "intensity_mean",
     "rawred_mean",
     "rawgreen_mean",
     "rawblue_mean",
     "exred_mean",
     "exgreen_mean",
     "exblue_mean",
     "hue_mean",
     "saturation_mean",
     "value_mean"].map{|t| t.gsub("_", "")}
  end

  def generate
    data = []
    title = title_texts
    title << "class" if @with_classes
    data << title
    @nof_images.times do |s|
      @input_images.scene = s
      @class_images.scene = s if @with_classes
      
      width = @input_images.columns
      height = @input_images.rows

      row_count = (height/@segment_height.to_f).floor.to_i
      column_count = (width/@segment_width.to_f).floor.to_i

      row_count.times do |row|
        column_count.times do |column|
          p_class = -1 # p_class will be changed or not used
          if @with_classes
            p_class = Segment.new(@class_images.get_pixels(column*@segment_width,
                                                           row*@segment_height,
                                                           @segment_width,
                                                           @segment_height)).class
          end
          data_point = Segment.new(@input_images.get_pixels(column*@segment_width,
                                                            row*@segment_height,
                                                            @segment_width,
                                                            @segment_height)).to_data_point(s+1, row, column)
          (data_point << p_class) if @with_classes
          data << data_point if p_class != -1
        end
      end

      if @with_column_names
        File.open(@output_filename, "w") do |f|
          f.puts data.map{|data_point| data_point.join(@data_separator)}.join("\n")
        end
      else
        File.open(@notitle_dataset_filename, "w") do |f|
          f.puts data.drop(1).map{|data_point| data_point.join(@data_separator)}.join("\n")
        end
      end
    end
  end
end
