#
# a test client for testing IO::Socket::SSL-class's behavior
# (aspa@hip.fi).
#
# $Id: ssl_client.pl,v 1.6 1999/06/18 13:31:39 aspa Exp aspa $.
#


use strict;
use IO::Socket::SSL;

my ($v_mode, $sock, $buf);

$v_mode = &Net::SSLeay::VERIFY_PEER;
#$v_mode = &Net::SSLeay::VERIFY_NONE;

if(!($sock = IO::Socket::SSL->new( PeerAddr => 'localhost',
				   PeerPort => '9000',
				   Proto    => 'tcp',
				   SSL_use_cert => 1,
				   SSL_verify_mode => $v_mode,
				   ))) {
  print STDERR "unable to create socket: '$!'.\n";
  exit(0);
}

# check server cert.
my ($peer_cert, $subject_name, $issuer_name);
if(($peer_cert = $sock->get_peer_certificate)) {
  $subject_name = $peer_cert->subject_name;
  $issuer_name = $peer_cert->issuer_name;
}
print STDERR "server cert:\n". 
  "\t '$subject_name' \n\t '$issuer_name'.\n\n";


$buf = "";

$sock->sysread($buf, 32768);

print "read: '$buf'.\n";
