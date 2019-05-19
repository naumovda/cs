unit log_unit;

interface

uses
  dateutils; //функции работы с датой и временем

  //инициализация файла для записи логов
  function InitLog():boolean;

  //закрытие файла лога
  procedure CloseLog();

  //добавление данных в лог
  procedure Add(UserName, Action, Parameters: string);

implementation

const
  LogFileName = 'test.log';

var
  LogFile: Text;
  IsOpen: boolean;

//инициализация файла для записи логов
function InitLog():boolean;
begin
  try
    Assign(LogFile, LogFileName);
    Append(LogFile); //пытаемся открыть файл
    InitLog := true;
    IsOpen := true;
  except
    try
      Rewrite(LogFile); //если не удалось открыть, пробуем перезаписать
      IsOpen := true;
      InitLog := true;
    except
      InitLog := false; //открыть не удалось
      IsOpen := false;
    end;
  end;
end;

//закрытие файла лога
procedure CloseLog();
begin
  if IsOpen then
    Close(LogFile);
  IsOpen := false;
end;

//добавление данных в лог
//  входные данные:
//    UserName: string - имя пользователя
//    Action: string - действие
//    Parameters: string - параметры
//  выходные данные:
//    нет
procedure Add(UserName, Action, Parameters: string);
var
  d: TDateTime;
  year, month, day, hour, minute, second: string;
begin
  d := Today();

  Str(YearOf(d), year);
  Str(MonthOf(d), month);
  Str(DayOf(d), day);
  Str(HourOf(d), hour);
  Str(MinuteOf(d), minute);
  Str(SecondOf(d), second);

  write(LogFile, UserName, ';');
  write(LogFile, year, '-', month, '-', day, 'T', hour, ':', minute, ':',
    second, ';');
  write(LogFile, Action, ';');
  write(LogFile, Parameters, ';');

  writeln(LogFile);
end;

begin
  IsOpen := false;
end.

