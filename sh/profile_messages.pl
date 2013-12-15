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
	SELECT id_thread
	FROM profilethread
	WHERE id_profile='$id_profile' AND ship='0'
	ORDER BY joined DESC
	LIMIT 20;
};
my $threads = qx/sqlite3 "$database" "$sql"/;
if($threads eq ""){ printf "No conversations yet."; exit 0 }

my $profile_controls = "<select class=profile_postcontrols_selectprofile name=from_id_profile>".qx/mod_find den:profile_optionlist/."</select>";

# Set of threads.
foreach my $thread(split(/\n/, $threads)){
	chomp($thread);
	$sql = qq{
        SELECT profiles.id_profile, profiles.name, profiles.display, messages.posted, messages.content
        FROM messages LEFT JOIN threads ON messages.id_thread = threads.id_thread
        LEFT JOIN profiles ON messages.id_profile = profiles.id_profile
        WHERE messages.id_thread='$thread' AND threads.vis='1'
        ORDER BY messages.posted ASC;
	};

	my $resp = qx/sqlite3 "$database" "$sql"/;

	# Print message set.
	printf "<div class=profile_thread>";
	foreach my $msg(split(/\n/, $resp)){
		my($profile, $name, $display, $posted, $content) = split('\|', $msg);
		$content = qx/decode "$content"/;

		if(length($display)>0){ $name = $display }
		printf qq{
			<div class=profile_message>
				<span class=profile_message_posted>$posted</span>
				<span class=profile_message_profilename>$name</span>
				<p class=profile_message_content>$content</p>
			</div>
		};
	}
	printf qq{
			<div class=profile_thread_reply>
				<form method=post action=bin/post_message>
					<input type=hidden name=thread value="$thread">
					<textarea name=message class=message></textarea>
					<div class=profile_thread_reply_controls>
						$profile_controls
						<input type=submit value=Reply>
					</div>
				</form>
			</div>
		</div>
	};
}
