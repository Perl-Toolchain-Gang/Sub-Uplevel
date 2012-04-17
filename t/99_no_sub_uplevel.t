use Test::More;
use Sub::Uplevel;
BEGIN {
	eval 'use Time::HiRes qw(time); 1'
		or plan skip_all => 'Need Time::HiRes.';
}
	
plan tests => 1;

my @times1 = (time);
for (0..10_000) {
	my $x = $_ + (caller)[2];
}
push @times1, time;

no Sub::Uplevel;

my @times2 = (time);
for (0..10_000) {
	my $x = $_ + (caller)[2];
}
push @times2, time;

diag "Timing results...";
diag sprintf q(Sub::Uplevel's caller: %0.6f sec), $times1[1]-$times1[0];
diag sprintf q(Built-in caller: %0.6f sec), $times2[1]-$times2[0];

ok(!eval { uplevel 0, sub {}; 1 }, 'uplevel dies now');
