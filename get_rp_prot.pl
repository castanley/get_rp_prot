#!/usr/bin/perl

use strict;
use warnings;

my %rp = (
    'c1' => 'xxx.xxx.xxx.xxx',
    'c2' => 'xxx.xxx.xxx.xxx',
);

my %report;

foreach my $c (sort keys %rp) {
    my $cmd = "./rp.exp " . $rp{$c};
    print "Executing: $cmd\n";
    $/ = undef;
    my $output = `$cmd`;
        $output =~ s/.*\nGroup://s;
        $output =~ s/\>//g;
        my @group = $output =~ m/\n  (\w+.*?)deduplication/sg;
        #use Data::Dumper;
        #print Dumper(@group), "\n";
        push @{$report{$c}}, @group;
}

foreach my $c (sort keys %report) {
        foreach my $record (@{$report{$c}}) {
                #print $record, "\n\n";
                my ($g,$p) = $record =~ /(\w+):.*Protection window:\s+Current:\s+Value: (.*?)\n/s;
                next unless $g and $p;
                printf "Cluster: %s, Group: %30s, Protection: %20s\n",$c,$g,$p;
        }
}
