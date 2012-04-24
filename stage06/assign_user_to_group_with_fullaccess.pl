#!/usr/bin/perl
use strict;
use Cwd;

require './lib_for_euare.pl';
require './lib_for_euare_teardown.pl';
require './lib_for_euare_policy.pl';

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
### get groups
###

my $out = get_account_groups($account_name);
print "$out\n";
print "\n";


###
### get groups in array
###
$out = get_list_of_groups($out);
print "Groups List\n";
print "$out\n";
print "\n";

my @group_array = split(" ", $out);

###
### Remove User from  all groups
###

print "\n";
print "++++++++++++++++++++++++++++++++++++ Remove User from All Groups ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

foreach my $group (@group_array){
        remove_all_users_in_group($account_name, $group);
};
print "\n";


###
### Create a group
###

print "\n";
print "++++++++++++++++++++++++++++++++++++ Create a Group ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

my $group_name = "full-access-group";
create_account_group($account_name, $group_name);
print "\n";


###
### Assign a FullAccess Policy
###

print "\n";
print "++++++++++++++++++++++++++++++++++++ Assign Policy ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

my $policy_filename = "fullaccess.policy";
copy_given_policy_file($policy_filename);
set_account_group_policy($account_name, $group_name, $policy_filename);
print "\n";


###
### Assign User to Group
###

print "\n";
print "++++++++++++++++++++++++++++++++++++ Assign User to Group ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

set_account_user_to_group($account_name, $user_name, $group_name);
print "\n";


###
### End of Script
###

print "\n";
print "[TEST_REPORT]\tASSIGN USER TO GROUP WITH FULLACCESS HAS BEEN COMPLETED\n";
print "\n";

exit(0);

1;


