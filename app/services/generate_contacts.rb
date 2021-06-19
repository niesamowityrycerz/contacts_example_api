# frozen_string_literal: true

class GenerateContacts
  DEFAULT_DOMAIN_PART = '@example.com'

  def initialize(amount = 10000)
    @amount = amount
  end

  def call
    prefix = SecureRandom.alphanumeric(8)

    results = []
    amount.times do |idx|
      now = Time.now
      results.push(name: "#{prefix}_#{idx}", email: "#{prefix}_#{idx}".downcase + DEFAULT_DOMAIN_PART, created_at: now, updated_at: now)
    end
    results
  end

  private

  attr_reader :amount
end