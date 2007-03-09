use strict;
use warnings;
use YAML::Syck qw( LoadFile );

use Test::More tests => 7;

use HTML::FormFu;

my $form = HTML::FormFu->new->action('/foo/bar')->id('form')->auto_id('%n');

my $fs = $form->element('fieldset')->legend('Jimi');

$fs->element('text')->name('age')->label('Age')->comment('x')
    ->constraints( [ 'Integer', 'Required', ] );

$fs->element('text')->name('name')->label('Name');
$fs->element('hidden')->name('ok')->value('OK');

$form->constraints({
    type => 'Required',
    name => 'name',
    });

$form->filter('HTMLEscape');

# hash-ref

my $alt_hash = {
    action    => '/foo/bar',
    id        => 'form',
    auto_id => '%n',
    elements  => [ {
            type => 'fieldset',
            legend   => 'Jimi',
            elements => [ 
                    { type => 'text',
                      name =>     'age',
                      label       => 'Age',
                      comment     => 'x',
                      constraints => [ 'Integer', 'Required', ],
                      },
                    { type => 'text', name => 'name', label => 'Name', },
                    { type => 'hidden', name => 'ok', value => 'OK', },
                ],
        } ],
    constraints => {
        type => 'Required',
        name => 'name',
        },
    filters => ['HTMLEscape'],
};

# hash-ref from yaml

my $yml_hash = LoadFile('t/04basic.yml');

# compare hash-refs

is_deeply( $yml_hash, $alt_hash );

# xhtml output

my $alt_form = HTML::FormFu->new($alt_hash);
my $yml_form = HTML::FormFu->new->load_config_file('t/04basic.yml');

my $xhtml = <<EOF;
<form action="/foo/bar" id="form" method="post">
<fieldset>
<legend>Jimi</legend>
<span class="text comment label">
<label for="age">Age</label>
<input name="age" type="text" id="age" />
<span class="comment">
x
</span>
</span>
<span class="text label">
<label for="name">Name</label>
<input name="name" type="text" id="name" />
</span>
<input name="ok" type="hidden" value="OK" id="ok" />
</fieldset>
</form>
EOF

is( "$form",     $xhtml );
is( "$alt_form", $xhtml );
is( "$yml_form", $xhtml );

# With mocked basic query
{
    $form->process( {
            age  => 'a',
            name => 'sri',
        } );

    ok( $form->valid('name'), 'name is valid' );
    ok( !$form->valid('age'), 'age is not valid' );

    my $errors = $form->errors;

    is( @$errors, 1 );
}