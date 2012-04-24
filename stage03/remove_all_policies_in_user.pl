#!/usr/bin/perl
use strict;
use Cwd;

require './lib_for_euare.pl';
require './lib_for_euare_teardown.pl';

$ENV{'EUCALYPTUS'} = "/opt/eucalyptus";

###
### check for arguments
###

my $given_account_name = "";
my $given_user_name = "";


if ( @ARGV > 0 ){
	$given_account_name = shift @ARGV;
};

if ( @ARGV > 0 ){
	$given_user_name = shift @ARGV;
};

###
### read the input list
###

print "\n";
print "########################### READ INPUT FILE  ##############################\n";

read_input_file();

my $clc_ip = $ENV{'QA_CLC_IP'};
my $source_lst = $ENV{'QA_SOURCE'};

if( $clc_ip eq "" ){
	print "[ERROR]\tCouldn't find CLC's IP !\n";
	exit(1);
};

if( $source_lst eq "PACKAGE" || $source_lst eq "REPO" ){
        $ENV{'EUCALYPTUS'} = "";
};



###
### check for account and user
###

print "\n";
print "########################### GET ACCOUNT AND USER NAME  ##############################\n";

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

if( $given_account_name ne "" ){
	$account_name = $given_account_name;
};

if( $given_user_name ne "" ){
	$user_name = $given_user_name;
};

###     ADDED   110311
$account_name = lc($account_name);
$user_name = lc($user_name);

print "\n";
print "TEST ACCOUNT NAME [$account_name]\n";
print "TEST USER NAME [$user_name]\n";
print "\n";


###
### Remove all the policies in account user
###

print "\n";
print "++++++++++++++++++++++++++++++++++++ Remove All Policies in User ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

remove_all_policies_in_user($account_name, $user_name);
print "\n";


###
### End of Script
###

print "\n";
print "[TEST_REPORT]\tREMOVE ALL POLICIES IN USER HAS BEEN COMPLETED\n";
print "\n";

exit(0);

1;


