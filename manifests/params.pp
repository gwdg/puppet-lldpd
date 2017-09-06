# @!visibility private
class lldpd::params {

  $package_name = 'lldpd'
  $service_name = 'lldpd'

  case $::osfamily {
    'RedHat': {
    }
    'OpenBSD': {
    }
    'Debian': {
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
