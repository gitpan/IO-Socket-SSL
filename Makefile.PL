#
# a MakeMaker script for IO::Socket::SSL (aspa@hip.fi).
#
# $Id: Makefile.PL,v 1.2 1999/06/08 07:07:24 aspa Exp aspa $.
#

use ExtUtils::MakeMaker;
use English;

# check perl version
my $p_ver = $PERL_VERSION;
if( $p_ver < 5.00503 ) {
  # prior versions have the self-tie mem leak bug.
  print STDERR "perl version >= 5.00503 needed. please install it!\n";
  exit(0);
}

my ($ssleay_ver);

# check the existence and version of Net::SSLeay.
eval {
  require Net::SSLeay;
  $ssleay_ver = $Net::SSLeay::VERSION;
  if($ssleay_ver < 1.03) {
    die "Net::SSLeay version 1.03 needed, installed module is only " .
      "$Net::SSLeay::VERSION\n"
    }
};
if ($@) {
  die "Net::SSLeay version >= 1.03 needed. exiting.\n";
} else {
  print "Net::SSLeay v$ssleay_ver found.\n";
}


# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	'NAME'	=> 'IO::Socket::SSL',
	'VERSION_FROM' => 'lib/IO/Socket/SSL.pm', # finds $VERSION
	'DISTNAME' => 'IO-Socket-SSL',
	'dist' => { COMPRESS => 'gzip', SUFFIX => 'gz', },
);
