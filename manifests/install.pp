# @!visibility private
class lldpd::install {

  # OpenBSD has a separate package flavo(u)r with SNMP support
  $flavor = $::osfamily ? {
    'OpenBSD' => ($::lldpd::enable_snmp or $::lldpd::snmp_socket) ? {
      true    => 'snmp',
      default => undef,
    },
    default   => undef,
  }

  package { $::lldpd::package_name:
    ensure => present,
    flavor => $flavor,
  }
}
