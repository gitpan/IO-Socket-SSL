#
# a test server for testing IO::Socket::SSL-class's behavior
# (aspa@hip.fi).
#
# $Id: ssl_server.pl,v 1.6 1999/06/18 13:31:07 aspa Exp $.
#

use strict;
use IO::Socket::SSL;


my ($sock, $s, $v_mode);

#$v_mode = &Net::SSLeay::VERIFY_NONE();
$v_mode = &Net::SSLeay::VERIFY_PEER();

if(!($sock = IO::Socket::SSL->new( Listen => 5,
				   LocalAddr => 'localhost',
				   LocalPort => 9000,
				   Proto     => 'tcp',
				   SSL_verify_mode => $v_mode,
				 )) ) {
  print STDERR "unable to create socket: $!.\n";
  exit(0);
}

print STDERR "socket created.\n";

while(($s = $sock->accept)) {
  my ($peer_cert, $subject_name, $issuer_name, $date, $str);

  if( ! $s ) {
    print STDERR "error: '$!'.\n";
    next;
  }

  if(($peer_cert = $s->get_peer_certificate)) {
    $subject_name = $peer_cert->subject_name;
    $issuer_name = $peer_cert->issuer_name;
  }

  print STDERR "connection opened.\n";
  print STDERR "\t subject: '$subject_name'.\n";
  print STDERR "\t issuer: '$issuer_name'.\n";

  $date = `date`; chop $date;
  $str = "my date command says it's: '$date'";
  $s->write($str, length($str));

  $s->close();
  print STDERR "connection closed.\n";

}

$sock->close();

print STDERR "loop exited.\n";
