require 'spec_helper'

describe 'qt' do
  it do
    should include_class('xquartz')

    should contain_package('qt').with_ensure('latest')
  end
end
