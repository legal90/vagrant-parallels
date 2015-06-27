require_relative '../base'

require 'vagrant/util/platform'

describe VagrantPlugins::Parallels::Action::Customize do
  include_context "vagrant-unit"
  include_context 'parallels'

  let(:iso_env) do
    # We have to create a Vagrantfile so there is a root path
    env = isolated_environment
    env.vagrantfile('')
    env.create_vagrant_env
  end

  let(:machine) do
    iso_env.machine(iso_env.machine_names[0], :parallels).tap do |m|
      m.provider.stub(driver: driver)
    end
  end

  let(:env)    {{ machine: machine, ui: machine.ui }}
  let(:app)    { lambda { |*args| }}
  let(:driver) { double('driver') }
  let(:event)  { "pre-boot" }

  subject { described_class.new(app, env, event) }

  before do
    env[:test] = true
  end

  it 'calls the next action in the chain' do
    called = false
    app = lambda { |*args| called = true }

    action = described_class.new(app, env, event)
    action.call(env)

    expect(called).to eq(true)
  end

end