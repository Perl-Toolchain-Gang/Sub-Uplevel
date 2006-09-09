package Test::Utils;

use 5.004;

use strict;
require Exporter;
use vars qw($VERSION @EXPORT @EXPORT_TAGS @ISA);

$VERSION = '0.03';

@ISA = qw(Exporter);
@EXPORT = qw( my_print print diagnostic );
                


# Special print function to guard against $\ and -l munging.
sub my_print (*@) {
    my($fh, @args) = @_;

    local $\;
    print $fh @args;
}

sub diagnostic (*@) {
    my($fh, @args) = @_;

    # Escape each line with a #.
    foreach (@args) {
        s/^([^#])/#$1/;
        s/\n([^#])/\n#$1/g;
    }
    local $\;
    print $fh @args;
}

sub print { die "DON'T USE PRINT!  Use _print instead" }

1;
