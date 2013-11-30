#!/usr/bin/perl

use strict;

sub serv {
	my $page=shift;
	my $output=`kraknet "pages/header" "pages/$page" "pages/footer"`;

	printf "$output";

	exit 0
}

my $homepath=`mod_home den`;
chomp($homepath);
chdir($homepath) or die "Can't get home.";

serv("index.html");

exit 0
