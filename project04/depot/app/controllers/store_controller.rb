class StoreController < ApplicationController
  def index
  	@products = Products.all
  end
end