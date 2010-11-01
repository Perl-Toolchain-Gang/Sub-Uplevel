use strict;
use Sub::Uplevel;
use lib qw(t/lib);
use Test::More;

plan tests => 3;


sub get_caller {
    return caller(shift);
}

sub wrapper {
    my $height = shift;
    return uplevel 1, \&get_caller, $height;
}

{
  my @caller = wrapper(0);
  ok(scalar @caller, "caller(N) in stack returns list");
}

{
  my @caller = wrapper(1);
  is(scalar @caller, 0, "caller(N) out of stack returns empty list");
}

{
  my @caller = caller;
  is(scalar @caller, 0, "caller from main returns empty list");
}
