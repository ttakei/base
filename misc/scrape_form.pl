#!!/usr/bin/perl

use strict;
use warnings;
use Web::Scraper;
use URI;
use Data::Dumper;

if (@ARGV < 1) {
  print STDERR "usage $0 <url>", "\n";
  exit 1;
}

my $url = shift;
my $uri_obj = URI->new($url);
my $scraper_input= scraper{
    process 'input',
        'input[]' => {
            'name' => '@name',
            'value' => '@value',
            'type' => '@type',
        };
    result 'input';
};
my $scraper= scraper{
    process 'form',
        'result[]' => {
            'action' => '@action',
            'method' => '@method',
            'id' => '@id',
            'name' => '@name',
            'input' => $scraper_input,
        };
    result 'result';
};
my $res = $scraper->scrape($uri_obj);
print Dumper $res;
