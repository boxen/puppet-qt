require 'spec_helper'

describe 'qt' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
      :boxen_user => 'testuser',
      :macosx_productversion_major => "10.8",
      :osfamily                    => "Darwin"
    }
  end

  it do
    should include_class('homebrew')
    should include_class('xquartz')

    should contain_homebrew__formula('qt')
    should contain_package('boxen/brews/qt').with_ensure('4.8.5-boxen2')
  end
end
