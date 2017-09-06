require 'spec_helper_acceptance'

describe 'lldpd' do

  it 'should work with no errors' do

    pp = <<-EOS
      Package {
        source => $::osfamily ? {
          # $::architecture fact has gone missing on facter 3.x package currently installed
          'OpenBSD' => "http://ftp.openbsd.org/pub/OpenBSD/${::operatingsystemrelease}/packages/amd64/",
          default   => undef,
        },
      }

      class { '::lldpd':
        class       => 1,
        enable_snmp => true,
      }

      if $::osfamily == 'RedHat' {
        include ::epel

        Class['::epel'] -> Class['::lldpd']
      }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  describe package('lldpd') do
    it { should be_installed }
  end

  describe file('/etc/sysconfig/lldpd'), :if => fact('osfamily').eql?('RedHat') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /^ LLDPD_OPTIONS="-M \s 1 \s -x" $/x }
  end

  describe file('/etc/default/lldpd'), :if => fact('osfamily').eql?('Debian') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /^ DAEMON_ARGS="-M \s 1 \s -x" $/x }
  end

  describe file('/etc/rc.conf.local'), :if => fact('osfamily').eql?('OpenBSD') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'wheel' }
    its(:content) { should match /^ lldpd_flags=-M \s 1 \s -x $/x }
  end

  describe service('lldpd') do
    it { should be_enabled }
    it { should be_running }
  end

  # Debian 7.x has ancient version
  describe command('lldpcli show configuration'), :unless => (fact('osfamily').eql?('Debian') and fact('operatingsystemmajrelease').eql?('7')) do
    its(:stdout) { should match /^ \s{2} Override \s platform \s with: \s (?: #{fact('kernel')} | \(none\) ) $/x }
    its(:stdout) { should match /^ \s{2} Disable \s LLDP-MED \s inventory: \s no $/x }
    its(:exit_status) { should eq 0 }
  end

  # FIXME Actually test SNMP integration
end
