use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'File::Find::Similars',
    AUTHOR              => 'Tong Sun <suntong@cpan.org>',
    VERSION_FROM        => 'lib/File/Find/Similars.pm',
    ABSTRACT_FROM       => 'lib/File/Find/Similars.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'BSD')
      : ()),
    EXE_FILES		=> [ 'bin/file-similars' ],
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'File-Find-Similars-*' },
);
