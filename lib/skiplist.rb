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
end

class Infinity
    include Comparable

    def <=> other
        return 1
    end

    def to_s
        "E"
    end
end

class SkipList
    def initialize(levels)
        @last  = SkipListNode.new(Infinity.new, [])
        @head = SkipListNode.new("H", [@last]*levels)
    end

    def max_level
        @head.forward.size - 1
    end

    def insert item
        if (item.respond_to? :each)
            insert_array item
        else
            insert_value item
        end
    end

    def insert_value value
        width = random_width
        new_node = SkipListNode.new(value, [@end]*width)
        search_path = node_search_path value
        (0..width).each do |level|
            source = search_path.pop
            new_node.forward[level] = source.forward[level]
            source.forward[level] = new_node
        end
    end

    def search value
        if (node_search_path(value).last.next.value == value)
            value
        else
            nil
        end
    end

    def delete value
        search_path = node_search_path value
        node = search_path.last.next
        if (node.value == value)
            (0..node.forward.size).each do |level|
                search_path.pop.forward[level] = node.forward[level]
            end
        end
    end

    def each
      node = @head.next
      until (node == @last)
        yield node.value
        node = node.next
      end
    end

    def to_a
        a = []
        each { |e| a << e }
        return a
    end

    def to_s
        str = ""
        each_node do |node|
            str << (" " + node.value.to_s + " ")
        end
        str << "\n"
        (0..max_level).each do |level|
            each_node do |node|
                o = node.forward[level]
                if o
                    p = o.value.to_s
                else
                    p = "n"
                end
                str << (" " + p + " ")
            end
            str << "\n"
        end
        return str
    end

    def each_node
        node = @head
        until (node == nil)
            yield node
            node = node.next
        end
    end

    def node_search_path value
        path = []
        node = @head
        (0..max_level).reverse_each do |level|
           path << find_left_neighbor(level, node, value)
        end
        return path
    end

    def find_left_neighbor(level, start_node, value)
        node = start_node
        while (node.forward[level].value < value)
            node = node.forward[level]
        end
        return node
    end

    def random_width
        h = 0
        while (rand < 0.5 and h <= max_level)
            h += 1
        end
        return h
    end

    def insert_array array
        array.each { |e| insert_value e }
    end
end

