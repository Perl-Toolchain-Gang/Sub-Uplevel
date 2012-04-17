#!/usr/bin/perl

use strict;
BEGIN { $^W = 1 }

use Test::More tests => 3;

use Sub::Uplevel;

#line 11
ok( !caller,                         "top-level caller() not screwed up" );

eval { die };
is( $@, "Died at $0 line 13.\n",           'die() not screwed up' );

sub foo {
    join " - ", caller;
}

sub bar {
    uplevel(1, \&foo);
}

#line 25
is( bar(), "main - $0 - 25",    'uplevel()' );
