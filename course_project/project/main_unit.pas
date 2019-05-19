program main_unit;

uses
  common_unit, //модуль общий типов и подпрограмм
  menu_unit,   //модуль работы с меню
  test_unit,   //модуль работы с тестами
  log_unit     //модуль логирования
  ;

//запуск системы тестирования
//  входные данные: нет
//  выходные данные: нет
procedure StartTesting();
begin
  writeln('Запущена система тестирования...');
end;

//завершение работы системы
//  входные данные: нет
//  выходные данные: нет
procedure EndTesting();
begin
  writeln('Работа системы завершена.');
  halt;
end;

//получение пользователя
//  входные данные:
//    UserName: string - имя пользователя
//    UserPassword: string - пароль пользователя
//  выходные данные
//    -1 - пользователь не существует
//    -2 - введен неверный пароль
//     0 - введен верный пароль пользователя
function GetUser(const UserName, UserPassword: string):integer;
begin
  //#заглушка

  //авторизуем пользователей stud, admin
  //считаем, что sotr ввел неверный пароль
  //а всех остальных не существует
  if (UserName = 'stud') or (UserName = 'admin') then
    GetUser := 0
  else
    if UserName = 'sotr' then
      GetUser := -1
    else
      GetUser := -2;
end;

//выполнение авторизации пользователя
//  входные данные: нет
//  выходные данные:
//    UserName: string - имя пользователя;
//    IsAdmin: boolean - признак администратора;
//    IsAuthorized: boolean - признак успешности авторизации;
//    ErrorCode: integer - код ошибки
procedure LoginDialog(var UserName: string; var IsAdmin, IsAuthorized: boolean;
  var ErrorCode: integer);
var
  Password: string;
begin
  writeln;
  writeln('Авторизация пользователя. Введете логин и пароль (:quit - выход)');
  write('Логин >');  readln(UserName);

  if UserName = ':quit' then
    EndTesting();

  write('Пароль >'); readln(Password);

  ErrorCode := GetUser(UserName, Password);

  IsAdmin := UserName = 'admin';

  IsAuthorized := ErrorCode > 0;
end;

procedure Run();
var
  UserName: string;     // имя пользователя
  IsAdmin: boolean;     // признак того, что это администратор
  IsAuthorized: boolean;// признак авторизации пользователя
  ErrorCode: integer;   // признак ошибки
  Menu: TMenu;          // меню пользователя
begin
  //инициализации учетных данных
  UserName := '';
  IsAdmin := false;
  IsAuthorized := false;
  ErrorCode := 0;

  //авторизация пользователя
  repeat
    LoginDialog(UserName, IsAdmin, IsAuthorized, ErrorCode);
    case ErrorCode of
    -2: writeln('Ошибка: пользователь не найден в базе данных!');
    -1: writeln('Ошибка: введен неверный пароль!');
    end;
  until ErrorCode = 0;

  //авторизация прошла успешно
  writeln('Пользователь ', UserName, ' успешно авторизован в системе.');

  //если пользователь - администратор
  if IsAdmin then
    InitAdminMenu(Menu) //инициализация меню администратора
  else
    InitUserMenu(Menu); //инициализация меню пользователя

  //выполнение диалога с пользователем
  DoDialogMenu(Menu);
end;

begin
  //инициализация системы
  StartTesting();

  //запуск диалога с пользователем
  Run();

  //завершение тестирования
  EndTesting();
end.

