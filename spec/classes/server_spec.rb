require 'spec_helper'

describe 'jmeter::server' do

  context "On an Ubuntu OS with no additional params specified" do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '16.04'
      }
    end

    it {
      should contain_service('jmeter').with(
          { 'ensure' => 'running', 'enable' => 'true'} 
        )
    }
  end
end
  