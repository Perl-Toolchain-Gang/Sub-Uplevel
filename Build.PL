use strict;
use lib 'inc';
eval "require Pod::WikiDoc";
my $class = $@ ? "Module::Build" : "Module::Build::WikiDoc";
eval "require $class";

$class->new( 
    module_name         => 'Sub::Uplevel',
    dist_author         => 'David A. Golden <dagolden@cpan.org>',
    license             => 'perl',
    create_readme       => 1,
    create_makefile_pl  => 'traditional',
    requires        => {
        'Exporter' => 0,
    },
    build_requires => {
        'Carp' => 0, 
        'Test::More' => 0.47, 
    },
    meta_add            => { 
        no_index => { 
            directory => [ qw{
                examples
                inc
            }],
        } 
    },
)->create_build_script;

