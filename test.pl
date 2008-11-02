#! /usr/bin/env perl
# -*- perl -*-

# @Author: Tong SUN, (c)2001-2008, all right reserved
# @Version: $Date: 2008/11/01 23:27:10 $ $Revision:  $
# @HomeURL: http://xpt.sourceforge.net/

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use strict;
use Test;

# use a BEGIN block so we print our plan before MyModule is loaded
BEGIN { plan tests => 5, todo => [2] }

# load your module...
use File::Find::Similars;

print "# Testing File::Find::Similars version $File::Find::Similars::VERSION\n";

# Test code

sub run_cmd{
    my ($cmd) = @_;

    open(TESTOUT, "$cmd |");
    my @strs = <TESTOUT>;
    my $strs = join("",@strs);
    #print "\n Returns:\n$strs";

    return $strs;
}

sub dotest{
    my ($fsize) = @_;

    open(FH, ">test/Python Standard Library.zip");
    print FH 'a' x $fsize;
    close(FH);

    return run_cmd('LANG=C perl "-Iblib/lib" "-Iblib/arch" bin/file-similars --level=1 test');
}

my ($testid, $result0, $result1);

$testid = 0;
$result0="";

# ======================================================= &test_case ===

$result0="test/
test/TestLayout.java
test/GNU - Python Standard Library (2001).rar
test/PopupTest.java
test/CardLayoutTest.java
test/(eBook) GNU - Python Standard Library 2001.pdf
test/Python Standard Library.zip
test/GNU - 2001 - Python Standard Library.pdf
test/LayoutTest.java
";
$testid++;
print "\n== Testing $testid, test.tgz file content:\n\n$result0";
$result1=run_cmd('tar -xvzf test.tgz');
ok($result1,$result0) || print $result1;

# ======================================================= &test_case ===

$result1=dotest(2);

$result0="  9 test/(eBook) GNU - Python Standard Library 2001.pdf
  3 test/CardLayoutTest.java
  5 test/GNU - 2001 - Python Standard Library.pdf
  4 test/GNU - Python Standard Library (2001).rar
  9 test/LayoutTest.java
  3 test/PopupTest.java
  2 test/Python Standard Library.zip
  5 test/TestLayout.java
";
$testid++;
print "\n== Testing $testid, files under test/ subdir:\n\n$result0";
my $strs = run_cmd('find test -printf "%3s %p\n" | tail -n +2 | LANG=C sort -k 2');
ok($strs,$result0) || print $strs;

print "
Note:

- The file-similars script will pick out similar files from them in next test.
- Let's assume that the number represent the file size in KB.
";

# ======================================================= &test_case ===

$result0="
## =========
           3 'CardLayoutTest.java' 'test/'
           5 'TestLayout.java' 'test/'

## =========
           4 'GNU - Python Standard Library (2001).rar' 'test/'
           5 'GNU - 2001 - Python Standard Library.pdf' 'test/'
";
$testid++;
print "\n== Testing $testid result should be:\n$result0";
ok($result1,$result0) || print $result1;

print "
Note:

- There are 2 groups of similar files picked out by the script.
  The second group makes more sense.
- The similar files are picked because their file names look similar.
- However, the file size plays an important role as well.
- There are 2 files in the second similar files group.
- The file 'Python Standard Library.zip' is not considered to be similar to
  the group because its size is not similar to the group.
";

# ======================================================= &test_case ===

$result0="
## =========
           3 'CardLayoutTest.java' 'test/'
           5 'TestLayout.java' 'test/'

## =========
           4 'Python Standard Library.zip' 'test/'
           4 'GNU - Python Standard Library (2001).rar' 'test/'
           5 'GNU - 2001 - Python Standard Library.pdf' 'test/'
";
$testid++;
print "\n== Testing $testid, if Python.zip is bigger, result should be:\n$result0";
$result1=dotest(4);
ok($result1,$result0) || print $result1;

print "
Note:

- There are 3 files in the second similar files group.
- The file 'Python Standard Library.zip' is now in the 2nd similar files
  group because its size is now similar to the group.
";

# ======================================================= &test_case ===

$result0="
## =========
           3 'CardLayoutTest.java' 'test/'
           5 'TestLayout.java' 'test/'

## =========
           4 'GNU - Python Standard Library (2001).rar'       'test/'
           5 'GNU - 2001 - Python Standard Library.pdf'       'test/'
           6 'Python Standard Library.zip'                    'test/'
           9 '(eBook) GNU - Python Standard Library 2001.pdf' 'test/'
";
$testid++;
print "\n== Testing $testid, if Python.zip is even bigger, result should be:\n$result0";
$result1=dotest(6);
ok($result1,$result0) || print $result1;

print "
Note:

- There are 4 files in the second similar files group.
- The file 'Python Standard Library.zip' is still in the group.
- But this time, because it is also considered to be similar to the .pdf
  file (since their size are now similar, 6 vs 9), a 4th file the .pdf
  is now included in the 2nd group.
- If the size of file 'Python Standard Library.zip' is 12(KB), then the
  second similar files group will be split into two. Do you know why and
  which files each group will contain?
";

1;

# Test End
