-module(mynewproject_voter_controller, [Req]).
-compile(export_all).

before_(_) ->
    user_lib:require_login(Req).

list('GET', [], WardBoss) ->
    {ok, [{ward_boss, WardBoss}]}.

view('GET', [VoterId], WardBoss) ->
        Voter = boss_db:find(VoterId),
        {ok, [{voter, Voter}]}.

register('GET', [], WardBoss) ->
    {ok, []};
register('POST', [], WardBoss) ->
    Voter = voter:new(id, Req:post_param("first_name"), Req:post_param("last_name"),
        Req:post_param("address"), Req:post_param("notes"), WardBoss:id(), erlang:now()),
    case Voter:save() of
        {ok, SavedVoter} -> 
            {redirect, "/voter/view/"++SavedVoter:id()};
        {error, Errors} ->
           {ok, [{errors, Errors}, {voter, Voter}]}
    end.

rss('GET', []) ->
    Voters = boss_db:find(voter, []),
    {ok, [{voters, Voters}], [{"Content-Type", "application/rss+xml"}]}.

