#!!/usr/bin/perl

use strict;
use warnings;
use Web::Scraper;
use URI;
use Data::Dumper;

my $url = 'https://admin.thebase.in/users/login';
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
    process 'form#userLoginForm',
        'result' => $scraper_input;
    result 'result';
};
my $res = $scraper->scrape($uri_obj);
# print Dumper $res;
foreach (@$res) {
    if ($_->{'name'} eq 'data[_Token][key]') {
        print $_->{'value'};
        exit;
    }
}
