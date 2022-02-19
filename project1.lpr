program project1;

{$mode objfpc}{$H+}


uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  SysUtils,
  crt, dateutils { you can add units after this };

type
  char_array = array of char;
type
  int_array = array of integer;

var
  score: int_array;
var
  word_list: TStringList;


  function populate(Text: string): char_array;
  var
    i: integer;
  begin
    setlength(Result, length(Text));
    for i := 0 to length(Text) - 1 do
      Result[i] := Text[i + 1];
  end;

  function GetMatchResults(a, b: string): int_array;
  var
    i, j, l1, l2: integer;
  var
    in1, in2: char_array;
  begin
    l1 := length(a);
    l2 := length(b);
    if (l1 = 0) or (l2 = 0) then
      exit;
    if l1 < l2 then
      b := copy(b, 1, l1);
    if l1 > l2 then
      a := copy(a, 1, l2);
    in1 := populate(a);
    in2 := populate(b);
    Setlength(Result, length(in1));
    //initialization
    for i := 0 to length(Result) - 1 do
      Result[i] := 0;
    //first pass
    for i := 0 to length(in1) - 1 do
    begin
      if (in1[i] = in2[i]) then
      begin
        Result[i] := 2;
        in1[i] := chr(0);
        in2[i] := chr(0);
      end;
    end;
    //second pass
    for i := 0 to length(in1) - 1 do
    begin
      if in1[i] <> chr(0) then
      begin
        for j := 0 to length(in2) - 1 do
        begin
          if (in2[j] <> chr(0)) and (in1[i] = in2[j]) then
          begin
            ;
            Result[i] := 1;
            in2[j] := chr(0);
            break;
          end;
        end;
      end;
    end;
  end;

  function GetScore(a: int_array): double;
  var
    i: integer;
  begin
    Result := 0;
    for i := 0 to length(a) - 1 do
      Result := Result + a[i];
    Result := Result / (length(a) * 2);
  end;

  function curScoreToString(a: int_array): string;
  var
    i: integer;
  begin
    Result := '';
    for i := 0 to length(a) - 1 do
      Result := Result + a[i].toString;
  end;

  procedure log(a: string);
  begin
    writeln(a);
  end;


  function getNewListfromScore(a: TStringList; score: int_array): TStringList;
  var
    i, j: integer;
  var
    include: boolean;
  begin
    Result := TStringList.Create;
    try
      for i := 0 to a.Count - 1 do
      begin
        include := False;
        for j := 0 to length(score) - 1 do ;

      end;

    finally
      Result.Free;
    end;
  end;


var mode:string;


  procedure doRUN;
  var
  i, j, k: integer;
var
  curscore: int_array;
var
  curSR, matchSL: TStringList;
var
  picked: string;
var
  inputstr: string;
var
  theword: string;
var
  resultscore: string;
var
  props: integer = 5;
  var a,b:tdatetime;
  begin
    word_list := TStringList.Create;
    curSR := TStringList.Create;

    try
      // Initialization :
      word_list.LoadFromFile(ExtractfilePath(ParamStr(0)) + 'listefr.txt', TEncoding.ANSI);
      writeln('Entrez votre proposition');
      readln(inputstr);
      writeln('Entrez le resultat (0-rien, 1-mauvaise position, 2-OK)');
      readln(resultscore);

      inputstr := lowercase(inputstr);
      for i := 0 to word_list.Count - 1 do
        if length(word_list[i]) = length(inputstr) then
          curSR.add(lowercase(word_list[i]));

      repeat;
        matchSL := TStringList.Create;
        try
          log('recherche...');
         a:=now;
          for i := 0 to curSR.Count - 1 do
          begin

            curscore := GetMatchResults(inputstr, curSR[i]);
            if curScoreToString(curscore) = resultscore then
            begin
              matchSL.add(curSR[i]);
            end;

          end;

          for i := 0 to matchSL.Count - 1 do
          begin
            Write(uppercase(matchSL[i]) + ' ');
            if i > props then
              break;
          end;
          b:=now;
          log(matchSL.Count.toString + ' possibilite'+booltostr(matchSL.count>1,'s','')+format(' en %s',[millisecondsbetween(a,b).ToString+'ms']));
          if (matchSL.Count) > 0 then
          begin

            case mode of
            '2':begin
            log('Entrez votre proposition :');
            readln(inputstr);
            end;

            '1':begin;
            inputstr := matchSL[0];
            end;
            end;
            for k:=0 to matchSL.count-1 do if lowercase(inputstr)=(matchSL[k]) then begin matchSL.Delete(k);break;end;




          end
          else
          begin
            log('Erreur ou aucune solution ??');
            Readln;
            exit;
          end;

          curSR.Text := matchSL.Text;


          log('Utilisez le mot : "' + uppercase(inputstr) +
            '" et entrez le resultat ou "OK" si c''est le bon mot');
          readln(resultscore);

        finally
          matchSL.Free;
        end;

      until lowercase(resultscore) = 'ok';

    finally
      word_list.Free;
      curSR.Free;
    end;
  end;

var
  redo: string;
begin
log('Quel mode ? Jeu avec suggestion imposee (1) Jeu avec choix (2) Automatique (3)');
readln(mode);
if (mode='1') or (mode='2') then
  repeat;
    clrscr;
    dorun;
    writeln('Recommencer ? O/N');
    readln(redo);
  until uppercase(redo) = 'N';
end.
