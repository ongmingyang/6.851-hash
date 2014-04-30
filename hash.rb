# This class works with rbx-2.2.6

class Hashy < Hash
  include Enumerable
  Entries = Rubinius::Tuple

  # Initial size of Hash. MUST be a power of 2.
  MIN_SIZE = 16
  # Maximum load factor
  MAX_ENTRIES = 12
  # Minimum load factor
  MIN_ENTRIES = 4

  # This allows us to see the internal structure of the table
  attr_reader :entries

  def __setup__(capacity=MIN_SIZE, max=MAX_ENTRIES, min=MIN_ENTRIES, size=0)
    @capacity = capacity
    @mask     = capacity - 1
    @max_entries = max
    @min_entries = min
    @size     = size
    @entries  = Entries.new capacity
    @state    = State.new
  end
  private :__setup__

  class State
    attr_accessor :head
    attr_accessor :tail

    def self.from(state)
      new_state = new
      new_state.compare_by_identity if state and state.compare_by_identity?
      new_state
    end

    def initialize
      @compare_by_identity = false
      @head = nil
      @tail = nil
    end

    def compare_by_identity?
      @compare_by_identity
    end

    def compare_by_identity
      @compare_by_identity = true

      class << self
        def match?(this_key, this_hash, other_key, other_hash)
          Rubinius::Type.object_equal other_key, this_key
        end
      end

      self
    end

    def match?(this_key, this_hash, other_key, other_hash)
      other_hash == this_hash and (Rubinius::Type::object_equal(other_key, this_key) or other_key.eql?(this_key))
    end
  end

  class Bucket
    attr_accessor :key
    attr_accessor :key_hash
    attr_accessor :value
    attr_accessor :previous
    attr_accessor :next
    attr_accessor :state
    attr_accessor :deleted

    def initialize(key, key_hash, value, state)
      @key      = key
      @key_hash = key_hash
      @value    = value
      @state    = state
      @deleted  = false

      if tail = state.tail
        @previous = tail
        state.tail = tail.next = self
      else
        state.head = state.tail = self
      end
    end

    def delete(key, key_hash)
      if !@deleted and @state.match? @key, @key_hash, key, key_hash
        @deleted = true
        remove
        return true
      else
        return false
      end
    end

    def remove
      if @previous
        @previous.next = @next
      else
        @state.head = @next
      end

      if @next
        @next.previous = @previous
      else
        @state.tail = @previous
      end
    end
  end

  def key?(key)
    find_item(key) != nil
  end

  alias_method :has_key?, :key?
  alias_method :include?, :key?
  alias_method :member?, :key?

  # Calculates the +@entries+ slot given a key_hash value.
  # TODO do simple tabulation hashing instead
  def key_index(key_hash)
    key_hash & @mask
  end
  private :key_index

  def new_bucket(key, key_hash, value)
    if key.kind_of?(String) and !key.frozen?
      key = key.dup
      key.freeze
    end

    @size += 1
    Bucket.new key, key_hash, value, @state
  end
  private :new_bucket

  def find_item(key)
    key_hash = key.hash
    index = key_index key_hash
    item = @entries[index]

    while item
      if !item.deleted and @state.match? item.key, item.key_hash, key, key_hash
        return item
      end

      index = (1 + index) % @capacity
      item = @entries[index]
    end
  end

  def []=(key, value)
    Rubinius.check_frozen

    if @size > @max_entries or (@size < @min_entries and @size > MIN_ENTRIES)
      redistribute @entries
    end

    key_hash = key.hash
    index = key_index key_hash
    item = @entries[index]

    while item
      if item.deleted
        item.key = key
        item.key_hash = key_hash
        item.deleted = false
        @size += 1
        return item.value = value
      end

      if @state.match? item.key, item.key_hash, key, key_hash
        return item.value = value
      end

      index = (1 + index) % @capacity
      item = @entries[index]

    end

    @entries[index] = new_bucket key, key_hash, value

    value
  end
  alias_method :store, :[]=

  def delete(key)
    key_hash = key.hash
    if item = find_item(key)
      if item.delete key, key_hash
        @size -= 1
        return item.value
      end
    end

    return yield(key) if block_given?
  end

  # Adjusts the hash storage and redistributes the entries among
  # the new bins. Any Iterator instance will be invalid after a
  # call to #redistribute. Does not recalculate the cached key_hash
  # values. See +#rehash+.
  def redistribute(entries)
    capacity = @capacity

    # Rather than using __setup__, initialize the specific values we need to
    # change so we don't eg overwrite @state.
    if @size > @max_entries
      @capacity    = capacity * 2
      @max_entries = @max_entries * 2
      @min_entries = @min_entries * 2
    else
      @capacity    = capacity / 2
      @max_entries = @max_entries / 2
      @min_entries = @min_entries / 2
    end

    @entries     = Entries.new @capacity
    @mask        = @capacity - 1

    i = -1
    while (i += 1) < capacity
      if item = entries[i]
        next if item.deleted
        index = key_index item.key_hash
        index = (1 + index) % @capacity while @entries[index] 
        @entries[index] = item
      end
    end
  end
end
