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
        'result' => $scraper_input;
    result 'result';
};
my $res = $scraper->scrape($html);
my $key = "";
my $fields = "";
foreach (@$res) {
    if (defined($_->{'name'}) && $_->{'name'} eq 'data[_Token][key]') {
        $key = $_->{'value'};
    } elsif (defined($_->{'name'}) && $_->{'name'} eq 'data[_Token][fields]') {
        $fields = $_->{'value'};
    }
}

print "$key $fields"
