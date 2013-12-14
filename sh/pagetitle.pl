#!/usr/bin/perl
use strict;

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


exit 0
