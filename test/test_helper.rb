ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'database_cleaner/active_record'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    self.use_transactional_tests = true

    # Setup DatabaseCleaner before tests
    setup do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end

    # Clean Database after tests
    teardown do
      DatabaseCleaner.clean
    end

    # Add more helper methods to be used by all tests here...
  end
end
