# @!visibility private
class lldpd::config {

  $addresses   = $::lldpd::addresses
  $chassis_id  = $::lldpd::chassis_id
  $class       = $::lldpd::class
  $interfaces  = $::lldpd::interfaces
  $snmp_socket = $::lldpd::snmp_socket

  file { '/etc/lldpd.d':
    ensure  => directory,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    purge   => true,
    recurse => true,
  }

  $flags = join(delete_undef_values([
    $addresses ? {
      undef   => undef,
      default => "-m ${join($addresses, ',')}",
    },
    $chassis_id ? {
      undef   => undef,
      default => "-C ${join($chassis_id, ',')}",
    },
    $class ? {
      undef   => undef,
      default => "-M ${class}",
    },
    [$::lldpd::enable_cdpv1, $::lldpd::enable_cdpv2] ? {
      [false, false]   => undef,
      [true, true]     => '-c',
      ['force', true]  => '-cc',
      [true, 'force']  => '-ccc',
      [false, true]    => '-cccc',
      [false, 'force'] => '-ccccc',
      default          => fail('Invalid combination of CDP parameters'),
    },
    $::lldpd::enable_edp ? {
      true    => '-e',
      'force' => '-ee',
      default => undef,
    },
    $::lldpd::enable_fdp ? {
      true    => '-f',
      'force' => '-ff',
      default => undef,
    },
    $::lldpd::enable_lldp ? {
      'force' => '-l',
      false   => '-ll',
      default => undef,
    },
    $::lldpd::enable_sonmp ? {
      true    => '-s',
      'force' => '-ss',
      default => undef,
    },
    $::lldpd::enable_snmp ? {
      true    => '-x',
      default => undef,
    },
    $interfaces ? {
      undef   => undef,
      default => "-I ${join($interfaces, ',')}",
    },
    $snmp_socket ? {
      undef   => undef,
      default => type($snmp_socket) ? {
        Type[Tuple] => "-X tcp:${snmp_socket[0]}:${snmp_socket[1]}",
        default     => "-X ${snmp_socket}",
      },
    },
  ]), ' ')

  case $::osfamily {
    'RedHat': {
      file { '/etc/sysconfig/lldpd':
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0644',
        content => template("${module_name}/sysconfig.erb"),
      }
    }
    'Debian': {
      file { '/etc/default/lldpd':
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0644',
        content => template("${module_name}/default.erb"),
      }
    }
    default: {
      # noop
    }
  }
}
