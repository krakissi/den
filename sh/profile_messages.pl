#!/usr/bin/perl
use strict;

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
if($id_profile eq ""){ printf "No profile found."; exit 0 }

my $database="den.db";
chomp(my $homepath = qx/mod_home den/);
chdir($homepath) or die "Can't get home.";

my $sql = qq{
	SELECT id_thread FROM profilethread WHERE id_profile='$id_profile' AND ship='0';
};
my $threads = qx/sqlite3 "$database" "$sql"/;

printf "Threads: $threads";
if($threads eq ""){ printf "No conversations yet."; exit 0 }

# Set of threads.
foreach my $thread(split(/\n/, $threads)){
	chomp($thread);
	$sql = qq{
        SELECT profiles.id_profile, profiles.name, profiles.display, messages.posted, messages.content
        FROM messages LEFT JOIN threads ON messages.id_thread = threads.id_thread
        LEFT JOIN profiles ON messages.id_profile = profiles.id_profile
        WHERE messages.id_thread='$thread' AND threads.vis='1'
        ORDER BY messages.posted DESC;
	};

	my $resp = qx/sqlite3 "$database" "$sql"/;

	# Print message set.
	printf "<div class=profile_thread>";
	foreach my $msg(split(/\n/, $resp)){
		my($profile, $name, $display, $posted, $content) = split('\|', $msg);
		if(length($display)>0){ $name = $display }
		printf qq{
			<div class=profile_message>
				<span class=profile_message_posted>$posted</span>
				<span class=profile_message_profilename>$name</span>
				<span class=profile_message_content>$content</span>
			</div>
		};
	}
	printf "</div>";
}
