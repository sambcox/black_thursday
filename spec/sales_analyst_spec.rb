# frozen_string_literal: true

require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'
require 'spec_helper_2'

RSpec.describe SalesAnalyst do
  let(:sales_analyst) { engine.analyst }

  it '#exists' do
    expect(sales_analyst).to be_an_instance_of(SalesAnalyst)
  end

  it 'can return the average num of items per merchant' do
    expect(sales_analyst.average_items_per_merchant).to eq(2.88)
  end

  it 'can return the average num of items per merchant standard deviation' do
    expect(sales_analyst.average_items_per_merchant_standard_deviation).to eq(3.26)
  end

  it 'can return merchants with a high item count' do
    merchants_with_high_item_count_id = sales_analyst.merchants_with_high_item_count.map(&:id)
    expect(merchants_with_high_item_count_id.include?(12_334_195)).to eq(true)
    expect(merchants_with_high_item_count_id.include?(12_334_105)).to eq(false)
  end

  it 'can return the average item price for a specific merchant' do
    expect(sales_analyst.average_item_price_for_merchant(12_334_159)).to eq 31.50
  end

  it 'can return the average number of invoices per merchant' do
    expect(sales_analyst.average_invoices_per_merchant).to eq(10.49)
  end

  it 'can return a hash of merchant ids with number of invoices per merchant' do
    expect(sales_analyst.grouped_by_merchant_id(sales_analyst.invoices)).to be_a Hash
  end

  it 'can return the average number of invoices per merchant standard deviation' do
    expect(sales_analyst.average_invoices_per_merchant_standard_deviation).to eq(3.29)
  end

  it 'can return golden items' do
    expect(sales_analyst.golden_items.count).to eq(5)
    expect(sales_analyst.golden_items).to be_a(Array)
    expect(sales_analyst.golden_items[0]).to be_a(Item)
  end

  it 'can return the average average price per merchant' do
    expect(sales_analyst.average_average_price_per_merchant).to eq 350.29
    expect(sales_analyst.average_average_price_per_merchant.class).to eq BigDecimal
  end

  it 'can return the percentage of invoices for a given status' do
    expect(sales_analyst.invoice_status(:pending)).to eq 29.55
    expect(sales_analyst.invoice_status(:shipped)).to eq 56.95
    expect(sales_analyst.invoice_status(:returned)).to eq 13.5
  end

  it 'can return the days of the week with the most sales' do
    expect(sales_analyst.top_days_by_invoice_count).to eq(['Wednesday'])
  end

  it 'can return top merchants by invoice count' do
    expect(sales_analyst.top_merchants_by_invoice_count.first).to be_a(Merchant)
    expect(sales_analyst.top_merchants_by_invoice_count.length).to eq(12)
  end

  it 'can return bottom merchants by invoice count' do
    expect(sales_analyst.bottom_merchants_by_invoice_count.first).to be_a(Merchant)
    expect(sales_analyst.bottom_merchants_by_invoice_count.length).to eq(4)
  end

  it 'can return if an invoice is paid in full based on an invoice id' do
    expect(sales_analyst.invoice_paid_in_full?(3374)).to eq true
    expect(sales_analyst.invoice_paid_in_full?(1202)).to eq false
  end

  it 'can return the total dollar amount paid for a specific invoice' do
    expect(sales_analyst.invoice_total(1)).to eq 21_067.77
  end

  it 'can return top x performing merchants in terms of revenue' do
    expected = sales_analyst.top_revenue_earners
    expected_10 = sales_analyst.top_revenue_earners(10)
    expect(expected).to be_a Array
    expect(expected_10).to be_a Array
    expect(expected_10.length).to eq(10)
    expect(expected.length).to eq(20)
  end

  it 'can return total revenue by date' do
    date = Time.parse('2009-02-07')
    expect(sales_analyst.total_revenue_by_date(date)).to eq 21_067.77
  end

  it 'can return total revenue for a single merchant' do
    expect(sales_analyst.revenue_by_merchant(12_335_938)).to be_a(BigDecimal)
    expect(sales_analyst.revenue_by_merchant(12_335_938).to_f).to eq 126_300.9
  end

  it 'can return the merchants that offer only one item' do
    expect(sales_analyst.merchants_with_only_one_item).to be_a Array
    expect(sales_analyst.merchants_with_only_one_item.length).to eq 243
    expect(sales_analyst.merchants_with_only_one_item.first).to be_a Merchant
  end

  it 'can return the merchants that only offer one item by the month they registered' do
    expect(sales_analyst.merchants_with_only_one_item_registered_in_month('May')).to be_a Array
    expect(sales_analyst.merchants_with_only_one_item_registered_in_month('March').length).to eq 21
    expect(sales_analyst.merchants_with_only_one_item_registered_in_month('May').first).to be_a Merchant
  end

  it 'can return the most sold items for a specific merchant' do
    expected = sales_analyst.most_sold_item_for_merchant(12_334_105)

    expect(expected[0].id).to eq 263_541_512
    expect(expected).to be_a Array
    expect(expected[0]).to be_a Item
  end

  it 'can return which merchants have pending invoices in an array' do
    expect(sales_analyst.merchants_with_pending_invoices.count).to eq(467)
    expect(sales_analyst.merchants_with_pending_invoices).to be_a(Array)
    expect(sales_analyst.merchants_with_pending_invoices.first).to be_a(Merchant)
  end

  it 'can return the most lucrative items for a specific merchant' do
    expected = sales_analyst.best_item_for_merchant(12_334_113)
    expect(expected.id).to eq 263_422_571
    expect(expected).to be_a Item
  end

  it 'can return the customers that have bought only one item' do
    expected = sales_analyst.one_time_buyers
    expect(expected).to be_a Array
    expect(expected.first).to be_a Customer
    expect(expected.length).to eq 76
  end

  it 'can return the item that one time buyers have bought most' do
    expected = sales_analyst.one_time_buyers_top_item
    expect(expected.id).to eq 263505548
    expect(expected).to be_a Item
  end

  it 'can return the customer that spent the most money' do
    expected = sales_analyst.top_buyers
    expected_10 = sales_analyst.top_buyers(10)
    expect(expected).to be_a Array
    expect(expected_10).to be_a Array
    expect(expected.length).to eq (20)
    expect(expected_10.length).to eq (10)
  end

  it 'can return an array of customers with unpaid invoices' do
    expected = sales_analyst.customers_with_unpaid_invoices
    expect(expected.count).to eq(786)
    expect(expected).to be_a(Array)
    expect(expected.first).to be_a(Customer)
  end
end
