#!!/usr/bin/perl

use strict;
use warnings;
use Web::Scraper;
use JSON;
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
        };
    result 'input';
};
my $scraper_textarea= scraper{
    process 'textarea',
        'textarea[]' => {
            'name' => '@name',
            'value' => 'TEXT',
        };
    result 'textarea';
};
my $scraper_image= scraper{
    process 'ul#ddItems figure img.itemImg',
        'image[]' => {
            'id' => '@data-file',
            'src' => '@src',
        };
    result 'image';
};
my $scraper= scraper{
    process 'form#additemform',
        'result' => {
            'input' => $scraper_input,
            'textarea' => $scraper_textarea,
            'image' => $scraper_image,
        };
    result 'result';
};
my $res = $scraper->scrape($html);
#print Dumper $res;
#exit;
my $form = {};
foreach my $input (@{$res->{input}}) {
    if (!defined($input->{name})) {
        next;
    }
    my $name = $input->{name};
    my $value = $input->{value};
    if ($name =~ m/\[(variation[^\]]*)\]\[([0-9]+)\]/) {
        my $variation_name = $1;
        my $variation_id = $2;
        $form->{$variation_name}->[$variation_id] = $value;
    } else {
        $form->{$name} = $value;
    }
}
foreach my $textarea (@{$res->{textarea}}) {
    if (!defined($textarea->{name})) {
        next;
    }
    my $name = $textarea->{name};
    my $value = $textarea->{value};
    $form->{$name} = $value;
}
my $order = 1;
foreach my $image (@{$res->{image}}) {
    if (!defined($image->{id}) || !defined($image->{src})) {
        next;
    }
    my $id = $image->{id};
    my $src = $image->{src};
    $form->{image}->[$order-1] = {
        'order' => $order,
        'id' => $id,
        'src' => $src,
    };
    $order++;
}

#print Dumper $form;
my $json_text = encode_json($form);
print $json_text;
