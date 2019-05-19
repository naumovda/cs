unit test_unit;

interface

uses
  common_unit; //общие типы и подпрограммы

const
  //начисление баллов за частично правильный ответ
  ANS_RATIO = 0.5;

type
  //вариант ответа на тестовый вопрос
  TVariant = record
    AnswerText: TName;   //текст ответа
    IsCorrect: boolean; //признак правильности ответа
    IsSelected: boolean; //признак выбора варианта ответа
  end;

  //тестовый вопрос
  TQuestion = record
    QuestionText: TName; //тестовый вопрос
    IsRadio: boolean; //признак вопроса с одним вариантом ответа
    Difficult: byte;  //сложность вопроса
    Variants: array of TVariant; //варианты ответа

    IsCorrect: boolean; //признак правильности ответа на вопрос
    Score: real; //набранные баллы при ответе
  end;

  //тест
  TTest = record
    FileName: TName;                 //имя файла теста

    Title: TName;                    //название теста
    Description: string;             //описание теста
    Questions: array of TQuestion;   //список тестовых вопросов
  end;

  //список тестов
  TTestList = array of TTest;

  //загрузить список тестов
  procedure LoadTestList(var TestList: TTestList);

  //загрузить данные теста и тестовые вопросы
  procedure LoadTest(const FileName: string; var Test: TTest);

  //выполнение тестирования
  procedure RunTest(const UserName: string; var Test: TTest);

  //инициализация данных тестирования
  procedure StartTest(const UserName: string; var Test: TTest);

  //завершение тестирования
  procedure EndTest(const UserName: string; const Test: TTest);

  //отображаем последовательно каждый вопрос
  procedure ShowQuestion(const Question: TQuestion);

  //получаем ответ пользователя
  procedure GetAnswer(var Question: TQuestion);

  //определяем правильность ответа
  procedure CalcScore(var Question: TQuestion);

var
  //список тестов
  Tests: array of TTest;

implementation

//загрузить список тестов
//  входные данные: нет
//  выходные данные:
//    TestList: TTestList - список тестов
procedure LoadTestList(var TestList: TTestList);
var
  i: integer;
begin
  //# заглушка
  SetLength(TestList, 1);
  TestList[0].FileName := 'database.tst';

  //после заполнения имен файлов подгружаем данные тестов
  for i := low(TestList) to high(TestList) do
    LoadTest(TestList[i].FileName, TestList[i]); //загружаем тест из файла
end;

//загрузить тест
//  входные данные: нет
//    FileName: string;
//  выходные данные:
//    Test: TTest - тест
procedure LoadTest(const FileName: string; var Test: TTest);
//var
//  i: integer;
begin
  //задаем имя файла
  Test.FileName := FileName;

  //# заглушка, задаем количество вопросов
  SetLength(Test.Questions, 2);

  //# заглушка, заполняем первый тестовый вопрос
  Test.Questions[0].QuestionText := 'База данных - это...';
  Test.Questions[0].IsRadio := true;
  Test.Questions[0].Difficult := 1;
  Test.Questions[0].IsCorrect := false;
  Test.Questions[0].Score := 0;

  //# заглушка, заполняем варианты ответа на первый тестовый вопрос
  SetLength(Test.Questions[0].Variants, 3);
  Test.Questions[0].Variants[0].AnswerText := 'вариант ответа 1';
  Test.Questions[0].Variants[0].IsCorrect := false;
  Test.Questions[0].Variants[1].AnswerText := 'вариант ответа 2';
  Test.Questions[0].Variants[1].IsCorrect := true;
  Test.Questions[0].Variants[2].AnswerText := 'вариант ответа 3';
  Test.Questions[0].Variants[2].IsCorrect := false;

  //# заглушка, заполняем первый тестовый вопрос
  Test.Questions[1].QuestionText := 'ER-модель относится к...';
  Test.Questions[1].IsRadio := true;
  Test.Questions[1].Difficult := 2;
  Test.Questions[1].IsCorrect := false;
  Test.Questions[1].Score := 0;

  //# заглушка, заполняем варианты ответа на первый тестовый вопрос
  SetLength(Test.Questions[1].Variants, 2);
  Test.Questions[1].Variants[0].AnswerText := 'концептуальной модели данных';
  Test.Questions[1].Variants[0].IsCorrect := true;
  Test.Questions[1].Variants[1].AnswerText := 'физической модели данных';
  Test.Questions[1].Variants[1].IsCorrect := false;
end;

//выполнение тестирования
//  входные данные:
//    UserName: string - имя пользователя
//  выходные данные:
//    Test: TTest - тест
procedure RunTest(const UserName: string; var Test: TTest);
var
  number: integer;
begin
  //начало тестирования
  StartTest(UserName, Test);

  //по каждому вопросу
  for number := Low(Test.Questions) to High(Test.Questions) do
  begin
    //отображаем последовательно каждый вопрос
    ShowQuestion(Test.Questions[number]);
    //получаем ответ пользователя
    GetAnswer(Test.Questions[number]);
    //определяем правильность ответа
    CalcScore(Test.Questions[number]);
  end;

  //завершение тестирования
  EndTest(UserName, Test);
end;

//инициализация данных тестирования
//  входные данные:
//    UserName: string - имя пользователя
//  выходные данные:
//    Test: TTest - тест
procedure StartTest(const UserName: string; var Test: TTest);
var
  i: integer;
begin
  //обнуляем статистику прохождения теста
  for i := Low(Test.Questions) to High(Test.Questions) do
    begin
      Test.Questions[i].IsCorrect := false;
      Test.Questions[i].Score := 0;
    end;
end;

//завершение тестирования
//  входные данные:
//    UserName: string - имя пользователя
//    Test: TTest - тест
//  выходные данные: нет
procedure EndTest(const UserName: string; const Test: TTest);
begin
  //# заглушка
  //загружаем критерий оценивания
  //рассчитываем оценку за тест
  //сохраняем результаты тестирования, обновляем статистику
  //SaveStatistics(UserName, Test);
end;

//отображаем последовательно каждый вопрос
//  входные данные:
//    Question: TQuestion - вопрос теста
//  выходные данные: нет
procedure ShowQuestion(const Question: TQuestion);
var
  i: integer;
begin
  writeln(Question.QuestionText);

  for i := Low(Question.Variants) to High(Question.Variants) do
    writeln('[', i, '] -', Question.Variants[i].AnswerText);
end;

//получаем ответ пользователя
//  входные данные:
//    Question: TQuestion - вопрос теста
//  выходные данные: нет
//    Question: TQuestion - вопрос теста
procedure GetAnswer(var Question: TQuestion);
var
  UserInput: string;
  IsCorrect: boolean;
  Number: integer;
  i: integer;
begin
  repeat
    write('>');
    readln(UserInput);

    IsCorrect := true;
    for i := 1 to Length(UserInput) do
    begin
      Number := ord(UserInput[i]) - ord('0');
      if Number <= High(Question.Variants) then
        Question.Variants[Number].IsSelected := true
      else
        IsCorrect := false;
    end;

    if not IsCorrect then
      writeln('Ошибочный ввод, повторите ввод вариантов ответа!');
  until not IsCorrect;
end;

//определяем правильность ответа
//  входные данные:
//    Question: TQuestion - вопрос теста
//  выходные данные: нет
//    Question: TQuestion - вопрос теста
procedure CalcScore(var Question: TQuestion);
var
  TotalCorrect, Correct, Incorrect: integer;
  i: integer;
begin
  Correct := 0;
  Incorrect := 0;
  TotalCorrect := 0;

  for i := Low(Question.Variants) to High(Question.Variants) do
  begin
    if Question.Variants[i].IsCorrect then
      Inc(TotalCorrect);

    if Question.Variants[i].IsSelected then
      if Question.Variants[i].IsCorrect then
        Inc(Correct)
      else
        Inc(Incorrect);
  end;

  if Incorrect > 0 then
    Question.Score := 0
  else
    if Correct < TotalCorrect then
      Question.Score := Question.Difficult * ANS_RATIO
    else
      Question.Score := Question.Difficult;
end;

end.

