#!perl -T

use Test::More tests => 2;

BEGIN {
	use_ok( 'Text::Soundex' );
	use_ok( 'File::Find::Similars' );
}

diag( "Testing File::Find::Similars $File::Find::Similars::VERSION, Perl $], $^X" );
