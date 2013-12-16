#!/usr/bin/perl
use strict;
use URI::Escape;

my $database="den.db";
chomp(my $id_user = qx/mod_find accounts:id/);

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
if($id_profile eq ""){ exit 0 }

my $sql = qq{
	SELECT id_user FROM profiles
	WHERE id_profile='$id_profile';
};
chomp(my $resp = qx/sqlite3 "$database" "$sql"/);

if($resp eq $id_user){
	printf qq{
		<div id=div_profiletabs>
			<span class=profiletab>
				<a href="/den/edit.html?id=$id_profile">Edit</a>
			</span>
		</div>
	};
}

exit 0
