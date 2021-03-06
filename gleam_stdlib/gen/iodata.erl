-module(iodata).
-compile(no_auto_import).
-include_lib("eunit/include/eunit.hrl").

-export([prepend/2, append/2, concat/1, new/1, to_string/1, byte_size/1, lowercase/1, uppercase/1, reverse/1, split/2, replace/3, is_equal/2, is_empty/1]).

prepend(A, B) ->
    gleam__stdlib:iodata_prepend(A, B).

append(A, B) ->
    gleam__stdlib:iodata_append(A, B).

concat(A) ->
    gleam__stdlib:identity(A).

new(A) ->
    gleam__stdlib:identity(A).

to_string(A) ->
    erlang:iolist_to_binary(A).

byte_size(A) ->
    erlang:iolist_size(A).

-ifdef(TEST).
iodata_test() ->
    Iodata = prepend(append(append(new(<<"ello">>), <<",">>), <<" world!">>),
                     <<"H">>),
    expect:equal(to_string(Iodata), <<"Hello, world!">>),
    expect:equal(byte_size(Iodata), 13).
-endif.

lowercase(A) ->
    string:lowercase(A).

-ifdef(TEST).
lowercase_test() ->
    expect:equal(to_string(lowercase(concat([<<"Gleam">>, <<"Gleam">>]))),
                 <<"gleamgleam">>).
-endif.

uppercase(A) ->
    string:uppercase(A).

-ifdef(TEST).
uppercase_test() ->
    expect:equal(to_string(uppercase(concat([<<"Gleam">>, <<"Gleam">>]))),
                 <<"GLEAMGLEAM">>).
-endif.

reverse(A) ->
    string:reverse(A).

erl_split(A, B, C) ->
    string:split(A, B, C).

split(Iodata, On) ->
    erl_split(Iodata, On, all).

-ifdef(TEST).
split_test() ->
    expect:equal(split(new(<<"Gleam,Erlang,Elixir">>), <<",">>),
                 [new(<<"Gleam">>), new(<<"Erlang">>), new(<<"Elixir">>)]),
    expect:equal(split(concat([<<"Gleam, Erl">>, <<"ang,Elixir">>]), <<", ">>),
                 [new(<<"Gleam">>), concat([<<"Erl">>, <<"ang,Elixir">>])]).
-endif.

erl_replace(A, B, C, D) ->
    string:replace(A, B, C, D).

replace(Iodata, Pattern, Replacement) ->
    erl_replace(Iodata, Pattern, Replacement, all).

is_equal(A, B) ->
    string:equal(A, B).

-ifdef(TEST).
is_equal_test() ->
    expect:true(is_equal(new(<<"12">>), concat([<<"1">>, <<"2">>]))),
    expect:true(is_equal(new(<<"12">>), new(<<"12">>))),
    expect:false(is_equal(new(<<"12">>), new(<<"2">>))).
-endif.

is_empty(A) ->
    string:is_empty(A).

-ifdef(TEST).
is_empty_test() ->
    expect:true(is_empty(new(<<"">>))),
    expect:false(is_empty(new(<<"12">>))),
    expect:true(is_empty(concat([]))),
    expect:true(is_empty(concat([<<"">>, <<"">>]))).
-endif.
