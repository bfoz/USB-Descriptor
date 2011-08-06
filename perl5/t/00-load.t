#!perl -T

use Test::More tests => 5;

BEGIN {
    use_ok( 'USB::Descriptor' ) || print "Bail out!\n";
    use_ok( 'USB::Descriptor::Device' ) || print "Bail out!\n";
    use_ok( 'USB::Descriptor::Interface' ) || print "Bail out!\n";
    use_ok( 'USB::Descriptor::Configuration' ) || print "Bail out!\n";
    use_ok( 'USB::Descriptor::Endpoint' ) || print "Bail out!\n";
}

diag( "Testing USB::Descriptor::Device $USB::Descriptor::Device::VERSION, Perl $], $^X" );
