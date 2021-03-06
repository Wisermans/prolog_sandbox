/* <module> menu_db.pl
 *
 * based on a referential mx_choice_item/3
 * (+MX:Integer, +Choice:Integer, +Name:String)
 *
 * to provide a simple selection with menu number + choice
 * in two ways : numerical or hashtag.
 *
 * @version 1809.055
 * @licence MIT
 * @copyright Wiserman & Partners
 * @author Thierry JAUNAY
 * @arg creadate 2018/08/05
 * @arg update 2018/10/01
 * @arg comment menu_db.pl - Menu management
 * @arg language SWI-Prolog
 *
 * ----------
 * Thx to Paul Brown (@PaulBrownMagic) for his initial contribution
 * from my spaghetti coding to his Prolog fluent coding.
 *
 * Thx to Anne OGBORN (@AnnieTheObscure) for her patience and'),
 * great advices making me write a much better Prolog style code.
 *
 * ----------
 * Use =
 * - create the menu database (for example menu_db_x)
 * - create do_it/2 for menu choices
 * - use go/0 or ask_menu/1 or do_it/2 versions depending on needs
 *
 * Also added some useful "Internal Tools"
 * ----------
 *
 * Copyright (c) 2018, Wiserman & Partners
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

% ----------------
% MODULES AND DATA
% ----------------

% menu_db module

:- module(menu_db,[
    % cache management
        retract_cached_mx/1,
     % internal tools
        mxw/3,
        mxwc/1,
        mxw_/1,
        exist_mx/1,
        cached_exist_mx/1,
    % menu_db program
        cached_make_menu/2,
        do_it/2,
        check_menu/2,
        ask_menu/1,
    % test
        mx_test/1 ] ).

% toolbox module for predicates

:- use_module('toolbox', [
               cls/0,
               get_char_1/1,
               if_empty_default/3,
               known/3,
               list_to_string/2,
               print_matrix/1 ]
             ).

% load menu_db_msg

:- [menu_db_msg].

% menu_db settings
% ----------------

% Chosen design : [Menu_1] 0=Back,1=Option_1,2=Option_2,3=Option_3.
:- setting(mx_label_prefix, atom, '[', "menu label prefix").
:- setting(mx_label_suffix, atom, '] ', "menu label suffix").
:- setting(mx_subpart_suffix, atom, ',', "menu subpart suffix").
:- setting(mx_subpart_last_suffix, atom, '.', "menu subpart last suffix").

% Example of alternative template for menu UI
% <Menu_1>|0=Back|1=Option_1|2=Option_2|3=Option_3|
%
% :- setting(mx_label_prefix, atom, '<', "menu label prefix").
% :- setting(mx_label_suffix, atom, '>|', "menu label suffix").
% :- setting(mx_subpart_suffix, atom, '|', "menu subpart suffix").
% :- setting(mx_subpart_last_suffix, atom, '|', "menu subpart last suffix").

:- setting(mx_ext_char, char, '#', "extended menu prefix char").
:- setting(mx_exit_char, char, '.', "menu exit char").

:- load_settings('settings.db').

% ----------
% VOCABULARY
% ----------
% to gain time reading the code ...

% MX:integer = menu number
% MenuX:string = menu numbered MX
% MenuLabel:string = name of the menu
% Separator:char = char in between label and menu
% Str:string = temp variables used for strings
% Subparts:list = list of menu subparts
% UserChoice:char = menu choice selected by user
%    C:integer = when specifically an integer choice
%
% Acronyms
% --------
% mxw stands for mx write

% -----------------
% RIGHTS MANAGEMENT
% -----------------

% etc. ... @tbd later

% --------
% MX TOOLS
% --------
% Misc internal tools for menu_db

% mxw/3
% (+MX:integer, +Choice:integer, +Item:string)
% Test tool to quickly display mx_choice_item/3

mxw(MX, Choice, Item) :-
    findall([MX, Choice, Item], mx_choice_item(MX, Choice, Item), MXs),
    mxw_(MXs).

% mxwc/1
% (+MX:integer)
% Write all in cache about menu number MX

mxwc(MX) :-
    findall([X, MX, MenuX], known(X, MX, MenuX), Xs),
    mxw_(Xs).

% mxw_/1
% ([A|Rest]:list)
% Print list or error message if empty

mxw_([H|T]) :-
    print_matrix([H|T]).
mxw_([]) :-
    nl, print_message(error, no_item),
    !, fail.

% retract_cached_mx/1
% (+MX:integer)
% Purge cache from elements about menu number MX

retract_cached_mx(MX) :-
    % retract cached menu string
        retract(known(menux, MX, _)),
    % retract cached list of standard choices
        retract(known(mx_std_choices, MX, _)).

% exist_mx/1 is semidet
% (+MX:integer)
% Check if menu number is valid
% true if MX found once / false otherwise
% @tbd error messages

exist_mx(MX) :-
    mx_choice_item(MX, _, _),
    !.

cached_exist_mx(MX) :-
    known(menux, MX, _),
    !.

% ------
% LABELS
% ------

% make_menu_label/2
% (+MX:integer, -MenuLabel:atom)

make_menu_label(MX, MenuLabel) :-
% Make MenuLabel including suffix separator
    % Replace menu label by default one if empty
        mx_label(MX, MenuLabel1),
        mx_label(-1, Default),
        if_empty_default(MenuLabel1, Default, MenuLabel2),
    % Grabs prefix and suffix from settings
        setting(mx_label_prefix, Prefix),
        setting(mx_label_suffix, Suffix),
    % Make MenuLabel with Prefix and Suffix
        format(atom(MenuLabel), "~w~w~w", [Prefix, MenuLabel2, Suffix]).

% ------------
% MAKING MENUS
% ------------
% PS: I could add horizontal / vertical display options
% but the idea is more to get a help style menu fitting on one line

% make_menu_list/2
% (+MX:integer, -Xs:list)
% Extract from mx_choice_item/3 the list XS of [X|Y] menu items
% where X is the choice and Y the menu item name
% Error if Xs is empty (no menu item)

make_menu_list(MX, Xs) :-
    findall([X, Y], mx_choice_item(MX, X, Y), Xs),
    make_menu_list_(Xs).

make_menu_list_([]) :-
    nl, print_message(warning, no_item),
    !, fail.

make_menu_list_(_).

% format_subparts/2
% (+XS:list, -Subparts:list)
% Put menu list into subparts ['0=Back ', '1=Option '] ready for
% joining ++ Thx to @PaulBrownMagic
% PS: added suffix separator from settings in spite of just space

format_subparts([], []) :- !.
% base case with empty lists

format_subparts([], _) :- !.
% no more subpart assembly to do

format_subparts([X|''], [SubpartHead|SubpartTrail]) :-
     % concatenates menu choice and name from X to A
         format(atom(A), "~w=~w", X),
     % concat Str and last Suffix to do SubpartHead
         setting(mx_subpart_last_suffix, Suffix),
         atom_concat(A, Suffix, SubpartHead),
     % recursion with the trail
         format_subparts(_, SubpartTrail).

format_subparts([X|Xs], [SubpartHead|SubpartTrail]) :-
     % concatenates menu choice and name from X to A
         format(atom(A), "~w=~w", X),
     % concat Str and Suffix to do SubpartHead
         setting(mx_subpart_suffix, Suffix),
         atom_concat(A, Suffix, SubpartHead),
      % recursion with the trail
         format_subparts(Xs, SubpartTrail).

% make_menu/2
% (+MX:integer, -MenuX:string)
% Check = fail if no number for the menu
% Make MenuX as a string = Label + Separator + Subparts
% Check = fail if no number for the menu

make_menu(MX, _) :-
    \+ exist_mx(MX),
    print_message(error, menu_not_found(MX)),
    !, fail.

make_menu(MX, MenuX) :-
    % extract subparts needed to build the menu string + check OK
        make_menu_list(MX, Xs),
    % extract menu label (replace by defaut if none)
        make_menu_label(MX, MenuLabel),
    % build the list of items ready for joining
        format_subparts(Xs, Subparts),
    % make the menu line MenuX
        list_to_string([MenuLabel|Subparts], MenuX).

% cached_make_menu/2
% (+MX:integer, -MenuX:string)
% Caching optimization on MenuX string
% Check = false if no number for the menu

cached_make_menu(MX, MenuX) :-
    known(menux, MX, MenuX),
    !.

cached_make_menu(MX, MenuX) :-
    make_menu(MX, MenuX),
    assertz(known(menux, MX, MenuX)).

% -----
% DO_IT
% -----
% Program execution based on menu selection by user
% = to adapt depending on program needs

do_it(MX, _) :-
    \+ exist_mx(MX),
    print_message(error, menu_not_found(MX)),
    !, fail.

do_it(MX, UserChoice) :-
    nl, writeln('TBD - replace by real do_it/2'),
    format("(Menu: ~w / Choice: ~w)~n~n", [MX, UserChoice]).

% ---------------------
% MANAGING MENU CHOICES
% ---------------------
% Check choices / errors before launching do_it

% make_std_choices/2
% (MX:integer, Choices:list)
% Make the list of valid Choices for menu number MX

make_std_choices(MX, _) :-
    \+ exist_mx(MX),
    print_message(error, menu_not_found(MX)),
    !, fail.

make_std_choices(MX, Choices) :-
    findall(Choice, mx_choice_item(MX, Choice, _), Choices).

% cached_std_choices/2
% (MX:integer, Choices:list)
% Caching optimization on Choices list
% Known or added to be known

cached_std_choices(MX, Choices) :-
    known(mx_std_choices, MX, Choices),
    !.

cached_std_choices(MX, Choices) :-
    make_std_choices(MX, Choices),
    assertz(known(mx_std_choices, MX, Choices)).

% is_std_choice/2
% (MX:integer, C:integer)
% Check if C is a valid menu standard choice

is_std_choice(MX, C) :-
    % true if C appears once
    cached_std_choices(MX, Choices),
    member(C, Choices),
    !.

% mx_choice_error/1
% (UserChoice:Char) can be either num or alpha
% Display the error message on num or alpha menu choice error

mx_choice_error(UserChoice) :-
% error message on bad num menu choice
    number(UserChoice),
    !,
    print_message(error, bad_num_choice(UserChoice)),
    print_message(warning, chose_again).

mx_choice_error(UserChoice) :-
% error message on bad alpha menu choice
    print_message(error, bad_ext_choice(UserChoice)),
    print_message(warning, chose_again).

% check_menu/2
% (MX:integer, UserChoice:char)
% Check choices exit / standard / extended / others
% Manage errors

check_menu(_, UserChoice) :-
% if mx_exit_char then exit
    setting(mx_exit_char, UserChoice),
    !.

check_menu(MX, UserChoice) :-
% if extended menu choice then stop searching and do it
    setting(mx_ext_char, UserChoice),
    !,
    do_it(MX, UserChoice).

check_menu(MX, UserChoice) :-
% if num choice and valid then stop searching and do it
    atom_number(UserChoice, C),
    is_std_choice(MX, C),
    !,
    do_it(MX, C).

check_menu(MX, UserChoice) :-
% if num choice and not valid choice
% then error message, stop searching and fail to repeat
    atom_number(UserChoice, C),
    \+ is_std_choice(MX, C),
    mx_choice_error(C),
    !, fail.

check_menu(_, UserChoice) :-
% Latest check ending by a bad choice
% as neither exit or std choice or extended
% then error message, stop searching and fail to repeat
    mx_choice_error(UserChoice),
    !, fail.

% ---------
% GO / MENU
% ---------
% Launch program with go/0 or ask_menu/1

% write_menu/1
% (MX:integer)
% Display menu number MX, ask / control and launch choices

write_menu(MX) :-
    cached_make_menu(MX, MenuX),
    write(MenuX).

% ask_menu/1
% (MX:integer)
% Display menu number MX, ask / control and launch choices

ask_menu(MX) :-
% check MX validity
    \+ exist_mx(MX),
    print_message(error, menu_not_found(MX)),
    !, fail.

ask_menu(MX) :-
% make, check and display menu
    write_menu(MX),
% ask choice and repeat until valid choice
    nl, print_message(information, what_choice),
    repeat,
    (   get_char_1(UserChoice),
        check_menu(MX, UserChoice),
        ! )
    ; !.

go :-
    cls,
    ask_menu(1).

% ---------------
% TEST CHECK-LIST
% ---------------

%% Typical choices to test with mx_test/2 and ask_menu/2,
% once menu_db_for_test loaded :
%
% MX = 1 / num choice 1 (all is fine)
% MX = 1 / num choice 5 (not existing choice)
% MX = 1 / ext choice = # (alpha extended choice)
% MX = 1 / ext choice = a (non existing alpha extended choice)
% MX = 3 (non existing menu = with label but no items)
%

mx_test(MX) :-
    cls,
    ask_menu(MX).

/* ********** END OF FILE ********** */
































