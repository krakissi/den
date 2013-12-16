#!/usr/bin/perl
use strict;

chomp(my $id=qx/mod_find den:id_profile/);
my $path = "db/p/$id";
my $out = "";

if(-e $path){
	$out = qx/cat "$path"/;
	if($ARGV[0] eq "raw"){ $out =~s/\<[pP]\>(.*)\<\/[pP]\>/\1\n/g }
}
elsif($ARGV[0] ne "raw") { $out = "<p><i>This user has not yet written their profile.</i></p>" }

printf "$out";
