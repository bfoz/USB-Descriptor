#!perl -T

use Test::Simple tests => 3;

use USB::HID;

my $reports = [
    {
	'reportID'	=> 1,
	'type'		=> 'output',
	'fields'	=> [ 'button' => { 'usage' => 1 } ],
    },
    {	'reportID'	=> 2,
	'type'		=> 'input',
	'fields'	=> [ 'button' => 2 ],
    },
    {
	'input'		=> 3,
	'fields'	=> [ 'button' => 3 ],
    },
    {
	'output'	=> 4,
	'fields'	=> [ 'button' => 4 ],
    },
    {
	'feature'	=> 5,
	'fields'	=> [ 'button' => 5 ],
    },
    {	'input'		=> 6,
	'type'		=> 'feature',
	'fields'	=>
	[
	    'button'	=> { 'usage'	=> 6 },
	    'button'	=> { 'usage'	=> 7 },
	    'constant'	=> { 'size' => 1, 'count' => 3, },  # 3 bits of padding
	    'constant'	=> { 'bits'	=> 3, },	    # 3 bits of padding
	    'constant'	=> 3,	    			    # 3 bits of padding
	],
    },
];

my $device = USB::HID::Descriptor(
    'configurations'    => [
    {
    	'interfaces'	=> [
	{
	    'description'   => 'Interface 0',
	    'page'	    => 1,	# Generic Desktop
	    'usage'	    => 2,
	    'reports'	    => $reports,
    	}],
    }],
);

ok(defined $device, 'Device exists');

# Test the configuration getter
my @configurations = @{$device->configurations};
ok( scalar(@configurations) == 1, 'one configuration was specified');

# Test generated report descriptors
my @interfaces = map { @{$_->interfaces} } @configurations;

my @bytes = map { $_->report_bytes } @interfaces;

my @correct_bytes =
(
    [
	5, 1,		# UsagePage(GenericDesktop)
	9, 2,		# Usage 2
	161, 1,		# Collection(Application)
	    161, 3,	#  Collection(Report)
	    133, 1,	#  ReportID 2
	    21, 0,	#  LogicalMin 0
	    37, 1,	#  LogicalMax 1
	    149, 1,	#  ReportCount 1
	    117, 1,	#  ReportSize 1
	    9, 1,	#  Usage 1
	    145, 2,	#  Output (variable)
	    192,	#  End Collection

	    161, 3,	#  Collection(Report)
	    133, 2,	#  ReportID 2
	    9, 2,	#  Usage 2
	    129, 2,	#  Input (variable)
	    192,	#  End Collection

	    161, 3,	#  Collection(Report)
	    133, 3,	#  ReportID 3
	    9, 3,	#  Usage 3
	    129, 2,	#  Input (variable)
	    192,	#  End Collection

	    161, 3,	#  Collection(Report)
	    133, 4,	#  ReportID 4
	    9, 4,	#  Usage 4
	    145, 2,	#  Output (variable)
	    192,	#  End Collection

	    161, 3,	#  Collection(Report)
	    133, 5,	#  ReportID 5
	    9, 5,	#  Usage 5
	    177, 2,	#  Output (variable)
	    192,	#  End Collection

	    161, 3,	#  Collection(Report)
	    133, 6,	#  ReportID 6
	    9, 6,	#  Usage 6
	    177, 2,	#  Output (variable)
	    9, 7,	#  Usage 7
	    177, 2,	#  Output (variable)
	    149, 3,	#  ReportCount 3
	    9, 0,	#  Usage 0
	    177, 0,	#  Output (constant)
	    9, 0,	#  Usage 0
	    177, 0,	#  Output (constant)
	    9, 0,	#  Usage 0
	    177, 0,	#  Output (constant)
	    192,	#  End Collection

	192,		# End Collection
    ]
);

ok($bytes[0] ~~ @{$correct_bytes[0]}, 'report bytes must be correct');
