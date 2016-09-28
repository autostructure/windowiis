require 'spec_helper'
describe 'windows_webserver' do

  context 'with default values for all parameters' do
    it { should contain_class('windows_webserver') }
  end
end
