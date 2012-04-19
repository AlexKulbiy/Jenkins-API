package Jenkins::API;

use Moose;
use Jenkins::API::ConfigBuilder;
use URI::Encode;

=head1 NAME

Jenkins::API - A wrapper around the Jenkins API

=head1 VERSION

Version 0.01

=head1 METHODS

=cut

our $VERSION = '0.01';

has '_client' => (is => 'ro', default => sub {
    require REST::Client;
    REST::Client->new();
});
has base_url => (is => 'ro', isa => 'Str', required => 1);

=head1 SYNOPSIS

This is a wrapper around the Jenkins API.

    use Jenkins::API;

    my $jenkins = Jenkins::API->new({ base_url => 'http://jenkins:8080' });
    my $success = $jenkins->create_job($config_xml);
    ...

=head2 create_job

    my $success = $api->create_job($config_xml);

=cut

sub create_job
{
    my ($self, $name, $job_config) = @_;

    my $uri = URI::Encode->new({ encode_reserved => 1 });
    my $safe_name = $uri->encode($name);
    # curl -XPOST http://moe:8080/createItem?name=test -d@config.xml -v -H Content-Type:text/xml
    $self->_client->POST($self->base_url . '/createItem?name=' . $safe_name, $job_config, { 'Content-Type' => 'text/xml' });
    return $self->_client->responseCode() eq '200';
}

=head2 create_job_simple

    $self->create_job_simple(
    );

=cut

sub create_job_simple
{
    my ($self, $name, $args) = @_;

    my $cb = Jenkins::API::ConfigBuilder->new();
    my $xml = $cb->to_xml($args);
    return $self->create_job($name, $xml);
}

=head1 AUTHOR

Colin Newell, C<< <colin.newell at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-jenkins-api at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Jenkins-API>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Jenkins::API


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Jenkins-API>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Jenkins-API>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Jenkins-API>

=item * Search CPAN

L<http://search.cpan.org/dist/Jenkins-API/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Colin Newell.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Jenkins::API

