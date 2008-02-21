#!/usr/bin/perl -Tw

use lib qw(t/lib);
use strict;
use Test::More tests => 7;

# Goal of these tests: confirm that Sub::Uplevel will honor (use) a
# CORE::GLOBAL::caller override that occurs prior to Sub::Uplevel loading

#--------------------------------------------------------------------------#
# define a custom caller function that reverses the package name
#--------------------------------------------------------------------------#

sub _reverse_caller(;$) { 
    my $height = $_[0];
    my @caller = CORE::caller(++$height);
    $caller[0] = defined $caller[0] ? reverse $caller[0] : undef;
    if( wantarray and !@_ ) {
        return @caller[0..2];
    }
    elsif (wantarray) {
        return @caller;
    }
    else {
        return $caller[0];
    }
}

#--------------------------------------------------------------------------#
# redefine CORE::GLOBAL::caller then load Sub::Uplevel 
#--------------------------------------------------------------------------#

BEGIN {
    ok( ! defined *CORE::GLOBAL::caller{CODE}, 
        "no global override yet" 
    );

    {
        # old style no warnings 'redefine'
        my $old_W = $^W;
        $^W = 0;
        *CORE::GLOBAL::caller = \&_reverse_caller;
        $^W = $old_W;
    }

    is( *CORE::GLOBAL::caller{CODE}, \&_reverse_caller,
        "added custom caller override"
    );

    use_ok('Sub::Uplevel');

    is( *CORE::GLOBAL::caller{CODE}, \&_reverse_caller,
        "custom caller override still in place"
    );


}

#--------------------------------------------------------------------------#
# define subs *after* caller has been redefined in BEGIN
#--------------------------------------------------------------------------#

sub test_caller { return scalar caller }

sub uplevel_caller { return uplevel 1, \&test_caller }

sub test_caller_w_uplevel { return uplevel_caller }

#--------------------------------------------------------------------------#
# Test for reversed package name both inside and outside an uplevel call
#--------------------------------------------------------------------------#

is( scalar caller(), undef,
    "caller from main package is undef"
);

is( test_caller(), reverse("main"),
    "caller from subroutine calls custom routine"
);

is( test_caller_w_uplevel(), reverse("main"),
    "caller from uplevel subroutine calls custom routine"
);

