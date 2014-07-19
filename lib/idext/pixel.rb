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


require "rubygems"
require "RMagick"

include Magick


module Magick
  class Pixel
    # 8 bit red, green, blue color values
    def rgb
      [(255*red/65535).to_i,
       (255*green/65535).to_i,
       (255*blue/65535).to_i]
    end

    def hsv
      rgb_color = rgb
      r = rgb_color[0]/255.to_f
      g = rgb_color[1]/255.to_f
      b = rgb_color[2]/255.to_f
      mx = [r, g, b].max
      mn = [r, g, b].min
      
      h = if mx == mn
            0
          elsif mx == r
            (60 * (g - b).to_f / (mx - mn) + 360)%360
          elsif mx == g
            (60 * (b - r).to_f / (mx - mn) + 120)
          else
            (60 * (r - g).to_f / (mx - mn) + 240)
          end

      s = if mx == 0
            0
          else
            (mx - mn).to_f / mx
          end
      v = mx
      
      [h, s, v]
    end

    def luminance
      r, g, b = *rgb
      0.299*r+0.587*g+0.114*b
    end

    def contrast(other_pixel)
      l1 = luminance
      l2 = other_pixel.luminance
      if l1 == l2
        0
      else
        2 * (l1 - l2).abs / (l1 + l2).to_f
      end
    end
  end
end

