# Idext

Idext is a simple tool to extract tabular data from images. Specifically, data is obtained from segments of images provided in a user-given directory. The width and height of segments can be changed. And from each segment the following data is obtained: 

 * **image_no**: id of image that the segment is obtained from
 * **pixel_count**: pixel count in the segment (width * height)
 * **row**: row position of the segment in the image
 * **column**: column position of the segment in the image
 * **vedge_mean**, **vedge_sd**: mean and standard deviation of contrast between vertically adjacent pixels
 * **hedge_mean**, **hedge_sd**: mean and standard deviation of contrast between horizontally adjacent pixels
 * **intensity_mean**: average of color intensity over all pixels of the segment
 * **rawred_mean**, **rawgreen_mean**, **rawblue_mean**: mean of color values
 * **exred_mean**, **exgreen_mean**, **exblue_mean**: average of excess color values (exred = 2 red - green - blue)
 * **hue_mean**, **saturation_mean**, **value_mean**: average color of pixels in hue, saturation, value space

Each segment can also be assigned a class. For each image from which data is extracted, user is allowed to supply an class-image to characterize classes in the image. Specifically, user can prepare class-images by painting the parts in the images in red, green, blue, black, or white each of which correspond to a certain class.  

Example
-------

Suppose we have a list of images in **images** folder from which we want to extract some data. 

We can identify certain classes in these images by painting *paths* with red, *grass* with green and *trees* with blue color. We put these 
class-images in **classimages** folder. Assume, we would like to divide images into segments of 10x10 size. With the following code we can 
extract tabular data with columns separated by comma in a file called **datafile.txt**.  

```ruby

require "idext"

def extract_data
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

extract_data()
```


