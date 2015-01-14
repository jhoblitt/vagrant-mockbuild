include stdlib
include augeas
include epel

Class['epel'] -> Package<| provider == 'rpm' |>

$owner = 'vagrant'
$group = $owner
$home = "/home/${owner}"

package{ ['mock', 'rpm-build', 'redhat-rpm-config', 'rpmlint']: }

user { $owner:
  groups  => ['mock'],
  require => Package['mock'], # mock group created by mock pkg
}

file { "${home}/.rpmmacros":
  ensure  => file,
  content => "%_topdir ${home}/rpmbuild\n",
}

file { "${home}/.ssh/config":
  ensure  => 'file',
  owner   => $owner,
  group   => $group,
  mode    => '0600',
  replace => true,
  content => 'StrictHostKeyChecking no',
} ->
vcsrepo { "${home}/rpm-lsststack-deps":
  ensure   => present,
  provider => git,
  source   => 'https://github.com/lsst-sqre/rpm-lsststack-deps.git',
}
