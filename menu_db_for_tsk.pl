/* <module> menu_db_for_tsk.pl
 *
 * @version 1809.003
 * @licence MIT
 * @copyright Wiserman & Partners
 * @author Thierry JAUNAY
 * @arg creadate 2018/09/30
 * @arg update 2018/10/01
 * @arg comment menu_db_for_tsk.pl - Data test sample for tsk.pl
 * @arg language SWI-Prolog
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

:- module(menu_db_for_tsk,[
              mx_choice_item/3,
              mx_label/2,
              mx_group/2,
              mx_parent/2] ).

% ----------------
% DATABASE EXAMPLE
% ----------------
%
% MX =  0 (reserved) list of menus
% MX = -1 (reserved)

% mx_choice_item(MX:Integer, Choice:Integer, Name:String)
% Menu database (0 and up)
% Negative menu numbers (reserved / please don't use)

% menu database

mx_choice_item(1, 0, "Back").
mx_choice_item(1, 1, "Option_1").
mx_choice_item(1, 2, "Option_2").
mx_choice_item(1, 3, "Option_3").

mx_choice_item(2, 0, "Back").
mx_choice_item(2, 1, "More1").

mx_choice_item(4, 0, "Inbox").
mx_choice_item(4, 1, "Today").
mx_choice_item(4, 2, "Tomorrow").
mx_choice_item(4, 3, "Someday").
mx_choice_item(4, 4, "Waiting").
mx_choice_item(4, 5, "Overdue").

% mx_label(+MX:Integer, +MenuLabel:String)
% Menu labels database

mx_label(-1, "Default_menu"). % (Reserved) default label
mx_label(0, "Menus").         % (Reserved) list of menus
mx_label(1, "Menu_1").
mx_label(2, "").              % Test default label
mx_label(3, "").
mx_label(4, "TASKS").

% group_mx(MX:integer, GroupName:string)
% Group links in between menus

mx_group(1, "TEST").
mx_group(2, "TEST").
mx_group(3, "TEST").
mx_group(4, "TASK").

% mx_parent(MX1:integer, MX2:integer)
% where MX1 is the parent menu of MX2
mx_parent(1, 2).

/* ********** END OF FILE ********** */































