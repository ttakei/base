#!!/usr/bin/perl

use strict;
use warnings;
use Web::Scraper;
use Data::Dumper;

my $html = "";
while (<STDIN>) {
  chomp;
  $html .= $_;
}

my $scraper_item= scraper{
    process 'li',
        'item[]' => {
            'id' => '@id',
            'img' => scraper{process
                'div.c-b img', 'val' => '@src'; result 'val';},
            'name' => scraper{process
                'div.c-c', 'val' => 'TEXT'; result 'val'},
            'price' => scraper{process
                'div.c-d', 'val' => 'TEXT'; result 'val'},
            'vol' => scraper{process
                'div.c-e', 'val' => 'TEXT'; result 'val'},
        };
    result 'item';
};
my $scraper= scraper{
    process '#itemlist',
        'item[]' => {
            'item' => $scraper_item,
        };
    result 'item';
};
my $res = $scraper->scrape($html);
print Dumper $res;
