#
# test using explicit ssl context
#
# $Id: CtxTest.t,v 1.3 2002/01/04 08:37:02 aspa Exp $.
#


use strict;
use IO::Socket::SSL;

my ($ctx1, $ctxArgs1, %conArgs1, $ctx2, $ctxArgs2, $conArgs2, $r);
my ($sock);

print "1..4\n";

my $debug = $ARGV[0] || "";
if($debug eq "DEBUG") { $IO::Socket::SSL::DEBUG = 1; }

$ctxArgs1 = { 'SSL_verify_mode' => 0x00 };
$ctx1 = SSL_Context->new($ctxArgs1);
if($ctx1) {
  print "ok\n";
} else {
  print "not ok\n";
}

%conArgs1 = ( 'PeerAddr' => 'www.thawte.com',
	      'PeerPort' => '443',
	      'Proto'    => 'tcp',
	      'SSL_verify_mode' => 0x00, );
$sock = $ctx1->getConnection('IO::Socket::SSL', %conArgs1);
if($sock) {
  print "ok\n";
} else {
  print "not ok\n";
}

$r = $sock->print("GET /\n\n");
if($r) {
  print "ok\n";
} else {
  print "not ok\n";
}

my $buf = "";
$r = $sock->read($buf, 500, 0);
if(defined($r)) {
  print "ok\n";
} else {
  print "not ok\n";
}

$sock->close();

