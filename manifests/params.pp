class jmeter::params {
  case $::osfamily {
    'Debian' : {
      $init_template = 'jmeter/jmeter-init.erb'
      $service_provider = debian
      if $::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '16.04' {
        $java_version = '8'
        $service_provider = systemd
      }
      else {
        $java_version = '7'
      }
      $jdk_pkg       = "openjdk-${java_version}-jre-headless"
    }
    'RedHat' : {
      $init_template = 'jmeter/jmeter-init.redhat.erb'
      $service_provider = redhat
      $java_version  = '7'
      $jdk_pkg       = "java-1.${java_version}.0-openjdk"
    }
  }
}