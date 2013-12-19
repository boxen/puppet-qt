require 'spec_helper'

describe 'qt' do
  let(:default_facts) do
    {
      :boxen_home => '/opt/boxen',
      :boxen_user => 'testuser',
    }
  end

  context "10.8" do
    let(:facts) { default_facts.merge(:macosx_productversion_major => '10.8')}

    it do
      should include_class('homebrew')
      should include_class('xquartz')

      should contain_homebrew__formula('qt')
      should contain_package('boxen/brews/qt').with_ensure('4.8.5-boxen2')
    end
  end

  context "10.9" do
    let(:facts) { default_facts.merge(:macosx_productversion_major => '10.9')}

    it do
      should_not contain_package('boxen/brews/qt').with_ensure('4.8.5-boxen2')
    end
  end
end
