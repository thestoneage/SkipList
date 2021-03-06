$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), '..',  'lib'))

require 'test/unit'
require 'skiplist.rb'

class TestSkipList < Test::Unit::TestCase
  def setup
    @unsorted = [84, 52, 53, 35, 46, 18, 95, 88, 26, 4]
    @sorted   = @unsorted.sort
    @skiplist = SkipList.new(16)
    @skiplist.insert(*@unsorted)
  end

  def test_insert_array
    assert_equal(@sorted, @skiplist.to_a, 'Should be equal')
  end

  def test_insert_value_using_insert
    @skiplist.insert(10)
    assert_equal((@unsorted << 10).sort, @skiplist.to_a, 'Should be equal')
  end

  def test_insert_value_using_push
    @skiplist << 10
    assert_equal((@unsorted << 10).sort, @skiplist.to_a, 'Should be equal')
  end

  def test_search
    assert_equal(52, @skiplist.search(52), 'Should return 52 as 52 is a skiplist member')
    assert_equal(nil, @skiplist.search(54), 'Should return nil as 54 is not a skiplist member')
  end

  def test_delete
    @skiplist.delete(52)
    @sorted.delete(52)
    assert_equal(@sorted, @skiplist.to_a, 'Should be equal')
  end
end
