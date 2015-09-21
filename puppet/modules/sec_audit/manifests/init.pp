class sec_audit ($srcfile) {

$script_dir="/home/homer/Cave/scripts/"
$report_script="/home/homer/Cave/scripts/gen_sec_report.rb"
$audit_script="/home/homer/Cave/scripts/sec_audit.sh"
$report_dir="/home/homer/Cave/scripts/sieve"

	$sec_audit_files = ["${script_dir}${srcfile}", $audit_script, $report_script]

	file { $sec_audit_files:
		ensure => present,
	}

	file { $report_dir:
		ensure => directory,
		mode => 0700,
	}

	cron {'hourly_sec_audit':
		ensure => present,
		command => $audit_script,
		minute => '00',
		user => 'homer',
		require => File[$sec_audit_files],
	}

}
