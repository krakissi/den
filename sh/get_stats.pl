#!/usr/bin/perl
use strict;

my %count;

my $sql;
my $resp;
my $database="den.db";
chomp(my $homepath = qx/mod_home den/);
chdir($homepath) or die "Can't get home.";

# total messages
$sql = qq{
	SELECT COUNT(*) FROM messages;
};
$count{"messages"} = qx/sqlite3 "$database" "$sql"/;

# total threads
$sql = qq{
	SELECT COUNT(*) FROM threads;
};
$count{"threads"} = qx/sqlite3 "$database" "$sql"/;

# total profiles
$sql = qq{
	SELECT COUNT(*) FROM profiles;
};
$count{"profiles"} = qx/sqlite3 "$database" "$sql"/;

# total lines of code
chomp(my $lines = qx/git ls-files | xargs wc -l | tail -n1/);
$lines =~s/^[^0-9]*([0-9]*)[^0-9].*$/\1/;
$count{'lines'} = $lines;
chomp($lines = qx{cd ../..; git ls-files | xargs wc -l | tail -n1});
$lines =~s/^[^0-9]*([0-9]*)[^0-9].*$/\1/;
$count{'lines'} += $lines;

# Print Results
printf qq{
	<table>
		<thead><th>Category</th><th>Total</th></thead>
		<tr><td>Messages</td><td>$count{'messages'}</td></tr>
		<tr><td>Threads</td><td>$count{'threads'}</td></tr>
		<tr><td>Profiles</td><td>$count{'profiles'}</td></tr>
		<tr><td>Lines of Code</td><td>$count{'lines'}</td></tr>
	</table>
};
exit 0
