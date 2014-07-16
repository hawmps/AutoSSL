#!/usr/bin/perl
use strict;
use feature qw(switch);
# This script generates a csr and private key (.pem) based on the hostname and domain selected by the user
# Key is hardcodes at 4096 bytes
# Validity is 999 days
my $option;
my $exitFlag = 0;
my $CN;
my $domain;

# @domains list of domains to append to hostname entered by user. TODO create sub for allowing input of domain file
my @domains = ('dc.domain.local','otherdomain.local','yetanotherdomain.com');
my @certAttr = ("/C=AU/ST=NSW/L=Sydney/O=PrettyAwesome/OU=hawmps/CN=", "/C=PH/L=Manila/O=WidgetCom/OU=Infrastructure/CN=","/C=MT/L=Sliema/O=SuperCompany/OU=Infrastructure/CN=");

#menu options. Very limited input sanitaion (whitelist!)
sub menu {
    print "\nHawmps CSR Tool\n";
    print "====================\n";
    print "1. Create new key and CSR\n2. Create PKCS 12 File\n3. Quit\n";
    $option = <STDIN>;
    chomp $option;
    if ($option==1||$option==2||$option==3) {
        return $option;
    } else {
       return 9;
    }
};

#createCSR sub. will create .pem and .csr file with hostname+domain selected by user.  
sub createCSR {
    print "Enter Cert CN: ";
    my $CN = <STDIN>;
    chomp $CN;
    print "\nChoose Domain:\n";
    print "1. $domains[0] 2. $domains[1] 3. $domains[2]\n";
    my $domain = <STDIN>;
    chomp $domain;
    #$domain=$domains[$domain];
    print "Going to make $CN.$domains[$domain-1]\n";
    my @sysArgs = ('openssl', 'genrsa', '-out', "./$CN.pem","4096");
    system(@sysArgs) == 0 or die "Failed to execute @sysArgs";
    my @sysArgs2 = ('openssl', 'req', '-new', '-subj', "@certAttr[$domain-1]$CN.$domains[$domain-1]", '-days', '999', '-key', "$CN.pem", "-out", "$CN.csr");
    system(@sysArgs2) == 0 or die "Failed to execute @sysArgs2";
    print "Generated CSR for $CN.$domains[$domain-1]\nVerify with openssl req -in $CN.csr -noout -text\n";

};

#pkcs12 subroutine. todo.
sub createP12{
    print "//TODO createP12";
};

# main program statement. runs in a while loop until exit is selected as an option
while ($exitFlag == 0) {
    my $sub = menu{};
    given ($sub) {
        when(1)  {createCSR{};}
        when(2)  {createP12{};}
        when(3)  {$exitFlag = 1;}
        when(9) {print "No such option, try again\n";}
    };
};
