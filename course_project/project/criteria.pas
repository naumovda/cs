unit Criteria;

interface

type
  TMark = record
    Name: string;
    Level: integer;
  end;
  
  TCriterion = record
    ID: string[3]; 
    Name: string;
    Marks: array of TMark;
  end;
  
  TCritArray = array of TCriterion;
  
  TFile = text;

  procedure Load();
  procedure Save();
  procedure Print(PrintMarks: boolean := True);

  procedure AddCriterionDlg();
  procedure DelCriterionDlg();
  procedure EditCriterionDlg();

  function CalcMark(id: string; user_res, max: integer): string;

implementation

const
  TAGCRIT = '[criterion]';
  TAGMARK = '[mark]';

  FNAME = 'grades.txt';

var
  CritArray: TCritArray;

procedure GetCriteria(var ACritArray: TCritArray);
begin
  ACritArray := CritArray;
end;

procedure SetCriteria(const ACritArray: TCritArray);
begin
  CritArray := ACritArray;
end;

function GetErrorText(err:integer):string;
begin
  case err of
   0: GetErrorText := '';
  -1: GetErrorText := 'Код критерия не задан';
  -2: GetErrorText := 'Критерий с заданным кодом уже существует';
  -3: GetErrorText := 'Список оценок для критерия не может быть пустым';
  -4: GetErrorText := 'Код оценки не задан';
  -5: GetErrorText := 'Оценка с заданным кодом уже существует';
  -6: GetErrorText := 'Оценка с заданным наименованием уже существует';
  -7: GetErrorText := 'Критерий не найден';
  else
    GetErrorText := 'Код ошибки неизвестен';  
  end;
end;

procedure ReadCriterionHeader(var f: TFile; var id, name: string);
begin
  readln(f, id);
  readln(f, name);
end;

procedure ReadMarks(var f: TFile; var name: string; var level: integer);
begin
  readln(f, name);
  readln(f, level);
end;

procedure Load;
var
  alen, mlen: byte;
  id, name, s: string;
  level: integer;
  f: TFile;
  arr: TCritArray;
begin
  GetCriteria(arr);

  assign(f, FNAME);
  
  try
    reset(f);
  except
    rewrite(f);
    close(f);
    
    SetCriteria(arr);
    
    exit;
  end;  
 
  readln(f, s);
  
  alen := 1;
  
  while not eof(f) do
  begin
    setlength(arr, alen);
  
    if s = TAGCRIT then
    begin
      ReadCriterionHeader(f, id, name);
      
      arr[alen-1].ID := id;
      arr[alen-1].Name := name;
      
      readln(f, s);
    end;
      
    mlen := 1;
    while s = TAGMARK do
    begin
      setlength(arr[alen-1].Marks, mlen);
      
      ReadMarks(f, name, level);
      arr[alen-1].Marks[mlen-1].Name := name;
      arr[alen-1].Marks[mlen-1].Level := level;
      
      readln(f, s);
      
      mlen := mlen + 1;
    end;
    alen := alen + 1;
  end;
  close(f);
  
  SetCriteria(arr);
end;

procedure Save();
var
  f : TFile;
  arr: TCritArray;
begin
  GetCriteria(arr);
  
  assign(f, FNAME);
  rewrite(f);  
  
  for var i := low(arr) to high(arr) do
  begin
    writeln(f, TAGCRIT);
    writeln(f, arr[i].ID);
    writeln(f, arr[i].Name);
    
    for var j := low(arr[i].Marks) to high(arr[i].Marks) do
    begin
      writeln(f, TAGMARK);
      writeln(f, arr[i].Marks[j].Name);
      writeln(f, arr[i].Marks[j].Level);
    end;
  end;
  
  close(f);
  
  SetCriteria(arr);
end;

procedure Print;
var
  arr: TCritArray;
begin
  GetCriteria(arr);
  
  for var i := low(arr) to high(arr) do
    with arr[i] do
    begin
      writeln(ID);
      writeln(Name);
      
      if PrintMarks then
        for var j := low(Marks) to high(Marks) do
          with Marks[j] do
            writeln(Name, ' ', Level);
    end;
end;

procedure Sort(var arr: array of TMark);
var
  tmp: TMark;
begin
  for var i := low(arr) to high(arr) - 1 do
    for var j := i downto low(arr) do
      if arr[j].Level < arr[j + 1].Level then
      begin
        tmp := arr[j];
        arr[j] := arr[j + 1];
        arr[j + 1] := tmp;
      end;
end;

function FindCriterion(const arr: TCritArray; id: string): integer;
begin
  for var i := low(arr) to high(arr) do
    if arr[i].ID = id then
    begin
      FindCriterion := i;
      exit;
    end;
  
  FindCriterion := -1;
end;

function FindMarkByLevel(var crit: TCriterion; level: integer): integer;
begin
  for var i := low(crit.Marks) to high(crit.Marks) do
    if crit.Marks[i].Level = level then
    begin
      FindMarkByLevel := i;
      exit;
    end;
    
  FindMarkByLevel := -1;
end;

function FindMarkByName(var crit: TCriterion; name: string): integer;
begin
  for var i := low(crit.Marks) to high(crit.Marks) do
    if crit.Marks[i].Name = name then
    begin
      FindMarkByName := i;
      exit;
    end;
    
  FindMarkByName := -1;
end;

procedure InputCriterion(var ID, name: string);
begin  
  write('input ID:');
  readln(ID);
  write('input name:');
  readln(Name);
end;

procedure InputMark(var name: string; var level: integer);
begin  
  write('input mark name:');
  readln(Name);
  write('input level:');
  readln(Level);
end;

function AddMark(var crit: TCriterion; var name: string; 
  var level:integer):integer;
var
  count: integer;
begin
  if name = '' then
  begin
    AddMark := -4;
    exit;
  end;
  
  if FindMarkByLevel(crit, level) <> - 1 then
  begin
    AddMark := -5;
    exit;
  end;

  if FindMarkByName(crit, name) <> - 1 then
  begin
    AddMark := -6;
    exit;
  end;

  setlength(crit.Marks, length(crit.Marks) + 1);
  
  count := high(crit.Marks);
  
  crit.Marks[count].Name := name;
  crit.Marks[count].Level := level;
      
  AddMark := 0;    
end;

function AddCriterion(var arr: TCritArray; var crit: TCriterion):integer;
begin
  if crit.ID = '' then
  begin
    AddCriterion := -1;
    exit;
  end;
  
  if FindCriterion(arr, crit.ID) <> - 1 then
  begin
    AddCriterion := -2;
    exit;
  end;
  
  if Length(crit.Marks) = 0 then
  begin
    AddCriterion := -3;
    exit;
  end;  
  
  setlength(arr, length(arr) + 1);
  
  sort(crit.Marks);
  
  arr[high(arr)] := crit;  
    
  AddCriterion := 0;    
end;

procedure AddCriterionDlg;
var 
  arr: TCritArray;

  cr: TCriterion;
  count: integer;
  ErrorCode: integer;
  
  id, name: string;
  level: integer;  


begin
  GetCriteria(arr);

  InputCriterion(id, name);
  
  cr.ID := id;
  cr.Name := name;
  
  write('Input marks count:');
  readln(count);
  
  for var i := 1 to count do
  begin
    repeat
      InputMark(name, level);
    
      ErrorCode := AddMark(cr, name, level);
      
      if ErrorCode <> 0 then
      begin
        writeln(GetErrorText(ErrorCode));
        writeln('повторить ввод!');
      end;
    until ErrorCode = 0;    
  end;
  
  ErrorCode := AddCriterion(arr, cr);
  
  if ErrorCode <> 0 then  
    writeln(GetErrorText(ErrorCode))
  else
    SetCriteria(arr);
end;

function DelCriterionByIndex(var arr: TCritArray; idx: integer):integer;
begin
  if (idx < low(arr)) or (idx > high(arr)) then
  begin
    DelCriterionByIndex := -7;
    exit;
  end;
  
  for var j := idx to high(arr)-1 do
    arr[j] := arr[j + 1];
  
  setlength(arr, length(arr)-1);
  
  DelCriterionByIndex := 0;
end;

function DelCriterionByID(var arr: TCritArray; id: string): integer;
begin
  DelCriterionByID := DelCriterionByIndex(arr, FindCriterion(arr, id));
end;

procedure DelCriterionDlg;
var
  arr: TCritArray;
  id: string;
  ErrorCode: integer;
begin
  GetCriteria(arr);
  
  writeln('Select criterion to delete');
  
  Print(arr, False);
  
  write('ID: ');
  readln(id);
  
  ErrorCode := DelCriterionByID(arr, id);
  
  if ErrorCode <> 0 then
    writeln(GetErrorText(ErrorCode))
  else
    SetCriteria(arr);
end;

function EditHeader(var arr: TCritArray; var crit: TCriterion; var id, name: string): integer;
begin
  if id = '' then
  begin
    EditHeader := -1;
    exit;
  end;
  
  if FindCriterion(arr, id) <> -1 then
  begin
    EditHeader := -2;
    exit;
  end;
  
  EditHeader := 0;
end;

function EditMarks(var crit: TCriterion; var name: string; 
  var level:integer): integer;
begin
  if name = '' then
  begin
   EditMarks := -4;
   exit;
  end; 
  
  if FindMarkByName(crit, name) <> -1 then
  begin
    EditMarks := -6;
    exit;
  end;
  
  if FindMarkByLevel(crit, level) <> -1 then
  begin
    EditMarks := -5;
    exit;
  end;
  
  EditMarks := 0;
end;

procedure EditCriterionDlg;
var
  arr: TCritArray;
  ErrorCode: integer;
  id, name: string;
  level: integer;
  index: integer;
begin
  GetCriteria(arr);

  writeln('Select criterion to edit');
  
  Print(arr, False);
  
  write('input ID: ');
  readln(id);
  
  index := FindCriterion(arr, id);
  
  if index >= 0 then
  begin
    write('input new criteria ID: ');
    InputCriterion(id, name);
    
    arr[index].ID := id;
    arr[index].Name := name;
    ErrorCode := EditHeader(arr, arr[index], id, Name);
    
    for var i := low(arr[index].Marks) to high(arr[index].Marks) do
    repeat
      InputMark(name, level);
      
      ErrorCode := EditMarks(arr[index], name, level);
      arr[index].Marks[i].Name := name;
      arr[index].Marks[i].Level := level;
      
      if ErrorCode <> 0 then
        GetErrorText(ErrorCode);
    until ErrorCode <> 0;
    
    Sort(arr[index].Marks);
    
    SetCriteria(arr);
  end
  else
    writeln(GetErrorText(-7));  
end;

function CalcMark(id: string; 
  user_res, max: integer): string;
var
  arr: TCritArray;
  score: real;
  j: byte;
begin
  GetCriteria(arr);
  
  score := (user_res/max) * 100;

  with arr[FindCriterion(arr, id)] do
  begin
    j := low(Marks);
    while (score < Marks[j].Level) and (j <= high(Marks)) do
      j := j + 1;
    
    CalcMark := Marks[j].Name;
  end;  
end;

end. 