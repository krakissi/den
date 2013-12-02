#!/usr/bin/perl
# Serve Den pages
# Mike Perron (2013)

use strict;

my $name=$0;
$name=~s/^.*\/([^\/]*)$/\1/;

sub serv {
	my $page=shift;
	my $output=`kraknet pages/header pages/$page pages/footer 2>&1`;
	printf "$output";
	exit 0
}

chomp(my $homepath=`mod_home den`);
chdir($homepath) or die "Can't get home.";

chomp(my $auth=qx/mod_find accounts:auth/);
if($auth=~s/^OK (.*)$/\1/){ serv($name) }
else { serv("register.html") }

exit 0
