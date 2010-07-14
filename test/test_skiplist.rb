require "test/unit"
require "lib/skiplist.rb"

class TestSkipList < Test::Unit::TestCase
 def setup
      @data = [3, 6, 7, 9, 12, 17, 19, 21, 25, 26]
      @skiplist = SkipList.new(16)
      @skiplist.insert(@data)
 end

 def test_to_a
     assert_equal(@skiplist.to_a, @data, "Should be equal")
 end
end
