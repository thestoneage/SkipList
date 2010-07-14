class SkipListNode
    include Comparable
    attr_reader :value, :next

    def initialize(value, next_nodes)
        @value, @next = value, next_nodes
    end

    def <=>(other)
        @value <=> other.value
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
        @head.next.size - 1
    end

    def insert item
        if (item.respond_to? :each)
            insert_array item
        else
            insert_value item
        end
    end

    def to_s
        str = ""
        each_node do |node|
            str << (" " + node.value.to_s + " ")
        end
        str << "\n"
        (0..max_level).each do |level|
            each_node do |node|
                o = node.next[level]
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

    def search_value value
        if (node_search_path(value).last.next[0].value == value)
            value
        else
            nil
        end
    end

    def each_node
        node = @head
        until (node == nil)
            yield node
            node = node.next[0]
        end
    end

    def each
      node = @head.next[0]
      until (node == @last)
        yield node.value
        node = node.next[0]
      end
    end

    def to_a
        a = []
        each { |e| a << e }
        return a
    end

    def insert_value value
        width = random_width
        new_node = SkipListNode.new(value, [@end]*width)
        search_path = node_search_path value
        (0..width).each do |level|
            source = search_path.pop
            new_node.next[level] = source.next[level]
            source.next[level] = new_node
        end
    end

    def delete_value value
        search_path = node_search_path value
        node = search_path.last.next[0]
        if (node.value == value)
            (0..node.next.size).each do |level|
                search_path.pop.next[level] = node.next[level]
            end
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
        while (node.next[level].value < value)
            node = node.next[level]
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

