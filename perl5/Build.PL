use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'USB::Descriptor::Device',
    license             => 'bsd',
    dist_author         => q{Brandon Fosdick <bfoz@bfoz.net>},
    dist_version_from   => 'lib/USB/Descriptor.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => 5.010,
    },
    add_to_cleanup      => [ 'USB-Descriptor-Device-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
