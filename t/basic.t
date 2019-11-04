use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use MojoAPI::Model::Users;

my $t = Test::Mojo->new('MojoAPI', {database => ':temp:'});
#Register a user
$t->post_ok('/register' => json => {email => 'darek@123.pl'})
	->status_is(200)
	->json_has('/data/token')
	->json_has('/data/email');

my $registered_token = $t->tx->res->json('/data/token');

$t->post_ok('/register' => json => {email => 'darek@123.pl'})
  ->status_is(400)
	->json_is('/message', 'This email address is already registered');

#Register a user with a not email address
$t->post_ok('/register' => json => {email => 'darek.pl'})
  ->status_is(400)
	->json_is('/message', 'This email address is not valid');

#Register a user without email address
$t->post_ok('/register' => json => {})
  ->status_is(400)
	->json_is('/message', "An email address hasn't been passed");

#Get ip info without a bearer token
$t->get_ok('/ip_lookup/instant')
  ->status_is(400)
 	->json_is('/message', 'Something went wrong');

#Get ip info with a bearer token
$t->get_ok('/ip_lookup/instant' => {Authorization => 'Bearer ' . $registered_token})
  ->status_is(200);

#Get ip info with a wrong bearer token
$t->get_ok('/ip_lookup/instant' => {Authorization => 'Bearer 123'})
  ->status_is(400);

#Get ip info with a bearer token and wait 5 seconds
$t->get_ok('/ip_lookup/5' => {Authorization => 'Bearer ' . $registered_token})
  ->status_is(200);

#Get ip info with a wrong bearer token a wait 5 seconds
$t->get_ok('/ip_lookup/5' => {Authorization => 'Bearer 123'})
  ->status_is(400);

done_testing();
