package MojoAPI::Controller::Register;
use Mojo::Base 'Mojolicious::Controller';
use Email::Valid;

sub register {
  my $self = shift;

  if (($self->req->json) && (my $email = $self->req->json->{email})) {
    if(!$self->_validate_email($email)) {
      return $self->_return_error('This email address is not valid');
    }
    if($self->users->find_by_email($email)){
      return $self->_return_error('This email address is already registered');
    }
    my $user_id = $self->users->create($email);
    my $user = $self->users->find($user_id);
    return $self->_return_success('Email added', $self->_serialize($user));
  }
  return $self->_return_error("An email address hasn't been passed");
}

sub _validate_email {
  my ($self, $email) = @_;
  return Email::Valid->address($email);
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

sub _serialize {
  my ($self, $user) = @_;
  return {
    email => $user->{email},
    token => $user->{token},
  };
}

1;
