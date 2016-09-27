#!/usr/bin/env perl
#
#  Main authors:
#    Mats Carlsson <matsc@sics.se>
#
#  Contributing authors:
#    Roberto Castaneda Lozano <rcas@sics.se>
#
#  This file is part of Unison, see http://unison-code.github.io
#
#  Copyright (c) 2016, SICS Swedish ICT AB
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#  1. Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#  3. Neither the name of the copyright holder nor the names of its contributors
#     may be used to endorse or promote products derived from this software
#     without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
#  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.
#

# raw solver output -> proper JSON

use warnings;
use strict;

my $state = 1;
my $soln = 0;
my $proven = 0;
my @buf = ();

while (my $line = <STDIN>) {
    chomp($line);
    if ($line =~ "=====") {
	print STDERR "$line\n";
	$state = 1;
	$proven = 1;
    } elsif ($line =~ "--------") {
	$state = 2;
	$soln = 1;
    } elsif ($line =~ "%") {
	print STDERR "$line\n";
    } elsif ($state < 3) {
	$state = 3;
	@buf = ($line);
	print STDERR "$line\n";
    } else {
	push(@buf, $line);
    }
}
print("{\n");
foreach my $arg (@buf) {
    print "$arg,\n";
}
if ($soln) {
    print "\"has_solution\": true,\n";
} else {
    print "\"has_solution\": false,\n";
}
if ($proven) {
    print "\"proven\": true\n";
} else {
    print "\"proven\": false\n";
}
print("}\n");