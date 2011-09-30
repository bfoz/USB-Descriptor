#!perl -T

use Test::Simple tests => 4;

use USB::Descriptor;

my @devices = (
USB::Descriptor::device(
    'usb_version'	=> '1.2.3',
    'class'		=> 1,
    'subclass'		=> 2,
    'protocol'		=> 3,
    'max_packet_size'	=> 64,
    'vendorID'	   	=> 0x1234,
    'productID'	    	=> 0x5678,
    'version'		=> '3.2.1',
    'manufacturer'	=> 'Acme, Inc.',
    'product'	    	=> 'Giant Catapult',
    'serial_number'	=> '007',
    'configurations'    => [
    {
	'description'       => 'Configuration 0',
    },
    {
	'description'       => 'Configuration 1',
    },
    {
	'description'       => 'Configuration 2',
    }],
),

USB::Descriptor::device(
    'usb_version'	=> '1.2.3',
    'class'		=> 1,
    'subclass'		=> 2,
    'protocol'		=> 3,
    'max_packet_size'	=> 64,
    'vendorID'	   	=> 0x1234,
    'productID'	    	=> 0x5678,
    'version'		=> '3.2.1',
    'manufacturer'	=> 'Acme, Inc.',
    'product'	    	=> 'Giant Catapult',
    'serial_number'	=> '007',
    'configurations'    =>
    {
	'description'       => 'Configuration 0',
	'remote_wakeup'	    => 1,
	'max_current'       => 100,   # mA
    }
),

USB::Descriptor::device(
    'usb_version'	=> '1.2.3',
    'class'		=> 1,
    'subclass'		=> 2,
    'protocol'		=> 3,
    'max_packet_size'	=> 64,
    'vendorID'	   	=> 0x1234,
    'productID'	    	=> 0x5678,
    'version'		=> '3.2.1',
    'manufacturer'	=> 'Acme, Inc.',
    'product'	    	=> 'Giant Catapult',
    'serial_number'	=> '007',
    'configuration'	=>
    {
	'description'       => 'Configuration 0',
    }
));

ok( scalar(@devices) == 3, 'three devices were specified');
ok(3 == scalar(grep { defined $_ } @devices), '3 devices exist');

# Check that the generated device descriptor is correct
my @correct_bytes = (
[
     18,	# bLength
     1,		# bDescriptorType = 0x01
     0x23, 1,	# bcdUSB = 1.2.3
     1, 2, 3,	# bDeviceClass, bDeviceSubClass, bDeviceProtocol
     64,	# bMaxPacketSize0
     0x34, 0x12,# idVendor low,high
     0x78, 0x56,# idProduct low,high
     0x21, 3,	# bcdDevice = 3.2.1
     1,		# iManufacturer
     2,		# iProduct
     3,		# iSerialNumber
     3		# bNumConfigurations
],
[
    18,	# bLength
    1,		# bDescriptorType = 0x01
    0x23, 1,	# bcdUSB = 1.2.3
    1, 2, 3,	# bDeviceClass, bDeviceSubClass, bDeviceProtocol
    64,		# bMaxPacketSize0
    0x34, 0x12,	# idVendor low,high
    0x78, 0x56,	# idProduct low,high
    0x21, 3,	# bcdDevice = 3.2.1
    1,		# iManufacturer
    2,		# iProduct
    3,		# iSerialNumber
    1		# bNumConfigurations
],
[
    18,	# bLength
    1,		# bDescriptorType = 0x01
    0x23, 1,	# bcdUSB = 1.2.3
    1, 2, 3,	# bDeviceClass, bDeviceSubClass, bDeviceProtocol
    64,		# bMaxPacketSize0
    0x34, 0x12,	# idVendor low,high
    0x78, 0x56,	# idProduct low,high
    0x21, 3,	# bcdDevice = 3.2.1
    1,		# iManufacturer
    2,		# iProduct
    3,		# iSerialNumber
    1		# bNumConfigurations
],
);

my @bytes = map { $_->bytes } @devices;
ok(@bytes ~~ @correct_bytes, 'bytes must be correct');

# Test the string descriptors
my @correct_strings = 
([
    'Acme, Inc.',
    'Giant Catapult',
    '007',
],
[
    'Acme, Inc.',
    'Giant Catapult',
    '007',
],
[
    'Acme, Inc.',
    'Giant Catapult',
    '007',
]);

my @strings = map { [$_->strings] } @devices;
ok(@strings ~~ @correct_strings, 'strings must match');
