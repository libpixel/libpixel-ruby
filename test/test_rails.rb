require 'test_helper'

class LibPixelTest < ActionView::TestCase
  include LibPixel::ViewHelpers
  
  def setup
    LibPixel.default_source = "source"
    LibPixel.host = "example.libpx.com"
    LibPixel.secret = nil
  end
  
  test "Image tag with secret" do
    LibPixel.secret = "VerySecret"
    assert_equal "<img src=\"http://example.libpx.com/source/foo.jpg?signature=4d3a78f4c6caf5d9827f39f4f84c5b17255cabf1\" alt=\"Foo\" />", libpixel_image_tag("foo.jpg")
  end

  test "Image tag without secret" do
    assert_equal "<img src=\"http://example.libpx.com/source/foo.jpg\" alt=\"Foo\" />", libpixel_image_tag("foo.jpg")
  end
  
  test "Image tag with space" do
    assert_equal "<img src=\"http://example.libpx.com/source/foo%20.jpg\" alt=\"Foo%20\" />", libpixel_image_tag("foo .jpg")
  end

  test "Image tag using src in libpixel hash" do
    assert_equal "<img width=\"100\" alt=\"Foo\" src=\"http://example.libpx.com/source/?src=http%3A%2F%2Fa.b.com%2Ffoo.jpg&width=200\" />", libpixel_image_tag(:libpixel => {src: "http://a.b.com/foo.jpg", :width => 200}, :width => 100)
  end

  test "Name should take precedence when using both src and name" do
    assert_equal "<img src=\"http://example.libpx.com/source/bar.jpg\" alt=\"Bar\" />", libpixel_image_tag("bar.jpg", src: "http://a.b.com/foo.jpg")
  end

  test "Image tag without host" do
    LibPixel.host = nil
    assert_raise do
      libpixel_image_tag("foo.jpg")
    end
  end

  test "Image tag with source in given path" do
    LibPixel.default_source = nil
    assert_equal "<img src=\"http://example.libpx.com/source/foo.jpg\" alt=\"Foo\" />", libpixel_image_tag("source/foo.jpg")
  end

  test "Image tag with source in given path and leading slash" do
    LibPixel.default_source = nil
    assert_equal "<img src=\"http://example.libpx.com/source/foo.jpg\" alt=\"Foo\" />", libpixel_image_tag("/source/foo.jpg")
  end

  test "Image tag with default_source as region" do
    LibPixel.default_source = "us-east-1"
    assert_equal "<img src=\"http://example.libpx.com/us-east-1/source/foo.jpg\" alt=\"Foo\" />", libpixel_image_tag("source/foo.jpg")    
  end

  test "Image tag with source with slashes" do
    LibPixel.default_source = "/source/"
    assert_equal "<img src=\"http://example.libpx.com/source/foo.jpg\" alt=\"Foo\" />", libpixel_image_tag("foo.jpg")
  end

  test "Image tag with source with spaces should raise" do
    LibPixel.default_source = "us-east-1/foo bar"
    assert_raise {
      libpixel_image_tag("foo.jpg")
    }
  end

  test "Image tag with source supplied in options" do
    assert_equal "<img src=\"http://example.libpx.com/eu-west-1/source1/foo.jpg\" alt=\"Foo\" />", libpixel_image_tag("foo.jpg", :libpixel => {:source => "eu-west-1/source1"})
  end

  test "Image tag with url given" do
    assert_equal "<img width=\"200\" alt=\"Foo\" src=\"http://example.libpx.com/source/?width=400&src=http%3A%2F%2Fa.b.com%2Ffoo.jpg\" />", libpixel_image_tag("http://a.b.com/foo.jpg", :libpixel => {:width => 400}, :width => 200)
  end

  test "Image tag with libpixel width and img width specified" do
    assert_equal "<img width=\"200\" src=\"http://example.libpx.com/source/foo.jpg?width=400\" alt=\"Foo\" />", libpixel_image_tag("foo.jpg", :libpixel => {:width => 400}, :width => 200)
  end
end
