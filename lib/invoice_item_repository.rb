require_relative 'invoice_item'
require_relative 'find'
require_relative 'modify'

class InvoiceItemRepository
  include Find
  include Modify
  attr_reader :invoice_items

  def initialize
    @invoice_items = []
  end

  def add(invoice_item)
    @invoice_items << InvoiceItem.new(invoice_item)
  end

  def all
    @invoice_items
  end

  def find_by_id(id)
    find_by_id_overall(@invoice_items, id)
  end
end