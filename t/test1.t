#
# a test client for testing IO::Socket::SSL's behavior (aspa@hip.fi).
#
# $Id: test1.t,v 1.4 1999/06/18 13:40:11 aspa Exp $.
#

use IO::Socket::SSL;

my ($v_mode, $sock);

$v_mode = &Net::SSLeay::VERIFY_PEER();

print "1..4\n";

if(!($sock = IO::Socket::SSL->new( PeerAddr => 'www.hip.fi',
			    PeerPort => '443',
			    Proto    => 'tcp',
			    SSL_verify_mode => $v_mode,
			  )) ) {
  print STDERR "unable to create a IO::Socket::SSL object.\n";
  print "not ok\n";
  exit(0);
} else {
  print "ok\n";
}

$rq = "fuufaa GET /\n\n";

# try the syswrite-interface with an offset.
if($sock->write("$rq", 100, 7) < 0) {
  print "not ok\n";
  exit(0);
} else {
  print "ok\n";
}

my $buf = "";
my ($cnt, $r) = (0, 0);

# these test the sysread interface (test count and offset).
while ( ($r = $sock->read($buf, 1, $cnt)) && ($cnt < 154) ) {
  $cnt += $r;
}
if($r && $cnt) { print "ok\n"; } else { print "not ok\n"; }

#print STDERR "read bytes: cnt = '$cnt'.\n";

# read the rest of the input.
while ( ($r = $sock->read($buf, 1, $cnt)) ) {
  $cnt += $r;
}
if(!$r && $cnt) { print "ok\n"; } else { print "not ok\n"; }

#print STDERR "'$buf'\n";

$sock->close;

