# == Class: osquery
#
# OSQuery installation and setup
#
# === Parameters
#
# [*package_name*]
#   OS package name to be installed. Default is auto detect.
#
# [*package_ver*]
#   Package to ensure exists, can be latest or present. Default is latest.
#
# [*service_name*]
#   Package service name to be ran. Default is auto detect.
#
# [*settings_name*]
#   Hash of the OSquery settings to be converted automatically into a JSON string for the config file.
#
# === Variables
#
# See osquery::params for defaults
#
# === Examples
#
#  class { 'osquery':
#    settings => {
#      'options' => {
#        'debug' => false,
#        'worker_threads' => $::processorcount,
#      },
#      'schedule' => {
#        'info' => {
#          'query' => 'SELECT * FROM osquery_info',
#          'interval' => '3600',
#        },
#      },
#      'packs' => {
#        'incident-response' => '/usr/share/osquery/packs/incident-response.conf',
#        'it-compliance' => '/usr/share/osquery/packs/it-compliance.conf',
#      },
#    }
#  }
#
# === Authors
#
# Bryan Andrews <bryanandrews@gmail.com>
#
# === Copyright
#
# Copyright 2015 Bryan Andrews, unless otherwise noted.
#
class osquery (
  $repo_install    = $::osquery::params::repo_install,
  $repo_url        = $::osquery::params::repo_url,
  $repo_key_id     = $::osquery::params::repo_key_id,
  $repo_key_server = $::osquery::params::repo_key_server,
  $package_name    = $::osquery::params::package_name,
  $service_name    = $::osquery::params::service_name,
  $package_ver     = $::osquery::params::package_ver,
  $settings        = $::osquery::params::settings,
) inherits ::osquery::params {

  validate_string($package_name)
  validate_string($service_name)
  validate_re($package_ver, [ 'latest', 'present' ])
  validate_hash($settings)

  anchor { '::osquery::begin': }
  class { '::osquery::install': } ->
  class { '::osquery::config': } ~>
  class { '::osquery::service': } ->
  anchor { '::osquery::end': }

}
