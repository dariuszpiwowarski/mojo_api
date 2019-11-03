package MojoAPI;
use Mojo::Base 'Mojolicious';

use Mojo::SQLite;
use MojoAPI::Model::Users;
use Mojo::Util qw(dumper);

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by config file
  my $config = $self->plugin('Config');

  $self->plugin('RemoteAddr');

  # Configure the application
  $self->secrets($config->{secrets});

  # Model
  $self->helper(sqlite => sub { state $sql = Mojo::SQLite->new->from_filename(shift->config('sqlite')) });
  $self->helper(users => sub { state $posts = MojoAPI::Model::Users->new(sqlite => shift->sqlite) });

  # Migrations
  my $path = $self->home->child('migrations', 'users.sql');
  $self->sqlite->auto_migrate(1)->migrations->name('users')->from_file($path);

  # Router
  my $r = $self->routes;

  $r->post('/register')->to('register#register')->name('register');
  $r->get('/ip_lookup/instant')->to('IPlookup#instant')->name('instant ip lookup');
  $r->get('/ip_lookup/:wait')->to('IPlookup#wait', wait => 0)->name('ip lookup with wait');
}

1;
