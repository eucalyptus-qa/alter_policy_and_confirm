#!/usr/bin/perl
use strict;
use Cwd;

$ENV{'EUCALYPTUS'} = "/opt/eucalyptus";

###
### check for arguments
###

my $given_test_name = "";
my $given_account_name = "";
my $given_user_name = "";

if ( @ARGV > 0 ){
	$given_test_name = shift @ARGV;
};

if ( @ARGV > 0 ){
	$given_account_name = shift @ARGV;
};

if ( @ARGV > 0 ){
	$given_user_name = shift @ARGV;
};


###
### check for testname, account, user, and repeat limit option
###

print "\n";
print "########################### GET ACCOUNT AND USER NAME  ##############################\n";

my $orig_test = "dan_test_dev_as_user";
my $account_name = "default-qa-account";
my $user_name = "user00";

###
### Default account is the name of this test
###

my $temp_buf = `cat ../*.conf | grep TEST_NAME`;
chomp($temp_buf);
if( $temp_buf =~ /TEST_NAME\s+(.+)/ ){
	$account_name = $1;
	$account_name =~ s/\r//g;
	$account_name =~ s/_/-/g;
};


if( $given_test_name ne "" ){
	$orig_test = $given_test_name;
};

if( $given_account_name ne "" ){
	$account_name = $given_account_name;
};

if( $given_user_name ne "" ){
	$user_name = $given_user_name;
};

###     ADDED   110311
$account_name = lc($account_name);
$user_name = lc($user_name);

my $testname = $orig_test . "_user_" . $user_name;

print "\n";
print "TEST NAME [$testname]\n";
print "TEST ACCOUNT NAME [$account_name]\n";
print "TEST USER NAME [$user_name]\n";
print "\n";


###
### Check the result of previous test run as user
###

print "\n";
print "++++++++++++++++++++++++++++++++++++ Checking Result for Fails ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

my $log_file = "../etc/runs/logs/". $testname . ".log";

print "cat $log_file | grep TEST_REPORT\n";
print "\n";

my $out = `cat $log_file | grep TEST_REPORT`;

my @lines = split("\n", $out);

my $f_count = 0;
foreach my $line (@lines){
	chomp($line);
	if( $line =~ /FAILED/ ){
		$f_count++;		
	};
};

my $repeat_limit = 1;
my $conf_file = "../etc/runs/" . $testname . "/" . $testname . ".conf";
my $temp_buf = `cat $conf_file | grep REPEAT`;
chomp($temp_buf);
if( $temp_buf =~ /REPEAT\s+(\d+)/ ){
	$repeat_limit = $1; 
};
print "\n";
print "[REPEATE_LIMIT]\t$repeat_limit\n";
print "[FOUND FAILED LINES]\t$f_count\n";

my $exit_code = 0;

if( $repeat_limit > $f_count ){
	print "[TEST_REPORT]\tFAILED in failing all iterations !!\n\n";
	print "\n";
	print "Lines:\n";
	print "\n";
	print "$out\n";
	print "\n";
	$exit_code = 1;
}else{

	print "\n";
	print "[TEST_REPORT]\tSucceeded in failing all iterations !!\n\n";
	print "\n";
	
};

print "\n";
print "\n";
print "\n";

print "\n";
print "\n";
print "\n";

if( $exit_code ){
	print "\n";
	print "++++++++++++++++++++++++++++++++++++ Complete Log ++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";

	print "\n";
	system("cat $log_file");
	print "\n";

	print "\n";
	print "\n";
	print "\n";

	print "\n";
	print "++++++++++++++++++++++++++++++++++++ End of Complete Log ++++++++++++++++++++++++++++++++++++++++++++\n";
	print "\n";
};

###
### End of Script
###

print "\n";
print "[TEST_REPORT]\tCHECK TEST REPORT ON PREVIOUS RUN FOR FAILS HAS BEEN COMPLETED\n";
print "\n";

exit($exit_code);

1;


