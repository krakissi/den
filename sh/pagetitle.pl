#!/usr/bin/perl
use strict;

my $database = "den.db";
my $title = "Social Network";

my %queryvals;
my $buffer = $ENV{'QUERY_STRING'};
if(length($buffer)>0){
	my @pairs=split(/[;&]/, $buffer);
	foreach my $pair (@pairs){
		my ($name, $value) = split(/=/, $pair);
		$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		$queryvals{$name} = $value; 
		chomp($queryvals{$name});
	}
}

my $id_profile = $queryvals{'id'};
chomp(my $homepath = qx/mod_home den/);
chdir($homepath) or die "Can't get home.";

if(length($id_profile)>0){
	my $sql = qq/SELECT name,display FROM profiles WHERE id_profile='$id_profile'/;

	chomp(my $resp = qx/sqlite3 "$database" "$sql"/);
	if(length($resp)>0){
		my($name, $display) = split('\|', $resp, 2);

		if(length($display)>0){ $title = "$display\'s profile" }
		elsif(length($name)>0){ $title = "$name\'s profile" }
	}
}

printf "$title";
exit 0
