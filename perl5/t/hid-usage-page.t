#!perl -T

use Test::Simple tests => 5;

use USB::HID;

my $device = USB::HID::Descriptor(
    'configurations'    => [
    {
    	'interfaces'	=> [
	{
	    'description'   => 'Interface 0',
	    'page'	    => 1,	# Generic Desktop
	    'usage'	    => 2,
    	},
	{
	    'description'   => 'Interface 1',
	    'page'	    => 'GenericDesktop',
	    'usage'	    => 3,
    	},
	{
	    'description'   => 'Interface 2 - Vendor Specific Usage Page',
	    'page'	    => 0xFF00,  # Vendor Specific(1)
	    'usage'	    => 0,
    	}],
    }],
);

ok(defined $device, 'Device exists');

# Test the configuration getter
my @configurations = @{$device->configurations};
ok( scalar(@configurations) == 1, 'one configuration was specified');
# Test the interface getter
ok(0 == (grep {scalar(@{$_->interfaces}) != 3} @configurations), 'each configuration must have exactly three interfaces');
# All interfaces must be HID interfaces
ok(0 == (grep { (grep {not $_->isa('USB::HID::Descriptor::Interface')} @{$_->interfaces}) != 0 } @configurations), 'all interfaces must be USB::HID::Descriptor::Interface');

# Test generated report descriptors
my @interfaces = map { @{$_->interfaces} } @configurations;

my @bytes = map { $_->report_bytes } @interfaces;

my @correct_bytes =
(
    [
	5, 1,		# UsagePage(GenericDesktop)
	9, 2,		# Usage 2
	161, 1,		# Collection(Application)
	192,		# End Collection
    ],
    [
	5, 1,		# UsagePage(GenericDesktop)
	9, 3,		# Usage 3
	161, 1,		# Collection(Application)
	192,		# End Collection
    ],
    [
	6, 0, 0xFF,	# UsagePage(Vendor Specific(1))
	9, 0,		# Usage 0
	161, 1,		# Collection(Application)
	192,		# End Collection
    ],
);

ok($bytes[0] ~~ @{$correct_bytes[0]}, 'interface bytes must be correct');
