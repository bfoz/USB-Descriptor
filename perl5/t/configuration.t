#!perl -T

use Test::Simple tests => 5;

use USB::Descriptor;

my $device = USB::Descriptor::device(
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
	'remote_wakeup'	    => 1,
	'max_current'       => 100,   # mA
	'interfaces'	    => [
	{
	    'description'   	=> 'Interface 0',
	},
	{
	    'description'   	=> 'Interface 1',
	}],
    },
    {
	'description'       => 'Configuration 1',
	'interfaces'	    =>
	{
	    'description'   	=> 'Interface 2',
	}
    },
    {
	'description'       => 'Configuration 2',
	'interface'	    =>
	{
	    'description'   	=> 'Interface 3',
	},
    }],
);

ok(defined $device, 'Device exists');

# Check that the generated device descriptor is correct
my @correct_bytes = (
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
);

my $bytes = $device->bytes;
ok(@$bytes ~~ @correct_bytes, 'bytes must be correct');

# Test the configuration getter
my @configurations = @{$device->configurations};
ok( scalar(@configurations) == 3, 'three configurations were specified');

# Test the generated configuration descriptors
@correct_bytes = 
([
    9,			# bLength = 9
    2,			# bDescriptorType = 0x02
    27, 0,		# wTotalLength low,high
    2,			# bNumInterfaces
    0,			# bConfigurationValue
    4,			# iConfiguration
    160,		# bmAttributes
    50,			# bMaxPower
	9,		#    bLength = 9
	4,  		#    bDescriptorType = 0x04
	0,		#    bInterfaceNumber
	0,  		#    bAlternateSetting
	0,		#    bNumEndpoints
	0, 0,		#    bInterfaceClass, bInterfaceSubClass
	0,		#    bInterfaceProtocol
	5,		#    iInterface

	9,		#    bLength = 9
	4,  		#    bDescriptorType = 0x04
	1,		#    bInterfaceNumber
	0,  		#    bAlternateSetting
	0,		#    bNumEndpoints
	0, 0,		#    bInterfaceClass, bInterfaceSubClass
	0,		#    bInterfaceProtocol
	6,		#    iInterface
],
[
    9,			# bLength = 9
    2,			# bDescriptorType = 0x02
    18, 0,		# wTotalLength low,high
    1,			# bNumInterfaces
    0,			# bConfigurationValue
    7,			# iConfiguration
    128,		# bmAttributes
    0,			# bMaxPower
	9,		#    bLength = 9
	4,  		#    bDescriptorType = 0x04
	0,		#    bInterfaceNumber
	0,  		#    bAlternateSetting
	0,		#    bNumEndpoints
	0, 0,		#    bInterfaceClass, bInterfaceSubClass
	0,		#    bInterfaceProtocol
	8,		#    iInterface
],
[
    9,			# bLength = 9
    2,			# bDescriptorType = 0x02
    18, 0,		# wTotalLength low,high
    1,			# bNumInterfaces
    0,			# bConfigurationValue
    9,			# iConfiguration
    128,		# bmAttributes
    0,			# bMaxPower
	9,		#    bLength = 9
	4,  		#    bDescriptorType = 0x04
	0,		#    bInterfaceNumber
	0,  		#    bAlternateSetting
	0,		#    bNumEndpoints
	0, 0,		#    bInterfaceClass, bInterfaceSubClass
	0,		#    bInterfaceProtocol
	10,		#    iInterface
]);

my @bytes = map { $_->bytes } @configurations;
ok(@bytes ~~ @correct_bytes, 'configuration bytes must be correct');

# Test the string descriptors
my @correct_strings = 
(
    'Acme, Inc.',
    'Giant Catapult',
    '007',
    'Configuration 0',
    'Interface 0',
    'Interface 1',
    'Configuration 1',
    'Interface 2',
    'Configuration 2',
    'Interface 3',
);

my @strings = $device->strings;
ok(@strings ~~ @correct_strings, 'strings must match');
