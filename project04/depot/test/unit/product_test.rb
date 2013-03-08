require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product attributes must not be empty" do
	  product = Product.new
	  assert product.invalid?
	  assert product.errors[:title].any?
	  assert product.errors[:descritption].any?
	  assert product.errors[:price].any?
	  assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
  	product = Product.new(:title => "My Book Title",
  						  :descritption => "yyy",
  						  :image_url => "zzz.jpg")
  	product.price = -1
  	assert product.invald?
  	assert_equal "must be greater than or equal to 0.01", 
  		product.error[:price].join('; ')

  	product.price = 1
  	assert product.valid?
  end

  test "image url" do
  	ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.jpg
  			http://a.b.c/x/y/z/fred.gif }
  	bad = %w{ fred.doc fred.gif/more frid.gif.more }

  	ok.each do |name|
  		assert new_product(name).valid?, "#{name} shouldn't be valid"
  	end

  	bad.each do |name|
  		assert new_product(name).invalud?, "#{name} shouldn't be valid"
  	end
  end

  def new_product(image_url)
  	Product.new(:title => "My Book Title",
  				:descritption => "yyy",
  				:price => 1,
  				:image_url => image_url)
  end
end
