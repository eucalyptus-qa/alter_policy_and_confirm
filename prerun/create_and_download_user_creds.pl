#!/usr/bin/perl
use strict;
use Cwd;

require "./lib_for_euare.pl";

$ENV{'EUCALYPTUS'} = "/opt/eucalyptus";


################################################## DOWNLOAD USER CREDENTIALS . PL #########################################################


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
### check for TEST_ACCOUNT_NAME in MEMO ... disabled for now
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
#}elsif( is_test_account_name_from_memo() ){
#	$account_name = $ENV{'QA_MEMO_TEST_ACCOUNT_NAME'};
};

if( $given_user_name ne "" ){
	$user_name = $given_user_name;
#}elsif( is_test_account_user_name_from_memo() ){
#	$user_name = $ENV{'QA_MEMO_TEST_ACCOUNT_USER_NAME'};
};

print "\n";
print "TEST ACCOUNT NAME [$account_name]\n";
print "TEST USER NAME [$user_name]\n";
print "\n";

###
### Create Account and User
###

print "\n";
print "++++++++++++++++++++++++++++++++++++ Running \"create_account_and_user.pl\" with Account \'$account_name\' and User \'$user_name\' ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

print "\n";
print "perl ./create_account_and_user.pl $account_name $user_name\n";
system("perl ./create_account_and_user.pl $account_name $user_name");
print "\n";

print "\n";
sleep(5);
print "\n";

###
### Download User Credentials
###

print "\n";
print "++++++++++++++++++++++++++++++++++++ Running \"download_user_credential.pl\" with Account \'$account_name\' and User \'$user_name\' ++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";


print "\n";
print "perl ./download_user_credentials.pl $account_name $user_name\n";
system("perl ./download_user_credentials.pl $account_name $user_name");
print "\n";

###
### End of Script
###

print "\n";
print "[TEST_REPORT]\tCREATE AND DOWNLOAD USER CREDENTIAL HAS BEEN COMPLETED\n";
print "\n";

exit(0);

1;


