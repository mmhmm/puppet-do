# == Class: base
#
# Stuff I always want
#
class base {

  include apt
  include ufw

  class { 'timezone':
            timezone => 'Europe/London',
  }

  group { 'admin':
    ensure => present,
    system => true,
  }

  users { 'admins':
    require =>  [ Group['admin'],
                  Package['zsh']
    ]
  }

  apt::ppa { 'ppa:martin-frost/thoughtbot-rcm': }

  package { 'rcm':
    ensure  => installed,
    require => Apt::Ppa['ppa:martin-frost/thoughtbot-rcm'],
  }

  apt::source { 'puppetlabs':
    location => 'http://apt.puppetlabs.com',
    repos    => 'main dependencies',
    key      => {
      'id'     => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
      'server' => 'pgp.mit.edu',
    },
  }

  package { [
            'zsh',
            'git',
            'autojump',
            'htop',
            'whois',
            'bikeshed',
            ]:
    ensure => installed,
  }

  package { 'puppet-common':
    ensure  => '3.6.2-1puppetlabs1',
    require => Apt::Source['puppetlabs'],
  }
  package { 'puppet':
    ensure  => '3.6.2-1puppetlabs1',
    require => Package['puppet-common'],
  }
  package { 'facter':
    ensure  => '2.3.0-1puppetlabs1',
    require => Apt::Source['puppetlabs'],
  }
  package { 'hiera':
    ensure  => '1.3.4-1puppetlabs1',
    require => Apt::Source['puppetlabs'],
  }

  exec { 'hold_puppet_pkgs':
    command => 'apt-mark hold puppet-common puppet facter hiera',
    require => Package[ 'puppet-common',
                        'puppet',
                        'facter',
                        'hiera'
    ],
  }

  ufw::allow { 'ssh-from-all':
    port => 22,
  }

}
