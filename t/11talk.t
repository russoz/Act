use Test::More tests => 7;
use strict;
use Act::User;
use Act::Talk;
use t::Util;

# load some users
db_add_users();

my $user = Act::User->new( login => 'book' );
my ( $talks, $talk, $talk1, $talk2, $talk3 );

# manually insert a talk
my $sth = $Request{dbh}->prepare_cached("INSERT INTO talks (user_id,duration,lightning,accepted,confirmed) VALUES(?,?,?,?,?);");
$sth->execute( $user->user_id, 12, 'f', 'f', 'f' );
$sth->finish();

$sth = $Request{dbh}->prepare_cached("SELECT * from talks WHERE user_id=?");
$sth->execute( $user->user_id);
my $hash = $sth->fetchrow_hashref;
$sth->finish;

$talk1 = Act::Talk->new( talk_id => $hash->{talk_id} );
isa_ok( $talk1, 'Act::Talk' );
is_deeply( $talk1, $hash, "Can insert a talk" );

$talk = Act::Talk->new( foo => 'bar' );
use Data::Dumper;print Dumper $talk;
is_deeply( $talk, undef, "no talk with foo => 'bar'" );

$talk = Act::Talk->new();
isa_ok( $talk, 'Act::Talk' );
is_deeply( $talk, {}, "create empty talk with new()" );

# create a talk
$talk2 = Act::Talk->create(
   title     => 'test',
   user_id   => $user->user_id,
   duration  => 5,
   lightning => 'true',
   accepted  => '0',
   confirmed => 'false',
);
isa_ok( $talk2, 'Act::Talk' );

# talks are sorted by ids, which are incremental
$talks = $user->talks;
is_deeply( $talks, [ $talk1, $talk2 ], "Got the user's talk" );

# add another talk
$talk3 = Act::Talk->create(
   title     => 'test 2',
   user_id   => $user->user_id,
   duration  => 40,
   lightning => 'FALSE',
   accepted  => 'F',
   confirmed => 'F',
);

# search method
$talks = Act::Talk->get_talks( duration => 40 );
is_deeply( $talks, [ $talk3 ], "40 minute talks" );
$talks = Act::Talk->get_talks( lightning => 'TRUE' );
is_deeply( $talks, [ $talk2 ], "lightning talks" );

# this a Act::User method that encapsulate get_talks
$talks = $user->talks;
is_deeply( $talks, [ $talk, $talk2 ], "Got the user's talks" );

