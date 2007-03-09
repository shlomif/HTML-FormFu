package HTML::FormFu::Filter::TrimEdges;

use strict;
use warnings;
use base 'HTML::FormFu::Filter';

sub filter {
   my ( $self, $value ) = @_;
   
   $value =~ s/^\s+//;
   $value =~ s/\s+\z//;
   
   return $value;
}

1;

__END__

=head1 NAME

HTML::FormFu::Filter::TrimEdges - Trim whitespaces from beginning and
end of string

=head1 SYNOPSIS

   $form->filter( TrimEdges => 'foo' );

=head1 DESCRIPTION

Trim whitespaces from beginning and end of string.

=head1 AUTHOR

Mario Minati, C<mario@minati.de>

Based on the original source code of L<HTML::Widget::Filter::TrimEdges>, by
Sebastian Riedel, C<sri@oook.de>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it
under
the same terms as Perl itself.

=cut