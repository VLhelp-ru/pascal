{***** COPYRIGHT: VLhelp.ru / program@vlhelp.ru *****}

Program task5;

Uses crt;

Const minAge = 5;
      maxAge = 120;
      oldC = 3;
      n = 20;

Type turist = record surname : string[30];
                     age : minAge..maxAge;
                     gender : integer;
                     end;

Var x : array [1..n] of turist;
    mCount, wCount, i, j, oldest, tmpAge, tmpGender : integer;
    f : text;
    tmpTur : turist;
    tmpSurname : string;

{Halt app on error}
Procedure ExitOnErr(s:string; linenum : integer);
begin
  if linenum <> 0 then
    Writeln(s, ' Line: ', linenum)
  else
    Writeln(s);
  Writeln;
  Write('Press any key to exit...');
  Readkey;
  Halt;
end;

Function TrimStr(s:string):string;
Var i : integer;
    tmpS : string;
begin
  tmpS := '';
  for i := 1 to Length(s) do
    if ((s[i] >= 'a') and (s[i] <= 'z')) or ((s[i] >= 'A') and (s[i] <= 'Z')) or (s[i] = #39) then
      tmpS := tmpS + s[i];
  TrimStr := tmpS;
end;

Begin
  ClrScr;

  {*****Read data from file (START)*****}
  assign(f, 'input.txt');
  {$i-}
  reset(f);
  {$i+}
  if IOResult <> 0 then ExitOnErr('Can''t open file!', 0);

  i := 1;

  if eof(f) then ExitOnErr('File is empty!', 0);
  while not eof(f) do
  begin
    if i > n then
      break
    else
    begin
      {$i-}
      Readln(f, tmpSurname);
      {$i+}
      if IOResult <> 0 then ExitOnErr('Can''t read ''surname''.', i);
      tmpSurname := TrimStr(tmpSurname);
      if (tmpSurname = '') then ExitOnErr('Empty ''surname''.', i);
      x[i].surname := tmpSurname;

      if eof(f) then ExitOnErr('Invalid file structure!', 0);
      {$i-}
      Readln(f, tmpAge);
      {$i+}
      if IOResult <> 0 then ExitOnErr('Can''t read ''age''.', i + 1);
      
      if (tmpAge < minAge) or (tmpAge > maxAge) then ExitOnErr('Invalid ''age''.', i + 1);
      x[i].age := tmpAge;

      if eof(f) then ExitOnErr('Invalid file structure!', 0);
      {$i-}
      Readln(f, tmpGender);
      {$i+}
      if IOResult <> 0 then ExitOnErr('Can''t read ''gender''.', i + 2);
      if (tmpGender <> 1) and (tmpGender <> 2) then ExitOnErr('Invalid ''gender''.', i + 2);
      x[i].gender := tmpGender;
    end;
    i := i + 1;
  end;
  {*****Read data from file (END)*****}


  {*****Count males and females (START)*****}
  mCount := 0; wCount := 0;

  for i := 1 to n do
    if x[i].gender = 1 then
      mCount := mCount + 1
    else
      if x[i].gender = 2 then
        wCount := wCount + 1;
  {*****Count males and females (END)*****}

  {*****Sort array (START)*****}
  for i := 1 to (n - 1) do
    for j := 2 to n do
      if x[j].age > x[j-1].age then
      begin
        tmpTur.surname := x[j-1].surname;
        tmpTur.age := x[j-1].age;
        tmpTur.gender := x[j-1].gender;

        x[j-1].surname := x[j].surname;
        x[j-1].age := x[j].age;
        x[j-1].gender := x[j].gender;

        x[j].surname := tmpTur.surname;
        x[j].age := tmpTur.age;
        x[j].gender := tmpTur.gender;
      end;
  {*****Sort array (END)*****}

  {Define oldest}
  oldest := x[1].age;

  {*****Output (START)*****}
  Writeln('Maximum age: ', oldest);
  Writeln;

  Writeln('First ', oldC, ' oldest:');
  for i := 1 to oldC do
    Writeln('    ', i, '. ', x[i].surname, ' - ', x[i].age);
  Writeln;

  Write('Difference: ');
  if mCount > wCount then
    Write('Males > Females')
  else
    if wCount > mCount then
      Write('Females > Males')
    else
      if mCount = wCount then
        Write('Males = Females')
      else
        Write('Error in counting difference!');
  Readkey;
  {*****Output (END)*****}
end.