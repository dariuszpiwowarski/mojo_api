package MojoAPI::Model::Users;
use Mojo::Base -base;

has 'sqlite';

sub create {
  my ($self, $email) = @_;

  return $self->sqlite->db->insert('users', {
      email => $email, 
      token => $self->_generate_token() 
    })->last_insert_id;
}

sub all { shift->sqlite->db->select('users')->hashes->to_array }

sub find_by_email {
  my ($self, $email) = @_;
  return $self->sqlite->db->select('users', undef, {email => $email})->hash;
}

sub find_by_token {
  my ($self, $token) = @_;
  return $self->sqlite->db->select('users', undef, {token => $token})->hash;
}

sub find {
  my ($self, $id) = @_;
  return $self->sqlite->db->select('users', undef, {id => $id})->hash;
}

sub _generate_token {
  my $self = shift;
  my @chars = ("A".."Z", "a".."z", 0..9);
  my $token;
  $token .= $chars[rand @chars] for 1..20;
  return $token;
}

1;
