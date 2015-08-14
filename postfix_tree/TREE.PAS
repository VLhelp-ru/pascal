{***** COPYRIGHT: VLhelp.ru / program@vlhelp.ru *****}

Program tree;

Uses Crt;

Type PtrNode = ^PtrTypeNode;
     PtrTypeNode = record c : char;
	                  left : PtrNode;
                          right : PtrNode;
                   end;

Var strIn, s : string;
    i, levnum, totallev, maxlev : integer;
    ptr : PtrNode;

{Convert to postfix system}
Function ToPostfix(s:string):string;
Var alphabet : array[1..2] of set of char;
    n : integer;
{Remove chars}
Procedure Remove(sign1, sign2:char);
  Var num, n, cur, n_skobka, st, dot : integer;
      c : string;

  Function CheckChar(c:char; num:integer):boolean;
  begin
   if not (c in alphabet[num]) then
     CheckChar := false
   else
    begin
     if (s[cur-1] = '.') and (s[cur+1] = '.') then
	   CheckChar := false
	 else
	   CheckChar := true;
    end;
  end;

  begin
  {switch alphabet}
  if sign1 = '+' then
    num := 2
  else
    num := 1;
  cur:=1;

  repeat
   if ((s[cur] = sign1) or (s[cur] = sign2)) and ((s[cur-1]<>'.') or (s[cur+1]<>'.')) then
   begin
     {remove}
     st := cur;
     n_skobka := 0;
     repeat
      cur := cur + 1;
      if s[cur]='(' then
	    n_skobka := n_skobka + 1;
      if s[cur]=')' then
	    n_skobka := n_skobka - 1;
     until ((n_skobka = 0) and CheckChar(s[cur], num)) or (n_skobka < 0);
     if (s[cur] = ')') and (n_skobka = 0) then
	   cur := cur + 1;
     c:='.'+s[st]+'.';
     insert(c, s, cur);
     cur := st;
     s[st] := ' ';
   end;
   cur := cur + 1;
  until cur >= Length(s);
end;

begin
  alphabet[1] := ['*', '/', '+', '-'];
  alphabet[2] := ['+', '-'];
  remove('*', '/');
  remove('+', '-');
  {brackets}
  while pos('(', s) > 0 do delete(s, pos('(', s), 1);
  while pos(')', s) > 0 do delete(s, pos(')', s), 1);
  while pos('.', s) > 0 do delete(s, pos('.', s), 1);
  while pos(' ', s) > 0 do delete(s, pos(' ', s), 1);
  ToPostfix := s;
end;

{Check if character}
Function IsChar(c:char):boolean;
begin
  if ((c >= 'a') and (c <= 'z')) or ((c >= 'A') and (c <= 'Z')) then
     IsChar := true
  else
     IsChar := false;
end;

{Check if +, -, *, /}
Function IsCount(c:char):boolean;
begin
  if (c = '+') or (c = '-') or (c = '*') or (c = '/') then
     IsCount := true
  else
     IsCount := false;
end;

{Build binary tree}
Procedure Add(pleft, pright : PtrNode);
begin
  if i > Length(s) then exit;

  if IsChar(s[i]) then
  begin
    New(ptr);
    ptr^.c := s[i];
    ptr^.left := nil;
    ptr^.right := nil;
    if i + 1 > Length(s) then exit;

    i := i + 1;
    if IsChar(s[i]) then
    begin
      Add(ptr, pright);
    end
    else
      Add(pleft, ptr);
  end
  else if IsCount(s[i]) then
  begin
    New(ptr);
    ptr^.c := s[i];
    ptr^.left := pleft;
    ptr^.right := pright;

    if (pleft <> nil) and (pright <> nil) then
    begin
      totallev := levnum + 1;
      if totallev > maxlev then maxlev := totallev;
    end;
    levnum := levnum + 1;
    if i + 1 > Length(s) then exit;

    i := i + 1;

    if IsCount(s[i]) then
      Add(ptr, pright)
    else
      Add(pleft, ptr);
  end;
end;

Procedure ExitOnErr(s:string);
begin
  Writeln(s, #7);
  Writeln;
  Write('Press any key to exit...');
  Readkey;
  Halt;
end;

Procedure CheckInput;
begin
  if (s = '') then ExitOnErr('Empty input!');
  if (Length(s) < 3) or (not IsCount(s[Length(s)])) then ExitOnErr('Invalid expression!');
  for i := 1 to Length(s) do
    if (not IsChar(s[i])) and (not IsCount(s[i])) then
      ExitOnErr('Invalid expression!')
end;

Procedure CheckBrackets;
Var bc : integer;
begin
  bc := 0;
  for i := 1 to Length(strIn) do
  begin
    if strIn[i] = '(' then bc := bc + 1;
    if strIn[i] = ')' then bc := bc - 1;
  end;
  if bc <> 0 then ExitOnErr('Wrong bracket count!');
  if (pos('()', strIn) > 0) or (pos(')(', strIn) > 0) then ExitOnErr('Wrong brackets!');
end;

{Beginning of program}
Begin
  ClrScr;
  Write('Enter expression: ');
  Readln(strIn);
  Writeln;

  CheckBrackets;
  s := ToPostfix(strIn);
  CheckInput;
  Writeln('Converted to postfix: ', s);
  Writeln;
  i := 1;
  levnum := 1;
  totallev := -1;
  maxlev := -1;

  Add(nil, nil);
  if maxlev < 0 then ExitOnErr('No nodes!');
  Writeln('Level count: ', maxlev);

  Dispose(ptr);
  ptr := nil;
  Writeln;
  Write('Press any key to exit...');
  Readkey;
end.