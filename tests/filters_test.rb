require File.dirname(__FILE__) + '/test_helper'
require "controller"

class TestController < Controller
  before_filter :one
  around_filter :around1
  before_filter :two
  after_filter :three
  around_filter :around2
  
  def initialize(out)
    @out = out
  end
  
  def one
    @out << :one
  end
  
  def two
    @out << :two
  end
  
  def three
    @out << :three
  end
  
  def around1
    @out << "{"
    yield
    @out << "}"
  end
  
  def around2
    @out << "["
    yield
    @out << "]"
  end

  def index
    @out << :index
  end
end

class FiltersTest < Test::Unit::TestCase
  # def test_store_filters
  #   assert_equal [:one, :two], TestController.before_filters
  #   assert_equal [:three], TestController.after_filters
  #   assert_equal [:around1, :around2], TestController.around_filters
  # end
  
  def test_filter
    out = []
    TestController.new(out).process :index
    assert_equal [:one, "{", :two, "[", :index, "]", :three, "}"], out
  end
end