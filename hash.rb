# This class works with rbx-2.2.6

class Hashy < Hash

  # Minimum load factor
  MIN_ENTRIES = 4

  def __setup__(capacity=MIN_SIZE, max=MAX_ENTRIES, min=MIN_ENTRIES, size=0, size_deleted=0)
    @capacity = capacity
    @mask     = capacity - 1
    @max_entries = max
    @min_entries = min
    @size     = size
    @size_deleted = size_deleted
    @entries  = Entries.new capacity
    @state    = State.new
  end
  private :__setup__

  class State
    def self.from(state)
      new_state = new
      new_state.compare_by_identity if state and state.compare_by_identity?
      new_state
    end

    def initialize
      @compare_by_identity = false
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
    attr_accessor :state
    attr_accessor :deleted

    def initialize(key, key_hash, value, state)
      @key      = key
      @key_hash = key_hash
      @value    = value
      @state    = state
      @deleted  = false
    end

    def delete(key, key_hash)
      if @state.match? @key, @key_hash, key, key_hash
        @size_deleted += 1
        @deleted = true
      end
    end
  end

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

    size_filled = @size - @size_deleted
    if @size > @max_entries or (size_filled < @min_entries and size_filled > MIN_ENTRIES)
      redistribute @entries
    end

    key_hash = key.hash
    index = key_index key_hash # key_hash & @mask
    item = @entries[index]

    while item
      if @state.match? item.key, item.key_hash, key, key_hash
        item.deleted = false if item.deleted
        return item.value = value
      end

      index = (1 + index) % @capacity
      item = @entries[index]

    end

    @entries[index] = new_bucket key, key_hash, value

    value
  end
  alias_method :store, :[]=

  # Adjusts the hash storage and redistributes the entries among
  # the new bins. Any Iterator instance will be invalid after a
  # call to #redistribute. Does not recalculate the cached key_hash
  # values. See +#rehash+.
  def redistribute(entries)
    capacity = @capacity
    size_filled = @size - @size_deleted
    @size_deleted = 0
    @size = size_filled

    # Rather than using __setup__, initialize the specific values we need to
    # change so we don't eg overwrite @state.
    if @size > @max_entries
      @capacity    = capacity * 2
      @max_entries = @max_entries * 2
      @min_entries = @min_entries * 2
    elsif size_filled < @min_entries and size_filled > MIN_ENTRIES
      @capacity    = capacity / 2
      @max_entries = @max_entries / 2
      @min_entries = @min_entries / 2
    end
    @entries     = Entries.new @capacity
    @mask        = @capacity - 1

    i = -1
    while (i += 1) < capacity
      item = entries[i]
      unless item.nil?
        next if item.deleted

        index = key_index item.key_hash
        index = (1 + index) % @capacity while @entries[index] 
        @entries[index] = item
      end
    end
  end
end
