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
  return $ua->get_p($self->{address});
}

1;
