#
# a test client for testing IO::Socket::SSL's behavior
# with tied filehandles (aspa@hip.fi).
#
# $Id: fh-test.t,v 1.3 1999/07/22 20:08:51 aspa Exp $.
#

use IO::Socket::SSL;

my ($v_mode, $sock);
my $buf = "";
my ($cnt, $r) = (0, 0);


print "1..3\n";

if(!($sock = IO::Socket::SSL->new( PeerAddr => 'www.hip.fi',
				   PeerPort => '443',
				   Proto    => 'tcp',
				   SSL_verify_mode => 0x01,
				 )) ) {
  print STDERR "unable to create a IO::Socket::SSL object.\n";
  print "not ok\n";
  exit(0);
} else {
  print "ok\n";
}

$r = print $sock "GET /\n\n";

if (!$r) {
  print "not ok\n";
  exit(0);
} else {
  print "ok\n";
}

$r = read $sock, $buf, 5000, 0;

if(! defined $r) {
  print "not ok\n";
  exit(0);
} else {
  print "ok\n";
}

#print "buf: '$buf'\n";

close($sock);

