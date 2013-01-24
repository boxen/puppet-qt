require 'spec_helper'

describe 'qt' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
      :boxen_user => 'testuser',
    }
  end

  it do
    should include_class('homebrew')
    should include_class('xquartz')

    should contain_homebrew__formula('qt')
    should contain_package('boxen/brews/qt').with_ensure('4.8.4-boxen1')
  end
end
