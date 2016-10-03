class jmeter::params {
  case $::osfamily {
    'Debian' : {
      $init_template = 'jmeter/jmeter-init.erb'
      if $::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '16.04' {
        $java_version = '8'
      }
      else {
        $java_version = '7'
      }
      $jdk_pkg       = "openjdk-${java_version}-jre-headless"
    }
    'RedHat' : {
      $init_template = 'jmeter/jmeter-init.redhat.erb'
      $java_version  = '7'
      $jdk_pkg       = "java-1.${java_version}.0-openjdk"
    }
  }
}