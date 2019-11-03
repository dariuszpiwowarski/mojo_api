package MojoAPI::Client::IpAPI;
use Mojo::UserAgent;
use Mojo::Promise;

my $ua = Mojo::UserAgent->new;

sub new {
	my ($class, $ip) = @_;
	my $self = {
		address => 'http://ip-api.com/json/' . $ip,
	};
	bless $self, $class;
	return $self;
}

sub getInfo {
	my $self = shift;
  my $promise = Mojo::Promise->new;
  $ua->get($self->{address} => sub {
    my ($ua, $tx) = @_;
    my $err = $tx->error;
    if   (!$err || $err->{code}) { $promise->resolve($tx) }
    else                         { $promise->reject($err->{message}) }
  });
  return $promise;
}

1;
