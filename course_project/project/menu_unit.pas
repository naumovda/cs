unit menu_unit;

interface

uses
  dateutils,   //функции работы с датой и временем
  common_unit, //общие типы данных и подпрограммы
  log_unit     //модуль логирования
  ;

type
  //процедурный тип для действия пункта меню
  TMenuAction = procedure;

  //структура данных для отображения меню
  TMenu = record
    Prompt: TName; //приглашение ко вводу
    Multiselect: boolean; //возможность выбора нескольких пунктов
    Items: array of TName; //список пунктов меню
    Actions: array of TMenuAction; //список действий
    Selection: integer; //выбранный пункт меню
  end;

  //инициализация меню
  procedure InitMenu(var Menu: TMenu);

  //отображение меню
  procedure ShowMenu(const Menu: TMenu);

  //выполнение диалога с пользователем
  procedure DoDialogMenu(var Menu:TMenu);

  //прохождение тестирования
  procedure UserMenuTesting();

  //просмотр статистики
  procedure UserMenuStatistic;

  //сформировать отчет
  procedure UserMenuReport;

  //сменить пароль
  procedure UserMenuChangePassword;

  //добавить пользователя
  procedure AdminMenuAddUser;

  //удаление пользователя
  procedure AdminMenuDelUser;

  //изменение пароля пользователя
  procedure AdminMenuChangeUserPassword;

  //изменение пароля администратора
  procedure AdminMenuChangeAdminPassword;

  //загрузка (подключение) теста в систему
  procedure AdminMenuLoadTest;

  //выгрузка (удаление) теста из подсистемы
  procedure AdminMenuUnloadTest;

  //просомтр статистики
  procedure AdminMenuViewStatistic;

  //формирование отчета
  procedure AdminMenuViewReport;

  //инициализация меню пользователя
  procedure InitUserMenu(var Menu: TMenu);

  //инициализация меню админитратора
  procedure InitAdminMenu(var Menu: TMenu);


implementation

//инициализация меню
//  входные данные:
//    Menu: TMenu - отображаемые меню
//  выходные данные:
//    нет
procedure InitMenu(var Menu: TMenu);
begin
  Menu.Selection := -1;
end;

//отображение меню
//  входные данные:
//    Menu: TMenu - отображаемые меню
//  выходные данные:
//    нет
procedure ShowMenu(const Menu: TMenu);
var
  i: integer;
begin
  writeln(Menu.Prompt);

  for i := Low(Menu.Items) to High(Menu.Items) do
  begin
    if i = Menu.Selection then
      write('[X][', i, '] -')
    else
      write('[ ][', i, '] -');
    writeln(Menu.Items[i]);
  end;

  writeln('p - выход');
  writeln('q - завершение работы');
  write('>');
end;

//выполнение диалога с пользователем
//  входные данные:
//    Menu: TMenu - отображаемые меню
//  выходные данные:
//    нет
procedure DoDialogMenu(var Menu:TMenu);
var
  UserInput: string;
  Selection, ErrorCode: byte;
begin
  repeat
    ShowMenu(Menu);

    readln(UserInput);

    if UserInput = 'p' then //выход в меню верхнего уровня
      exit
    else
      begin
        //определяем ввод пользователя
        Val(UserInput, Selection, ErrorCode);

        if ErrorCode = 0 then
          Menu.Actions[Selection](); //вызываем действие
      end;
  until false;
end;

//прохождение тестирования
//  входные данные: нет
//  выходные данные: нет
procedure UserMenuTesting();
begin
  //#заглушка
  writeln('--прохождение тестирования--');
end;

//просмотр статистики
//  входные данные: нет
//  выходные данные: нет
procedure UserMenuStatistic;
begin
  //#заглушка
  writeln('--просмотр статистики--');
end;

//сформировать отчет
//  входные данные: нет
//  выходные данные: нет
procedure UserMenuReport;
begin
  //#заглушка
  writeln('--формирование отчета--');
end;

//сменить пароль
//  входные данные: нет
//  выходные данные: нет
procedure UserMenuChangePassword;
begin
  //#заглушка
  writeln('--сменить пароль пользователя--');
end;

//добавить пользователя
//  входные данные: нет
//  выходные данные: нет
procedure AdminMenuAddUser;
begin
  //#заглушка
  writeln('--добавление пользователя--');
end;

//удаление пользователя
//  входные данные: нет
//  выходные данные: нет
procedure AdminMenuDelUser;
begin
  //#заглушка
  writeln('--удаление пользователя--');
end;

//изменение пароля пользователя
//  входные данные: нет
//  выходные данные: нет
procedure AdminMenuChangeUserPassword;
begin
  //#заглушка
  writeln('--смена пароля пользователя--');
end;

//изменение пароля администратора
//  входные данные: нет
//  выходные данные: нет
procedure AdminMenuChangeAdminPassword;
begin
  //#заглушка
  writeln('--смена пароля администратора--');
end;

//загрузка (подключение) теста в систему
//  входные данные: нет
//  выходные данные: нет
procedure AdminMenuLoadTest;
begin
  //#заглушка
  writeln('--загрузка теста--');
end;

//выгрузка (удаление) теста из подсистемы
//  входные данные: нет
//  выходные данные: нет
procedure AdminMenuUnloadTest;
begin
  //#заглушка
  writeln('--выгрузка теста--');
end;

//просомтр статистики
//  входные данные: нет
//  выходные данные: нет
procedure AdminMenuViewStatistic;
begin
  //#заглушка
  writeln('--просмотр статистики--');
end;

//формирование отчета
//  входные данные: нет
//  выходные данные: нет
procedure AdminMenuViewReport;
begin
  //#заглушка
  writeln('--просмотр отчета--');
end;

//инициализация меню пользователя
//  входные данные: нет
//  выходные данные:
//    Menu: TMenu - инициализируемое меню
procedure InitUserMenu(var Menu: TMenu);
begin
  Menu.Prompt:= 'Выберите пункт меню:';

  //пункты меню пользователя:
  // 0 - пройти тестирование
  // 1 - посмотреть статистику
  // 2 - сформировать отчет
  // 3 - сменить пароль
  SetLength(Menu.Items, 4);
  Menu.Items[0] := 'Пройти тестирование';
  Menu.Items[1] := 'Просмотр статистики';
  Menu.Items[2] := 'Сформировать отчет';
  Menu.Items[3] := 'Сменить пароль';

  SetLength(Menu.Actions, 4);
  Menu.Actions[0] := @UserMenuTesting;
  Menu.Actions[1] := @UserMenuStatistic;
  Menu.Actions[2] := @UserMenuReport;
  Menu.Actions[3] := @UserMenuChangePassword;

  Menu.Multiselect := false;
  Menu.Selection := -1;
end;

//инициализация меню админитратора
//  входные данные: нет
//  выходные данные:
//    Menu: TMenu - инициализируемое меню
procedure InitAdminMenu(var Menu: TMenu);
begin
  Menu.Prompt:= 'Выберите пункт меню:';

  //пункты меню администратора:
  // 0 - добавить пользователя
  // 1 - удалить пользователя
  // 2 - сменить пароль пользователя
  // 3 - сменить пароль администратора
  // 4 - загрузить тест
  // 5 - удалить тест
  // 6 - просмотр статистики
  // 7 - сформировать отчет

  SetLength(Menu.Items, 8);
  Menu.Items[0] := 'Добавить пользователя';
  Menu.Items[1] := 'Удалить пользователя';
  Menu.Items[2] := 'Сменить пароль пользователя';
  Menu.Items[3] := 'Сменить пароль администратора';
  Menu.Items[4] := 'Загрузить тест';
  Menu.Items[5] := 'Удалить тест';
  Menu.Items[6] := 'Просмотр статистики';
  Menu.Items[7] := 'Сформировать отчет';

  SetLength(Menu.Actions, 8);
  Menu.Actions[0] := @AdminMenuAddUser;
  Menu.Actions[1] := @AdminMenuDelUser;
  Menu.Actions[2] := @AdminMenuChangeUserPassword;
  Menu.Actions[3] := @AdminMenuChangeAdminPassword;
  Menu.Actions[4] := @AdminMenuLoadTest;
  Menu.Actions[5] := @AdminMenuUnloadTest;
  Menu.Actions[6] := @AdminMenuViewStatistic;
  Menu.Actions[7] := @AdminMenuViewReport;

  Menu.Multiselect := false;
  Menu.Selection := -1;
end;

end.

