# == Class: jmeter
#
# This class installs the latest stable version of JMeter.
#
# === Examples
#
#   class { 'jmeter': }
#
class jmeter (
  $jmeter_version         = '2.13',
  $jmeter_plugins_install = false,
  $jmeter_plugins_version = '1.2.1',
  $jmeter_plugins_set     = ['Standard'],
  $download_url           = 'http://archive.apache.org/dist/jmeter/binaries/',
  $plugin_url             = 'http://jmeter-plugins.org/downloads/file/',
  $java_version           = $::jmeter::params::java_version,
  $manage_java            = $::jmeter::params::manage_java,
  $jdk_pkg                = $::jmeter::params::jdk_pkg
) inherits ::jmeter::params {

  validate_re($download_url, '^((https?|ftps?):\/\/)([\da-z\.-]+)\.?([\da-z\.]{2,6})([\/\w \.\:-]*)*\/?$')
  validate_re($plugin_url, '^((https?|ftps?):\/\/)([\da-z\.-]+)\.?([\da-z\.]{2,6})([\/\w \.\:-]*)*\/?$')
  validate_bool($manage_java)

  Exec { path => '/bin:/usr/bin:/usr/sbin' }

  if $manage_java {
  if ! defined(Package[$jdk_pkg]) {
    package { $jdk_pkg:
      ensure => installed,
    }
  }
  }

  if ! defined(Package['unzip']) {
    package { 'unzip':
      ensure => installed,
    }
  }
  if ! defined(Package['wget']) {
    package { 'wget':
      ensure => installed,
    }
  }

  exec { 'download-jmeter':
    command => "wget -P /root ${download_url}/apache-jmeter-${jmeter_version}.tgz",
    creates => "/root/apache-jmeter-${jmeter_version}.tgz"
  }

  exec { 'install-jmeter':
    command => "tar xzf /root/apache-jmeter-${jmeter_version}.tgz && mv apache-jmeter-${jmeter_version} jmeter",
    cwd     => '/usr/share',
    creates => '/usr/share/jmeter',
    require => Exec['download-jmeter'],
  }

  if $jmeter_plugins_install == true {
    jmeter::plugins_install { $jmeter_plugins_set:
      plugins_version   => $jmeter_plugins_version,
      base_download_url => $plugin_url,
      require           => [Package['wget'], Package['unzip'], Exec['install-jmeter']],
    }
  }
}
