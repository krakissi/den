#!/usr/bin/perl
use strict;

my $database = "den.db";
chomp(my $homepath = qx/mod_home den/);
chdir($homepath) or die "Can't get home.";

chomp(my $id_user = qx/mod_find accounts:id/);
if($id_user eq ""){ printf "<!-- Bad user, no cookie -->"; exit 0 }

my $sql = qq/SELECT id_profile, name, display FROM profiles WHERE id_user='$id_user';/;
my $resp = qx/sqlite3 "$database" "$sql"/;

foreach my $line(split(/\n/, $resp)){
	my($id, $name, $display) = split('\|', $line, 3);
	if(length($display)>0){ $name = $display }

	printf "<option value=\"$id\">$name</option>";
}

exit 0
