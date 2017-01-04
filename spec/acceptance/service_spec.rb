require 'spec_helper_acceptance'
require 'specinfra'

shared_examples 'running' do
  describe service('jmeter') do
    if !(fact('operatingsystem') == 'SLES' && fact('operatingsystemmajrelease') == '12')
      it { should be_running }
      if (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8')
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { should be_enabled }
      end
    else
      # hack until we either update SpecInfra or come up with alternative
      it {
        output = shell('service jmeter status')
        expect(output.stdout).to match(/Active\:\s+active\s+\(running\)/)
        expect(output.stdout).to match(/^\s+Loaded.*enabled\)$/)
      }
    end
  end
end

describe 'jmeter::server class', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  describe 'basic test' do
    it 'sets up the service' do
      apply_manifest(%{
        class { 'jmeter::server': }
      }, :catch_failures => true)
    end

    it_should_behave_like 'running'
  end
end