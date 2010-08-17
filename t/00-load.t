#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'App::Hinetmania' ) || print "Bail out!
";
}

diag( "Testing App::Hinetmania $App::Hinetmania::VERSION, Perl $], $^X" );
