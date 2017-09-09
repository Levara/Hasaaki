class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.integer    :optimized

      t.string     :original_path
      t.integer    :original_width
      t.integer    :original_height
      t.integer    :original_size

      t.string     :optimized_path
      t.integer    :optimized_width
      t.integer    :optimized_height
      t.integer    :optimized_size

      t.integer    :quality
      t.string     :encoder

      t.timestamps
    end
  end
end
