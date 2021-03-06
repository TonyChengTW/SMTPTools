#!/bin/perl 
# ====================================================== 
# Writer   : Mico Cheng 
# Version  : 2004052501 
# Use for  : transfer IP Class to TrustIP Table 
# ====================================================== 

use DBI; 

$accessfile = "trustip.list"; 

$dbh = DBI ->connect("DBI:mysql:mail_apol;host=203.79.224.115", "rmail", 
"xxxxxxx") or die "$!\n"; 


open ACCESS, "$accessfile" or die "Can not open $accessfile:$!\n"; 
foreach (<ACCESS>) { 
print "line: $_\n"; 
      if (/^(\d+\.\d+\.\d+\.\d+)$/) { 
            #print "insert $trustip\n"; 
            &insertip($1); 
      } elsif (/^(\d+\.\d+\.\d+)$/) { 
            @range = 1..254; 
            $trustcip = $1; 
            foreach $one (@range) { 
                   $trustip = "$trustcip."."$one"; 
                   #print "insert $trustip\n"; 
                   insertip($trustip); 
            } 
      } elsif (/^(\d+\.\d+)\s$/) { 
            @range_a = 0..254; 
            @range_b = 1..254; 
            $trustbip = $1; 
            foreach $one (@range_a) { 
                 foreach $two (@range_b) { 
                        $trustip = "$trustbip."."$one."."$two"; 
                        #print "insert $trustip\n"; 
                        insertip($trustip); 
                 } 
            } 
      } else { 
            print "no match RELAY:$_\n"; 
      } 
} 
$dbh->disconnect(); 
close(ACCESS); 

sub insertip { 
#  $sqlstmt = sprintf("select s_ip from TrustIP where s_ip=\'%s\'", $_[0]); 
#  $sth = $dbh->prepare($sqlstmt); 
#  $sth->execute() or die "can not insert : $!\n"; 
#  if ($sth->rows != 1) { 
        $sqlstmt = sprintf("insert into TrustIP values ('%s', NOW(), 'add by mico-60.244.32-127 96-section length 24')", $_[0]); 
        $dbh->do($sqlstmt); 
#  } else { 
#        next; 
#  } 
} 

