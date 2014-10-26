#
# a test client for testing IO::Socket::SSL's behavior
# with tied filehandles (aspa@hip.fi).
#
# $Id: fh-test.t,v 1.5 2000/08/08 06:32:14 aspa Exp $.
#

use IO::Socket::SSL;

print "1..3\n";

my $debug = $ARGV[0] || "";
if($debug eq "DEBUG") { $IO::Socket::SSL::DEBUG = 1; }

ssl_fh_test();

print STDERR "in t/fh-test.t main.\n" if ($IO::Socket::SSL::DEBUG);

sub ssl_fh_test {
  my ($v_mode, $sock);
  my $buf = "";
  my ($cnt, $r) = (0, 0);
  
  if(!($sock = IO::Socket::SSL->new( PeerAddr => 'www.helsinki.fi',
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

  print STDERR "buf: '$buf'\n" if ($IO::Socket::SSL::DEBUG);
  
  close($sock);
}
