# == Schema Information
#
# Table name: images
#
#  id               :integer          not null, primary key
#  optimized        :integer
#  original_path    :string
#  original_width   :integer
#  original_height  :integer
#  original_size    :integer
#  optimized_path   :string
#  optimized_width  :integer
#  optimized_height :integer
#  optimized_size   :integer
#  quality          :integer
#  encoder          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
