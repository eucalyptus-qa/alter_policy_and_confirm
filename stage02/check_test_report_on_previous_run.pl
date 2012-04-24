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
print "++++++++++++++++++++++++++++++++++++ Checking Result ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

my $log_file = "../etc/runs/logs/". $testname . ".log";

print "cat $log_file | grep TEST_REPORT\n";
print "\n";
system("cat $log_file | grep TEST_REPORT");
print "\n";

print "\n";
print "++++++++++++++++++++++++++++++++++++ Checking Result ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

print "\n";
print "\n";
print "\n";

print "\n";
print "\n";
print "\n";

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


###
### End of Script
###

print "\n";
print "[TEST_REPORT]\tCHECK RESULT HAS BEEN COMPLETED\n";
print "\n";

exit(0);

1;


