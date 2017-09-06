require 'spec_helper'

describe 'lldpd' do

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it { expect { should compile }.to raise_error(/not supported on an Unsupported/) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts
      end

      it { should contain_class('lldpd') }
      it { should contain_class('lldpd::config') }
      it { should contain_class('lldpd::install') }
      it { should contain_class('lldpd::params') }
      it { should contain_class('lldpd::service') }
      it { should contain_file('/etc/lldpd.d') }
      it { should contain_package('lldpd') }
      it { should contain_service('lldpd') }

      case facts[:osfamily]
      when 'RedHat'
        it { should_not contain_file('/etc/default/lldpd') }
        it { should contain_file('/etc/sysconfig/lldpd') }
      when 'Debian'
        it { should contain_file('/etc/default/lldpd') }
        it { should_not contain_file('/etc/sysconfig/lldpd') }
      when 'OpenBSD'
        it { should_not contain_file('/etc/default/lldpd') }
        it { should_not contain_file('/etc/sysconfig/lldpd') }
      end

      context "with CDP enabled", :compile do
        let(:params) do
          {
            :enable_cdpv1 => true,
            :enable_cdpv2 => true,
          }
        end

        case facts[:osfamily]
        when 'RedHat'
          it { should contain_file('/etc/sysconfig/lldpd').with_content(<<-EOS.gsub(/^ +/, ''))
            # !!! Managed by Puppet !!!
            LLDPD_OPTIONS="-c"
            EOS
          }
        when 'Debian'
          it { should contain_file('/etc/default/lldpd').with_content(<<-EOS.gsub(/^ +/, ''))
            # !!! Managed by Puppet !!!
            DAEMON_ARGS="-c"
            EOS
          }
        when 'OpenBSD'
          it { should contain_service('lldpd').with_flags('-c') }
        end
      end

      context "with invalid CDP parameters" do
        let(:params) do
          {
            :enable_cdpv1 => true,
            :enable_cdpv2 => false,
          }
        end

        it { expect { should compile }.to raise_error(/Invalid combination of CDP parameters/) }
      end

      context "setting the LLDP-MED class", :compile do
        let(:params) do
          {
            :class => 1,
          }
        end

        case facts[:osfamily]
        when 'RedHat'
          it { should contain_file('/etc/sysconfig/lldpd').with_content(<<-EOS.gsub(/^ +/, ''))
            # !!! Managed by Puppet !!!
            LLDPD_OPTIONS="-M 1"
            EOS
          }
        when 'Debian'
          it { should contain_file('/etc/default/lldpd').with_content(<<-EOS.gsub(/^ +/, ''))
            # !!! Managed by Puppet !!!
            DAEMON_ARGS="-M 1"
            EOS
          }
        when 'OpenBSD'
          it { should contain_service('lldpd').with_flags('-M 1') }
        end
      end
    end
  end
end
