/*
 * tsk.pl
 *
 * Task management toolbox to do it just with text files,
 * hashtags and line menus.
 *
 * @version 1809.002
 * @licence MIT
 * @copyright Wiserman & Partners
 * @author Thierry JAUNAY
 * @arg creadate 2018/08/25
 * @arg update 2018/09/30
 * @arg comment tsk.pl - Task management toobox
 * @arg language SWI-Prolog
 *
 * ----------
 *
 * Use =
 * -
 * -
 * -
 * - use go_tsk/0
 *
 * Tools = check in the Tools part
 *
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

% --------------
% MODULES & DATA
% --------------

% toolbox for herein used predicates
:- use_module(toolbox, [
               get_char_1/1,
               if_empty_default/3,
               list_to_string/2,
               print_matrix/1 ] ).

% menus management
:- [menu_db_for_tsk].
:- use_module(menu_db).

%
% OPEN FILES
% ----------
%

%
% CHECK HASHTAGS
% --------------
%

% SANDBOX

go :-
    edit('test.txt').

/*
 * /* get the wd */
?- working_directory(X, X).
X = 'c:/users/user/documents/prolog/'.

/* set the wd */
?- working_directory(_, 'c:/users/user/desktop').
true.

?- absolute_file_name('text.txt', X, [mode(read)]).
X = 'c:/users/user/desktop/text.txt'
*/



/* ********** END OF FILE ********** */






