require File.expand_path("../lib/indexa", File.dirname(__FILE__))

scope do
  setup do
    document = %w(this is some document that I've indexed)
    indexer = Indexa.new
    indexer.redis.call('flushdb')
    [indexer, document]
  end

  test "delete a document from index" do |indexer, document|
    first = indexer.add(1, document)
    second = indexer.add(2, %w(altas llantas tiene el gato))
    indexer.remove(second)
    assert_equal indexer.redis.call('GET', 'Busca:document:1'), first.to_s
    assert_equal indexer.redis.call('GET', 'Busca:document:2'), nil
  end

  test "should vacant an id upon document deletion" do |indexer, document|
    first = indexer.add(1, document)
    second = indexer.add(2, %w(altas llantas tiene el gato))
    indexer.remove(second)
    assert_equal indexer.redis.call('GET', 'Busca:document:2'), nil
    assert_equal indexer.redis.call('LINDEX', 'Busca:vacants', 0), "2"
  end

  test "should use the vacant id on new document index" do |indexer, document|
    first = indexer.add(1, document)
    assert_equal indexer.redis.call('GET', 'Busca:document:1'), first.to_s
    indexer.redis.call('RPUSH', 'Busca:vacants', 3)
    foo = %w(My name is julian porta and Im a good person)
    second = indexer.add(3, foo)
    assert_equal indexer.redis.call('GET', 'Busca:document:3'), second.to_s
  end

end