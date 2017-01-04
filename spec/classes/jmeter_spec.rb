require 'spec_helper'

describe 'jmeter' do

  before(:all) do
    @jmeter_version = '2.13'
  end

  context "On an Ubuntu OS with no additional params specified" do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '16.04'
      }
    end

    it {
      should contain_exec('download-jmeter').with(
          { 'creates' => "/root/apache-jmeter-#{@jmeter_version}.tgz"} 
        )
    }

    it {
      should contain_exec('install-jmeter').with( 
          { 'command' => "tar xzf /root/apache-jmeter-#{@jmeter_version}.tgz && mv apache-jmeter-#{@jmeter_version} jmeter"} 
        )
    }

    it {
      should contain_package('openjdk-8-jre-headless')
    }
  end
end