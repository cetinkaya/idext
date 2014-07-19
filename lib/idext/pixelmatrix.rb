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


require_relative "pixel"


class Array
  def sum
    self.reduce(0){|a, b| a+b}
  end
  
  def mean
    sum / length.to_f
  end
  
  def sd
    mn = mean
    Math.sqrt(self.map{|x| (x-mn)*(x-mn)}.mean)
  end
end


module Idext
  # PixelMatrix is a matrix of pixels
  class PixelMatrix
    def initialize(pixels, nof_rows)
      @pixels = pixels
      @nof_rows = nof_rows
      unless @nof_rows > 0 and pixels.length % @nof_rows == 0
        raise "Number of pixels is not a multiple of number of rows." 
      end
      @nof_columns = (pixels.length / nof_rows).floor.to_i
    end

    def length
      @pixels.length
    end

    def [](i, j)
      @pixels[i * @nof_columns + j]
    end

    def matrix_access(i, j)
      self[i, j]
    end
        
    def horizontal_adjacent_pixels
      ha_pixels = []
      
      @nof_rows.times do |i|
        (@nof_columns-1).times do |j|
          ha_pixels << [matrix_access(i, j), matrix_access(i, j+1)]
        end
      end
      ha_pixels
    end

    def vertical_adjacent_pixels
      va_pixels = []
      
      @nof_columns.times do |i|
        (@nof_rows-1).times do |j|
          va_pixels << [matrix_access(j, i), matrix_access(j+1, i)]
        end
      end
      va_pixels
    end
    
    def vedge_mean
      horizontal_adjacent_pixels.map{|xy| x=xy[0]; y=xy[1]; x.contrast(y)}.mean
    end

    def vedge_sd
      horizontal_adjacent_pixels.map{|xy| x=xy[0]; y=xy[1]; x.contrast(y)}.sd
    end
    
    def hedge_mean
      vertical_adjacent_pixels.map{|xy| x=xy[0]; y=xy[1]; x.contrast(y)}.mean
    end

    def hedge_sd
      vertical_adjacent_pixels.map{|xy| x=xy[0]; y=xy[1]; x.contrast(y)}.sd
    end
    
    def intensity_mean
      @pixels.map{|x| x.rgb.sum/3.to_f}.mean
    end
    
    def rawred_mean
      @pixels.map{|x| x.rgb[0]}.mean
    end
    
    def rawgreen_mean
      @pixels.map{|x| x.rgb[1]}.mean
    end

    def rawblue_mean
      @pixels.map{|x| x.rgb[2]}.mean
    end
    
    def exred_mean
      2 * rawred_mean - (rawgreen_mean + rawblue_mean)
    end
    
    def exgreen_mean
      2 * rawgreen_mean - (rawred_mean + rawblue_mean)
    end
    
    def exblue_mean
      2 * rawblue_mean - (rawred_mean + rawgreen_mean)
    end
    
    def hue_mean
      @pixels.map{|x| x.hsv[0]}.mean
    end
    
    def saturation_mean
      @pixels.map{|x| x.hsv[1]}.mean
    end

    def value_mean
      @pixels.map{|x| x.hsv[2]}.mean
    end
    
    def pixel_count
      @nof_rows * @nof_columns
    end
    
    def to_data_point(image_no, row, column)
      [image_no, 
       pixel_count,
       row, column,
       vedge_mean,
       vedge_sd,
       hedge_mean,
       hedge_sd,
       intensity_mean,
       rawred_mean,
       rawgreen_mean,
       rawblue_mean,
       exred_mean,
       exgreen_mean,
       exblue_mean,
       hue_mean,
       saturation_mean,
       value_mean]
    end
    
    def class
      # there are 5 possible classes
      # the class is selected as the color
      # that maximum number of pixels have
      class_numbers = {"red" => 1, 
        "green" => 2,
        "blue" => 3,
        "black" => 4,
        "white" => 5}
      
      color_counts = {"red" => 0,
        "green" => 0,
        "blue" => 0,
        "black" => 0,
        "white" => 0}
      
      @pixels.each.map{|pixel| pixel.rgb}.each do |color|
        color_key = "white"
        if color[0] > 200 and color[1] < 20 and color[2] < 20
          color_key = "red"
        elsif color[0] < 20 and color[1] > 200 and color[2] < 20
          color_key = "green"
        elsif color[0] < 20 and color[1] < 20 and color[2] > 200
          color_key = "blue"
        elsif color[0] < 20 and color[1] < 20 and color[2] < 20
          color_key = "black"
        elsif color[0] > 200 and color[1] > 200 and color[2] > 200
          color_key = "white"
        end
        color_counts[color_key] += 1
      end
      
      max_key = "red"
      max_count = 0
      color_counts.each_pair do |key, value|
        if color_counts[key] >= max_count
          max_key = key
          max_count = color_counts[key]
        end
      end
      
      class_numbers[max_key]
    end
  end
end
