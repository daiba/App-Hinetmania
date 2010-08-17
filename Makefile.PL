use inc::Module::Install;

name     'App-Hinetmania';
all_from 'lib/App/Hinetmania.pm';
author   q{Keiichi Daiba <daiba@cpan.org>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

