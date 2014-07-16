#!/usr/bin/perl
use strict;

# This script generates a csr and private key (.pem) based on the hostname and domain selected by the user
# Key is hardcodes at 4096 bytes
# Validity is 999 days
my $CN;
my $domain;
my @domains = ('dc.domain.local','otherdomain.local','yetanotherdomain.com');
my @certAttr = ("/C=AU/ST=NSW/L=Sydney/O=PrettyAwesome/OU=hawmps/CN=", "/C=PH/L=Manila/O=WidgetCom/OU=Infrastructure/CN=","/C=MT/L=Sliema/O=SuperCompany/OU=Infrastructure/CN=");
print "Hawmps CSR Tool\n";
print "====================\n";
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
