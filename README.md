# lldpd

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-lldpd.svg?branch=master)](https://travis-ci.org/bodgit/puppet-lldpd)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-lldpd/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-lldpd?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/lldpd.svg)](https://forge.puppetlabs.com/bodgit/lldpd)
[![Dependency Status](https://gemnasium.com/bodgit/puppet-lldpd.svg)](https://gemnasium.com/bodgit/puppet-lldpd)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with lldpd](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with lldpd](#beginning-with-lldpd)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module installs and manages `lldpd` which provides LLDP advertisements
to connected network devices.

RHEL/CentOS, Ubuntu, Debian and OpenBSD are supported using Puppet 4.6.0 or
later.

## Setup

### Setup Requirements

On RHEL/CentOS platforms you will need to have access to the EPEL repository by
using [stahnma/epel](https://forge.puppet.com/stahnma/epel) or by other means.

### Beginning with lldpd

In the very simplest case, applying the module will install and start the
`lldpd` agent and enable LLDP advertisements:

```puppet
include ::lldpd
```

## Usage

If you want to also enable the Cisco Discovery Protocol, which comprises two
versions, use the following:

```puppet
class { '::lldpd':
  enable_cdpv1 => true,
  enable_cdpv2 => true,
}
```

Enabling the SNMP AgentX sub-agent can be done with:

```puppet
class { '::lldpd':
  enable_snmp => true,
  snmp_socket => ['127.0.0.1', 705],
}
```

## Reference

The reference documentation is generated with
[puppet-strings](https://github.com/puppetlabs/puppet-strings) and the latest
version of the documentation is hosted at
[https://bodgit.github.io/puppet-lldpd/](https://bodgit.github.io/puppet-lldpd/).

## Limitations

This module has been built on and tested against Puppet 4.6.0 and higher.

The module has been tested on:

* RedHat Enterprise Linux 6/7
* Ubuntu 14.04/16.04
* Debian 7/8
* OpenBSD 6.0/6.1

## Development

The module has both [rspec-puppet](http://rspec-puppet.com) and
[beaker-rspec](https://github.com/puppetlabs/beaker-rspec) tests. Run them
with:

```
$ bundle exec rake test
$ PUPPET_INSTALL_TYPE=agent PUPPET_INSTALL_VERSION=x.y.z bundle exec rake beaker:<nodeset>
```

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-lldpd).
