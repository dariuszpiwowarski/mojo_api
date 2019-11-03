package MojoAPI::Controller::IPlookup;
use Mojo::Base 'Mojolicious::Controller';
use MojoAPI::Client::IpAPI;
use Mojo::Log;

sub instant {
  my $self = shift;

  if($self->_check_auth) {
    my $ip = $self->remote_addr;
    my $ip_API_client = new MojoAPI::Client::IpAPI($ip);

    $ip_API_client->getInfo()->then(sub {
        my $ip_info = shift;
        return $self->_return_success('', $ip_info->res->json);
      })->catch(sub {
        my $err = shift;
        return $self->_return_error($err);
      })->wait;
  } else {
    return $self->_return_error('Something went wrong');
  }
}

sub wait {
  my $self = shift;

  if($self->_check_auth) {
    my $ip = $self->remote_addr;
    my $ip_API_client = new MojoAPI::Client::IpAPI($ip);
    my $delay = $self->param('wait');

    $ip_API_client->getInfo()->then(sub {
        my $ip_info = shift;
        Mojo::IOLoop->timer($delay => sub {
            return $self->_return_success('', $ip_info->res->json);
          });
        Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
      })->catch(sub {
        my $err = shift;
        return $self->_return_error($err);
      })->wait;
  } else {
    return $self->_return_error('Something went wrong');
  }
}

sub _check_auth {
  my $self = shift;

  my $auth_header = $self->req->headers->authorization;
  if ($auth_header =~ /Bearer\ (.*)$/){
    my $bearer_token = $1;
    if (my $user = $self->users->find_by_token($bearer_token)) {
      $self->_log('User ' . $user->{email} . ' authenticated');
      return 1;
    };
  }
}

sub _log {
  my $self = shift;
  my $message = shift;

  my $log = Mojo::Log->new(path => './logs/mojo.log');
  $log->info($message);
}

sub _return_error {
  my $self = shift;
  my $message = shift;

  return $self->render(json => {status => 'error', message => $message}, status => 400);
}

sub _return_success {
  my $self = shift;
  my $message = shift;
  my $data = shift;

  return $self->render(json => {status => 'success', message => $message, data => $data});
}

1;
