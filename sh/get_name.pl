#!/usr/bin/perl

my $id_profile;

if($ARGV[0] ne "--safe"){ $id_profile = $ARGV[0] }
if($id_profile eq ""){
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

	$id_profile=$queryvals{'id'};
	if($id_profile eq ""){ exit 0 }
}

my $database="den.db";
chomp(my $homepath = qx/mod_home den/);
chdir($homepath) or die "Can't get home.";

my $sql = qq/SELECT name, display FROM profiles WHERE id_profile='$id_profile'/;
chomp(my $resp = qx/sqlite3 "$database" "$sql"/);

my ($name, $display) = split('\|', $resp, 2);
if(length($display)>0){ $name = $display }
$name = qx/decode "$name"/;

if($ARGV[0] eq "--safe"){ $name =~s/"/&quot;/g }

printf "$name";

exit 0
