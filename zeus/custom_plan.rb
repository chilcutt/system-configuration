require 'zeus/parallel_tests'

class CustomPlan < Zeus::ParallelTests::Rails
  def default_bundle_with_test_env
    ::Rails.env = 'test'
    ENV['RAILS_ENV'] = 'test'
    default_bundle
  end

  def parallel_rspec
    ARGV << "-o --seed=#{rand(1..10_000)}" if ARGV.grep(/--seed/).empty?
    super
  end

  def test(argv=ARGV)
    if defined?(RSpec) && argv.grep(/--seed/).empty?
      RSpec.configuration.seed = rand(1..10_000)
    end

    # auto-reload support files
    Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

    # auto-reload FactoryGirl
    require 'factory_girl'
    FactoryGirl.reload

    super(argv)
  end

  def test_console
    console
  end
end

Zeus.plan = CustomPlan.new
