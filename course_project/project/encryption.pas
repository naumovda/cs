unit Encryption;

//Модуль "Шифрование"
//Обеспечивает шифрование учетных данных и проверку
//верности введенных пользователем данных

interface
type
  TFunc = function (sym: char): integer;

function RSA(sym: char): integer;
function Shift(sym: char): integer;
function Caesar(sym: char): integer;
function Affine(sym: char): integer;
function Encrypt(const s: string; f: TFunc):string;
function Errata(var pl, cip: string; f: TFunc):boolean;
procedure CheckCorrect(const inp: string);

implementation

const
  //Алфавит допустимых символов
  CAPLAT = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  SMLAT = 'abcdefghijklmnopqrstuvwxyz';
  NUM = '0123456789';
  SYM = '-_*#.';
  ALPH = CAPLAT + SMLAT + NUM + SYM; // 67
  ALPH_LEN = 67;

procedure CheckCorrect(const inp: string);
begin
  for var i := 1 to length(inp) do
  begin
    if not (inp[i] in ALPH) then
      raise new System.Exception('Encryption Module Error');
  end;
end;

function Find(smbl: char): integer;
//Поиск символа в алфавите
//Вход: шифруемый символ
//Выход: номер символа в алфавите
var
  i: integer;
begin
  i := 1;
  while smbl <> ALPH[i] do
  begin
    i := i + 1;
  end;
  
  Find := i;
end;


function Shift(const sym: char): integer;
//Шифрование методом сдвига
//Вход: шифруемый символ
//Выход: зашифрованный символ
const
  KEY = 6;
begin
  Shift := Find(sym) + KEY;
end;


function Caesar(sym: char): integer;
//Шифрование методом Цезаря
//Вход: шифруемый символ
//Выход: зашифрованный символ
const
  KEY = 5;
begin
  Caesar := (Find(sym) + KEY) mod ALPH_LEN;
end;

function Affine(sym: char): integer;
//Шифрование афинным методом
//Вход: шифруемый символ
//Выход: зашифрованный символ
const
  // gcd(key, size of symbol set) == 1
  KEY = 1359;
  AKEY = KEY div ALPH_LEN;
  BKEY = KEY mod ALPH_LEN;

begin
  Affine := (Find(sym) * AKEY + BKEY) mod ALPH_LEN;
end;


function ModExp(num, exp, n: integer): integer;
//Возведение числа в степень по модулю
//Вход: основание степень, показатель степени, модуль
//Выход: результат операции
var
  c: Biginteger;
  a: array of byte;
  res, mul: integer;
begin
  c := 1;
  for var i := 1 to exp do
    c := (c * num) mod n;
  
  a := c.ToByteArray();
  
  res := 0;
  mul := 1;
  
  for var i := Low(a) to High(a) do
  begin
    res := res + a[i] * mul;
    
    mul := mul * 256;
  end;  
  
  ModExp := res;
end;

function RSA(const sym: char): integer;
//Шифрование методом RSA
//Вход: шифруемый символ
//Выход: зашифрованный символ
const
  //p = 971;
  //q = 599;
  PExp = 17; // public exponent
  N = 581629; // modulus
  
var
  num: integer;
begin
  num := Find(sym);
  RSA := ModExp(num, PExp, N);
end;


function Encrypt(const s: string; f: TFunc):string;
//Шифрование строки по выбранному методу
//Вход: строка для шифрования; метод шифрования
//Выход: зашифрованная строка
var
  res: string;
begin
  for var i := 1 to length(s) do
  begin
    res := res + f(s[i]);
  end;
  Encrypt := res;
end;

function Errata(var pl, cip: string; f: TFunc):boolean;
//Проверка введенных учетных данных
//Вход: данные, введенные пользователем; зашифрованные данные; метод шифрования
//Выход: True, если найдены ошибки; False, если данные введены верно
begin
  Errata := not (Encrypt(pl, f) = cip);
end;


begin
end. 