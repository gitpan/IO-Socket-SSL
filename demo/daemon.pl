#
# test HTTP::Daemon with IO::Socket::SSL (aspa@hip.fi).
#
# $Id: daemon.pl,v 1.4 1999/06/18 13:27:24 aspa Exp $.
#

# NB: to use this demo script HTTP::Daemon and
# HTTP::Daemon::ClientConn have to be direct descendents of
# IO::Socket::SSL instead of IO::Socket::INET.


use HTTP::Daemon;
use HTTP::Status;
use IO::Socket::SSL;


$r = IO::Socket::SSL::context_init({
				    SSL_verify_mode => 0x00,
				    SSL_server => 1,
			   });
$IO::Socket::SSL::DEBUG=1;


my $d = new HTTP::Daemon;
print "Please contact me at: <URL:", $d->url, ">\n";
while (my $c = $d->accept) {
  while (my $r = $c->get_request) {
    if ($r->method eq 'GET' and $r->url->path eq "/xyzzy") {
      # remember, this is *not* recommened practice :-)
      $c->send_file_response("/etc/hosts");
    } else {
      $c->send_error(RC_FORBIDDEN)
    }
  }
  $c->close;
  undef($c);
}

