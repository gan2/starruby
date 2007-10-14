#!/usr/bin/env ruby

require "../starruby"
require "test/unit"

include StarRuby

class ColorTest < Test::Unit::TestCase

  def test_color
    c1 = Color.new(1, 2, 3, 4)
    c2 = Color.new(5, 6, 7)

    assert_equal 1, c1.red
    assert_equal 2, c1.green
    assert_equal 3, c1.blue
    assert_equal 4, c1.alpha
    assert_equal 255, c2.alpha

    assert c1 == Color.new(1, 2, 3, 4)
    assert c2 == Color.new(5, 6, 7)
    assert c2 == Color.new(5, 6, 7, 255)
    assert c1 != Color.new(1, 2, 3, 5)
    assert c1 != Object.new
    assert c1.eql?(Color.new(1, 2, 3, 4))
    assert_equal c1.hash, Color.new(1, 2, 3, 4).hash
    assert_equal c2.hash, Color.new(5, 6, 7).hash
  end

  def test_color_overflow
    c = Color.new(-100, 256, -1, 999)
    assert_equal 0,   c.red
    assert_equal 255, c.green
    assert_equal 0,   c.blue
    assert_equal 255, c.alpha
    
    c = Color.new(999, -1, 256, -100)
    assert_equal 255, c.red
    assert_equal 0,   c.green
    assert_equal 255, c.blue
    assert_equal 0,   c.alpha
  end
  
  def test_to_s
    c = Color.new(1, 2, 3, 4)
    assert_equal "#<StarRuby::Color alpha=4, red=1, green=2, blue=3>", c.to_s
    c = Color.new(255, 255, 255, 255)
    assert_equal "#<StarRuby::Color alpha=255, red=255, green=255, blue=255>", c.to_s
  end
  
end

class ToneTest < Test::Unit::TestCase
  
  def test_tone
    t1 = Tone.new(1, 2, 3, 4)
    t2 = Tone.new(5, 6, 7)

    assert_equal 1, t1.red
    assert_equal 2, t1.green
    assert_equal 3, t1.blue
    assert_equal 4, t1.saturation
    assert_equal 255, t2.saturation

    assert t1 == Tone.new(1, 2, 3, 4)
    assert t2 == Tone.new(5, 6, 7)
    assert t2 == Tone.new(5, 6, 7, 255)
    assert t1 != Tone.new(1, 2, 3, 5)
    assert t1 != Object.new
    assert t1.eql?(Tone.new(1, 2, 3, 4))
    assert_equal t1.hash, Tone.new(1, 2, 3, 4).hash
    assert_equal t2.hash, Tone.new(5, 6, 7).hash
  end
  
  def test_tone_overflow
    t = Tone.new(-256, 256, -999, 999)
    assert_equal -255, t.red
    assert_equal 255,  t.green
    assert_equal -255, t.blue
    assert_equal 255,  t.saturation
    
    t = Tone.new(256, -256, 999, -999)
    assert_equal 255,  t.red
    assert_equal -255, t.green
    assert_equal 255,  t.blue
    assert_equal 0,    t.saturation
  end
  
  def test_to_s
    t = Tone.new(1, 2, 3, 4)
    assert_equal "#<StarRuby::Tone red=1, green=2, blue=3, saturation=4>", t.to_s
    t = Tone.new(-255, -255, -255, 255)
    assert_equal "#<StarRuby::Tone red=-255, green=-255, blue=-255, saturation=255>", t.to_s
  end
  
end

class GameTest < Test::Unit::TestCase
  
  def test_game
    assert_equal false, Game.running?
    assert_equal "hoge1", (Game.title = "hoge1")
    assert_equal "hoge1", Game.title
    assert_equal 30, Game.fps;
    assert_equal 31, (Game.fps = 31)
    assert_equal 31, Game.fps
    Game.run do
      assert_equal true, Game.running?
      assert_equal "hoge2", (Game.title = "hoge2")
      assert_equal "hoge2", Game.title
      assert_equal 32, (Game.fps = 32)
      assert_equal 32, Game.fps
      assert_raise StarRubyError do
        Game.run {}
      end
      Game.terminate
      assert_equal true, Game.running?
    end
    assert_equal false, Game.running?
    assert_equal "hoge3", (Game.title = "hoge3")
    assert_equal "hoge3", Game.title
    assert_equal 33, (Game.fps = 33)
    assert_equal 33, Game.fps
  end
  
end

class ScreenTest < Test::Unit::TestCase
  
  def test_size
    assert_equal 320, Screen.width
    assert_equal 240, Screen.height
    assert_equal [320, 240], Screen.size
    assert_equal true, Screen.size.frozen?
  end
  
  def test_offscreen
    assert_kind_of Texture, Screen.offscreen
    assert_equal Screen.width, Screen.offscreen.width
    assert_equal Screen.height, Screen.offscreen.height
  end
  
end

class TextureTest < Test::Unit::TestCase
  
  def test_new
    texture = Texture.new(123, 456)
    assert_equal 123, texture.width
    assert_equal 456, texture.height
    assert_equal [123, 456], texture.size
    assert_equal true, texture.size.frozen?
  end
  
  def test_load
    texture = Texture.load("images/ruby.png")
    assert_equal 50, texture.width
    assert_equal 35, texture.height
    assert_equal [50, 35], texture.size
    
    assert_raise Errno::ENOENT do
      Texture.load("invalid_path/foo.png")
    end
    
    assert_raise Errno::ENOENT do
      Texture.load("images/not_existed.png")
    end
    
    assert_not_nil Texture.load("images/ruby");
    assert_not_nil Texture.load("images/rubypng");
    assert_not_nil Texture.load("images/ruby.foo");
    assert_not_nil Texture.load("images/ruby.foo.png");
    
    assert_raise StarRubyError do
      Texture.load("images/not_image");
    end
    
    assert_raise StarRubyError do
      Texture.load("images/not_image.txt");
    end
  end
  
  def test_clone
    texture = Texture.load("images/ruby")
    texture2 = texture.clone
    assert_equal texture.size, texture2.size
    texture.freeze
    assert texture.clone.frozen?
    texture.height.times do |j|
      texture.width.times do |i|
        assert_equal texture.get_pixel(i, j), texture2.get_pixel(i, j)
      end
    end
  end
  
  def test_dup
    texture = Texture.load("images/ruby")
    texture2 = texture.dup
    assert_equal texture.size, texture2.size
    texture.freeze
    assert !texture.dup.frozen?
    texture.height.times do |j|
      texture.width.times do |i|
        assert_equal texture.get_pixel(i, j), texture2.get_pixel(i, j)
      end
    end
  end
  
  def test_dispose
    texture = Texture.load("images/ruby")
    assert_equal false, texture.disposed?
    texture.dispose
    assert_equal true, texture.disposed?
    assert_raise StarRubyError do
      texture.dispose
    end
    # TODO: change_hue
  end
  
  def test_get_and_set_pixel
    texture = Texture.new(3, 3)
    texture.height.times do |y|
      texture.width.times do |x|
        assert_equal Color.new(0, 0, 0, 0), texture.get_pixel(x,y)
      end
    end
    
    begin
      texture.get_pixel(-1, 2)
      flunk
    rescue IndexError => e
      assert_equal "index out of range: (-1, 2)", e.message
    end
    
    begin
      texture.get_pixel(2, -1)
      flunk
    rescue IndexError => e
      assert_equal "index out of range: (2, -1)", e.message
    end
    
    begin
      texture.get_pixel(3, 2)
      flunk
    rescue IndexError => e
      assert_equal "index out of range: (3, 2)", e.message
    end
    
    begin
      texture.get_pixel(2, 3)
      flunk
    rescue IndexError => e
      assert_equal "index out of range: (2, 3)", e.message
    end
    
    assert_equal Color.new(31, 41, 59, 26), texture.set_pixel(0, 1, Color.new(31, 41, 59, 26))
    assert_equal Color.new(53, 58, 97, 92), texture.set_pixel(1, 2, Color.new(53, 58, 97, 92))
    assert_equal Color.new(65, 35, 89, 79), texture.set_pixel(2, 0, Color.new(65, 35, 89, 79))
    assert_equal Color.new(31, 41, 59, 26), texture.get_pixel(0, 1);
    assert_equal Color.new(53, 58, 97, 92), texture.get_pixel(1, 2);
    assert_equal Color.new(65, 35, 89, 79), texture.get_pixel(2, 0);
    
    begin
      texture.set_pixel(-1, 2, Color.new(0, 0, 0))
      flunk
    rescue IndexError => e
      assert_equal "index out of range: (-1, 2)", e.message
    end
    
    begin
      texture.set_pixel(2, -1, Color.new(0, 0, 0))
      flunk
    rescue IndexError => e
      assert_equal "index out of range: (2, -1)", e.message
    end
    
    begin
      texture.set_pixel(3, 2, Color.new(0, 0, 0))
      flunk
    rescue IndexError => e
      assert_equal "index out of range: (3, 2)", e.message
    end
    
    begin
      texture.set_pixel(2, 3, Color.new(0, 0, 0))
      flunk
    rescue IndexError => e
      assert_equal "index out of range: (2, 3)", e.message
    end
  end
  
  def test_get_pixel_disposed
    texture = Texture.new(3, 3)
    texture.dispose
    assert_raise TypeError do
      texture.get_pixel(0, 1)
    end
  end
  
  def test_set_pixel_frozen
    texture = Texture.new(3, 3)
    texture.freeze
    assert_raise TypeError do
      texture.set_pixel(0, 1, Color.new(31, 41, 59, 26))
    end
  end
  
  def test_set_pixel_disposed
    texture = Texture.new(3, 3)
    texture.dispose
    assert_raise TypeError do
      texture.set_pixel(0, 1, Color.new(31, 41, 59, 26))
    end
  end
  
  def test_change_hue
    # TODO
  end
  
  def test_clear
    texture = Texture.load("images/ruby")
    texture.clear
    texture.height.times do |y|
      texture.width.times do |x|
        assert_equal Color.new(0, 0, 0, 0), texture.get_pixel(x, y)
      end
    end
  end
  
  def test_clear_frozen
    texture = Texture.load("images/ruby")
    texture.freeze
    assert_raise TypeError do
      texture.clear
    end
  end
  
  def test_clear_disposed
    texture = Texture.load("images/ruby")
    texture.dispose
    assert_raise TypeError do
      texture.clear
    end
  end
  
  def test_fill
    texture = Texture.load("images/ruby")
    texture.fill(Color.new(31, 41, 59, 26))
    texture.height.times do |y|
      texture.width.times do |x|
        assert_equal Color.new(31, 41, 59, 26), texture.get_pixel(x, y)
      end
    end
  end
  
  def test_fill_frozen
    texture = Texture.load("images/ruby")
    texture.freeze
    assert_raise TypeError do
      texture.fill(Color.new(31, 41, 59, 26))
    end
  end
  
  def test_fill_disposed
    texture = Texture.load("images/ruby")
    texture.dispose
    assert_raise TypeError do
      texture.fill(Color.new(31, 41, 59, 26))
    end
  end

  def test_fill_rect
    texture = Texture.load("images/ruby")
    orig_texture = texture.clone
    texture.fill_rect 10, 11, 12, 13, Color.new(12, 34, 56, 78)
    texture.height.times do |y|
      texture.width.times do |x|
        if 10 <= x and 11 <= y and x < 22 and y < 24
          assert_equal Color.new(12, 34, 56, 78), texture.get_pixel(x, y)
        else
          assert_equal orig_texture.get_pixel(x, y), texture.get_pixel(x, y)
        end
      end
    end
  end
  
  def test_fill_rect_frozen
    texture = Texture.load("images/ruby")
    texture.freeze
    assert_raise TypeError do
      texture.fill_rect 10, 11, 12, 13, Color.new(12, 34, 56, 78)
    end
  end
  
  def test_fill_rect_disposed
    texture = Texture.load("images/ruby")
    texture.dispose
    assert_raise TypeError do
      texture.fill_rect 10, 11, 12, 13, Color.new(12, 34, 56, 78)
    end
  end

end
