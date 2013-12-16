#!/usr/bin/perl
use strict;

my %queryvals;
my $buffer = $ENV{'QUERY_STRING'};
if(length($buffer)>0){
	my @pairs=split(/[;&]/, $buffer);
	foreach my $pair (@pairs){
		my ($name, $value) = split(/=/, $pair);
		$value =~ s/\+/ /g;
		$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		$queryvals{$name} = $value; 
		chomp($queryvals{$name});
	}
}

my $query = $queryvals{'q'};
if(length($query)<2){
	exit 0
}

my $database = "den.db";
chomp(my $homepath = qx/mod_home den/);
chdir($homepath) or die "Can't get home.";

my $terms=0;
my $sql = qq{SELECT id_profile, name, display FROM profiles WHERE \n};

foreach my $term (split(' ', $query)){
	$term =~s/\W/%/g;

	$sql.=(($terms==0)?"":" OR ")."name LIKE '%$term%' OR display LIKE '%$term%'\n";
	$terms++;
}
$sql.=';';

my $result_no = 1;
foreach my $result (split('\n', qx/sqlite3 "$database" "$sql"/)){
	my($id_profile, $name, $display) = split('\|', $result, 3);

	if(length($display)>0){ $name=$display }
	$name = qx/decode "$name"/;

	printf qq{
		<div class=searchresult>
			<a href="/den/profile.html?id=$id_profile">
				<img src="bin/userimage?$id_profile&search" title="$name" border=0>
			</a>
			<br>
			$result_no: 
			<a href="/den/profile.html?id=$id_profile">
				<span class=searchresult_name>$name</span>
			</a>
		</div>
	};
	$result_no++;
}

exit 0
