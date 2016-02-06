#!/usr/bin/perl -wT

# inet_log.pl
# pod at tail

use strict;
use LWP::UserAgent;
use Time::localtime;


### Begin Config Parameters ###
my %parm = (
log      => 'inet_log.log',
interval => 300,
timeout  => 120,
browser  => 'Mozilla/5.0 (X11; U; Linux 2.2.17 i586; en-US; m18)',
);
my @hosts = qw(
www.w3c.org   www.cpan.org   www.perl.com   freshmeat.net
www.cisco.com   www.useit.com   www.google.com   alistapart.com
www.debian.org   ftp.debian.org   www.weather.com
www.oreilly.com   www.slashdot.org   www.perlmonks.org
www.linuxgazette.com
);
my %proxy = (
use  => 0,
auth => 0,
host => '',
port => '',
id   => '',
pass => '',
);
### End Config Parameters ###


open (LOG, "> $parm{log}")   or die "\nError opening $parm{log}:\n  $!";
my $selected = select(LOG);
$|++;
select($selected);


print "\n",
"  Query a web host every $parm{interval} seconds\n",
"    Log:        $parm{log}\n",
"    Program:    $0\n",
"    LWP:        $LWP::VERSION\n",
"    Perl:       $]\n",
"    OS:         $^O\n";
print "    Proxy:      $proxy{host}:$proxy{port}\n"  if ($proxy{use} == 1);
print "    Proxy user: $proxy{id}\n"                 if ($proxy{auth} == 1);
print "\n",
"  Target hosts:\n";
print "    $_\n" for (@hosts);


=cut
 
 if ($proxy{use} == 1) {
 Net::Ping::Improved
 unless (...) {
 print"  Proxy not accessible\n\n";
 exit;
 }
 }
 
 =cut


print "\n  Querying web hosts  (1 = success, 0 = no response)\n";
my $old_success = 3;                       # first contact gets logged
while (1) {
    for (@hosts) {
        my ($success, $request);
        my $ua =  LWP::UserAgent->new;
        $ua    -> agent("$parm{browser}");
        $ua -> timeout("$parm{timeout}");
        
        if ($proxy{use} == 1) {
            $ua -> proxy('http',"http://$proxy{host}:$proxy{port}");
            $ua -> no_proxy($proxy{host});
        }
        if ($proxy{auth} == 1) {
            $request -> proxy_authorization_basic
            ("$proxy{id}", "$proxy{pass}");
        }
        
        $request     =  HTTP::Request->new('GET',"http://$_");
        my $response =  $ua->request($request);
        
        if    ($response->is_success()) {$success = 1;}
        elsif ($response->is_error())   {$success = 0;}
        PrintCon("$success", "$_");
        
        if ($success != $old_success) {    # has connection status changed?
            open (LOG, ">> $parm{log}") or die "\nError opening $parm{log}: $!";
            PrintLog("$success", "$_");
            $old_success = $success;
        }
        sleep $parm{interval};
    }
}


##########################################################################
sub PrintCon {
    my $print_state = $_[0];
    my $host        = $_[1];
    printf "    %4d-%2d-%2d,  %2d:%2d:%2d, ",
    localtime->year()+1900,
    localtime->mon()+1,
    localtime->mday(),
    localtime->hour(),
    localtime->min(),
    localtime->sec(),
    ;
    print "  $print_state,  $host,\n";
}
##########################################################################
sub PrintLog {
    my $print_state = $_[0];
    my $host        = $_[1];
    printf LOG "  %4d-%2d-%2d,  %2d:%2d:%2d, ",
    localtime->year()+1900,
    localtime->mon()+1,
    localtime->mday(),
    localtime->hour(),
    localtime->min(),
    localtime->sec(),
    ;
    print LOG "  $print_state,  $host,\n";
    close LOG            or die "\nError closing $parm{log}: $!";
}
##########################################################################


=head1 Name
 
 inet_log.pl
 
 =head1 Description
 
 Log Internet connection drops, or nail up a dial connection.
 Use LWP to periodically request a page from configured list of webhosts.
 Doesn't use simple ping because:
 - ISP routers often not configured for ICMP as "interesting traffic"
 where HTTP generally is.
 - Some sites block ICMP at their outside DMZ router.
 - Allows you to run this script from inside a firewalled location
 for other purposes.
 Logs only instances of change in response (pass|fail).
 
 =head1 Usage
 
 No switches or syntax.  Config parameters near head of script.
 
 =head1 Author
 
 ybiC
 
 =head1 Credits
 
 Started from good monk zeno's cool inet_log.pl
 http://www.perlmonks.org/index.pl?node_id=57865
 
 =head1 Tested
 
 LWP    5.51
 Perl   5.00503
 Debian 2.2r3
 
 =head1 Updates
 
 2001-04-25   06:00
 Add module and Perl versions display.
 Simplify code for opening messages.
 Add qw() to declaration of @hosts to eliminate mess o' quotes+commas.
 Unsubify LWP - move Fetch code to main body of script.
 Use $_ with @hosts to eliminate global $host.
 Fix 'uninitialized value' re $print_state
 by quoting properly in Print(Log|Con) calls.
 Add support for authenticated proxy.
 Break %global out into %proxy and %parm.
 Add if(){...} loops for proxy{use} and proxy{auth}
 Minor format & pod tweaks.
 2001-04-23   22:40
 Hashamify passel o' scalar vars.
 Un-subify to reduce number of global vars.
 Replace 'use vars qw()' with 'my (,)' so lexical not global.
 Mixed-case names for remaining subroutines, and no ampersan.
 Remove unecessary doublequotes around variables.
 Fix 'scalar found where' errors by adding qq// to Print(Con|Log) calls.
 Reformat for max 75 chars/line.
 2001-02-14
 Replace LWP::Simple with LWP::UserAgent.
 Add proxy, timeout, useragent.
 Move $ua section to sub since is called twice.
 Add Time::localtime, printf.
 because no comprendo good monk zeno's time syntax.
 Move sleep to end of while(1) section so no wait after hit proxy.
 2001-02-13
 Fork from zeno's cool script.
 Minor style stuff to personal taste.
 Multiple hosts target rotation - avoid excessive hits on any one host.
 Move redundant code to subroutines.
 Output format to CSV for reporting.
 Add "use vars qw()" instead of empty 'my blah's'.
 Hit local proxy first before hitting Internet hosts.
 assumes proxy is also HTTP server.
 
 =head1 Todos
 
 Ping proxy with Net::Ping(|::(Improved|External)).
 Test $proxy{user} and $proxy{pass}.
 Test on Win32 - ActiveState, Cygwin, etc.
 Randomize @hosts selection, and $parm{interval} ~1-4 minutes.
 Background with (fork|Proc::Daemon|??) so can kill xterm after launching.
 If connection fails, immediately try next host.
 
 =cut
