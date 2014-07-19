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


require "idext/version"
require "idext/dataset"

def Idext.extract_data_from_images(dir, cdir,
                                   segment_width, segment_height,
                                   data_separator,
                                   output_filename, with_column_names)
  @dataset = Idext::Dataset.new(dir, cdir,
                    	        segment_width, segment_height,
                                data_separator,
                                output_filename, with_column_names)
  @dataset.generate
end
