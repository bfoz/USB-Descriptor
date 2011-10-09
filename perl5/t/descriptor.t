#!perl -T

use Test::Simple tests => 12;

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
    'configurations'    => [ USB::Descriptor::Configuration->new(
	'description'       => 'Configuration 0',
	'remote_wakeup'	    => 1,
	'max_current'       => 100,   # mA
	'interfaces'	    => [ USB::Descriptor::Interface->new(
	    'description'   	=> 'Interface 0',
	    'endpoints'	    	=> [ USB::Descriptor::Endpoint->new(
		'direction'	    => 'in',
		'number'	    => 1,
		'max_packet_size'   => 64,
	    )],
	)],
    ),
    {	'description'   => 'Configuration 1',
    	'max_current'   => 10,	# mA
    	'interfaces'	=> [{
    		'description'   => 'Interface 1',
    		'endpoints'	=> [{
			'direction'	    => 'in',
			'number'	    => 2,
			'max_packet_size'   => 8,
    		}],
    	}],
    }],
);

ok( defined $device, 'Device exists' );

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
		     2		# bNumConfigurations
);

my $bytes = $device->bytes;
ok(@$bytes ~~ @correct_bytes, 'bytes must be correct');

my @arrayified_bytes = @{$device};
ok( @arrayified_bytes ~~ @$bytes, 'Arrayification must produce the same result every time');

my @usb_version = $device->usb_version;
ok(@usb_version ~~ [1,2,3], 'usb_version must be (1,2,3)');
ok($device->usb_version eq '1.2.3', 'usb_version must be \'1.2.3\'');

my @version = $device->version;
ok(@version ~~ [3,2,1], 'version must be (3,2,1)');
ok($device->version eq '3.2.1', 'version must be \'3.2.1\'');

# Test the configuration getter
my @configurations = @{$device->configurations};
ok( scalar(@configurations) == 2, 'two configurations were specified');
# Test the interface getter
ok(0 == (grep {scalar(@{$_->interfaces}) != 1} @configurations), 'each configuration must have exactly one interface');
# Test the endpoint getter
ok(0 == (grep { grep {scalar(@{$_->endpoints}) != 1} @{$_->interfaces} } @configurations), 'each interface must have exactly one endpoint');

# Test the generated configuration descriptors
@correct_bytes = (
[   9,			# bLength = 9
    2,			# bDescriptorType = 0x02
    25, 0,		# wTotalLength low,high
    1,			# bNumInterfaces
    0,			# bConfigurationValue
    4,			# iConfiguration
    160,		# bmAttributes
    50,			# bMaxPower
	9,		#    bLength = 9
	4,  		#    bDescriptorType = 0x04
	0,		#    bInterfaceNumber
	0,  		#    bAlternateSetting
	1,		#    bNumEndpoints
	0, 0,		#    bInterfaceClass, bInterfaceSubClass
	0,		#    bInterfaceProtocol
	5,		#    iInterface
	    7,		#	bLength = 7
	    5,		#	bDescriptorType = 0x05
	    129,	#	bEndPointAddress 1,IN
	    0,		#	bmAttributes
	    64, 0,	#	wMaxPacketSize low,high
	    10		#	bInterval
    ],
    [9, 2, 25, 0, 1,
    1,			# bConfigurationValue
    6, 128, 5, 9, 4, 0, 0, 1, 0, 0, 0, 7, 7, 5, 130, 0, 8, 0, 10]);

my @bytes = map { $_->bytes } @configurations;
ok(@bytes ~~ @correct_bytes, 'bytes must be correct');

# Test the string descriptors
my @correct_strings = (
    'Acme, Inc.',
    'Giant Catapult',
    '007',
    'Configuration 0',
    'Interface 0',
    'Configuration 1',
    'Interface 1',
);

my @strings = $device->strings;
ok(@strings ~~ @correct_strings, 'strings must match');
