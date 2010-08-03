class SkipList
  class SkipListNode
    include Comparable
    attr_reader :value, :forward

    def initialize(value, forward)
      @value, @forward = value, forward
    end

    def <=>(other)
      @value <=> other.value
    end

    def next
      @forward[0]
    end

    def to_s
      value.to_s
    end
  end

  class << (Infinity = Object.new)
    include Comparable

    def <=> _
      return 1
    end

    def to_s
      'E'
    end
  end

  include Enumerable
  def initialize(levels)
    @last = SkipListNode.new(Infinity, [])
    @head = SkipListNode.new('H', [@last]*levels)
  end

  def << value
    new_node = SkipListNode.new(value, [])
    search_path = node_search_path value
    search_path.reverse[0, random_width].each_with_index do |source, level|
      new_node.forward[level] = source.forward[level]
      source.forward[level] = new_node
    end
  end

  def insert *elements
    elements.each(&method(:<<))
  end

  def search value
    if (node_search_path(value).last.next.value == value)
      value
    end
  end

  def delete value
    search_path = node_search_path value
    node = search_path.last.next
    if (node.value == value)
      search_path.reverse[0,node.forward.size].each_with_index do |n, level|
        n.forward[level] = node.forward[level]
      end
    end
  end

  def each
    node = @head.next
    until (node == @last)
      yield node.value
      node = node.next
    end

    self
  end

  def to_a
    reduce([], :<<)
  end

  def to_s
    str = ''
    each_node do |node|
      str << " #{node} "
    end
    str << "\n"
    (0..max_level).each do |level|
      each_node do |node|
        o = node.forward[level]
        if o
          p = o
        else
          p = 'n'
        end
        str << " #{p} "
      end
      str << "\n"
    end
    return str
  end

  private

  def max_level
    @head.forward.size - 1
  end

  def each_node
    node = @head
    until node.nil?
      yield node
      node = node.next
    end
  end

  def node_search_path value
    node = @head
    max_level.downto(0).reduce([]) do |path, level|
      path.tap {|path|
        node = find_left_neighbor(level, node, value)
        path << node
      }
    end
  end

  def find_left_neighbor(level, node, value)
    while (node.forward[level].value < value)
      node = node.forward[level]
    end
    return node
  end

  def random_width
    h = 1
    while (rand < 0.5 and h <= max_level)
      h += 1
    end
    return h
  end
end
