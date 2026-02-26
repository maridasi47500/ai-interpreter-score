
require 'rtesseract'
require "tts"

class Score < ApplicationRecord
before_validation :hey
def pic=(hey)
uploaded_io = params[:person][:picture]
File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
  file.write(uploaded_io.read)
end
end
def hey
image_path = ' path to your image' 

begin
  result = RTesseract.new(image_path).to_s
# create a new instance of the RTesseract class , passing the image path as the parameter.
  self.title=result
  puts result  
rescue => e
  puts "Error : #{e.message}"
end
title.to_file "en", "./public/uploads/weather.mp3"
end

end
