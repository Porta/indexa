require File.expand_path("../lib/indexa", File.dirname(__FILE__))

scope do
  setup do
    document = %w(this is some document that I've indexed)
    indexer = Indexa.new
    indexer.redis.call('flushdb')
    [indexer, document]
  end

  test "index a document and get it's id" do |indexer, document|
    document_id = indexer.add(5, document)
    assert_equal document_id, 1
  end

  test "index two documents" do |indexer, document|
    first = indexer.add(3, document)
    second = indexer.add(7, %w(uno dos tres cuatro cinco seis))
    assert_equal first, 1
    assert_equal second, 2
  end

  

end