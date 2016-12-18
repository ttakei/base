#!!/usr/bin/perl

use strict;
use warnings;
use Web::Scraper;
use Data::Dumper;

binmode STDIN,  ":utf8";

my $html = "";
while (<STDIN>) {
  chomp;
  $html .= $_;
}

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
my $res = $scraper->scrape($html);
print Dumper $res;
