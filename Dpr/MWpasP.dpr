program MWpasP;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  MWpasU;

var
  VAccessMode : TMWconnAccessMode;
  VBufferA    : THandle;
  VBufferB    : PMWconnIO;
  VInstance   : String;
  VNextLine   : String;
  VTemp       : String;

const
  CExitCommand = 'QUIT';
  CFirstChar   = ':';
  CStatCommand = 'STAT';

begin
  WriteLn(MWpasU.Name + ' ' + MWpasU.Version + ' [' + MWpasU.ReleaseName + ' (' + MWpasU.ReleaseDate + ')' + ']');
  WriteLn('(C) ' + MWpasU.CopyrightYear + ' ' + MWpasU.CopyrightOwner);
  WriteLn('');
  WriteLn('(compatible with MWconn ' + ProgramVersionToString(MWpasU.MWconnIOMinVersion) + ' to ' + ProgramVersionToString(MWpasU.MWconnIOMaxVersion) + ')');
  WriteLn('');
  WriteLn('Usage:');
  WriteLn('> ' + ExtractFileName(ParamStr(0)) + ' [INSTANCE]');
  WriteLn('');

  VInstance := '';
  if (ParamCount >= 1) then
    VInstance := Trim(ParamStr(1));

  if IsMWconnRunning(VInstance) then
  begin
    vAccessMode := OpenMWconnIO(vBufferA, vBufferB, VInstance);
    try
      WriteLn('');
      WriteLn('Instance   : ' + VInstance);
      WriteLn('Access Mode: ' + AccessModeToString(VAccessMode));
      WriteLn('');
      WriteLn('Commands available:');
      WriteLn('  QUIT - close application');
      if (vAccessMode <> mwamNone) then
        WriteLn('  STAT - print connection statistics');
      WriteLn('');

      repeat
        Write('> ');
        ReadLn(vNextLine);
        WriteLn('');

        if (Trim(vNextLine) <> '') then
        begin
          if (AnsiLowerCase(vNextLine) = AnsiLowerCase(cStatCommand)) then
          begin
            if (vAccessMode <> mwamNone) then
            begin
              try
                WriteLn('Laenge der Struktur: ' + IntToStr(vBufferB^.Len));
                WriteLn('Strukturversion    : ' + IntToStr(vBufferB^.Structure_Version));
                WriteLn('Programmversion    : ' + ProgramVersionToString(vBufferB^.Program_Version));
                WriteLn('Prozesszaehler     : ' + IntToStr(vBufferB^.Process_Counter));
                WriteLn('');
                WriteLn('Summiertes Datenvolumen: ' + IntToStr(vBufferB^.Volume) + ' kBytes');
                WriteLn('Summierte Onlinezeit   : ' + IntToStr(vBufferB^.Time) + ' Minuten');
                WriteLn('');
                WriteLn('Aktuelle Onlinezeit        : ' + IntToStr(vBufferB^.Online_Time) + ' Sekunden');
                WriteLn('Aktuelle/Letzte Offlinezeit: ' + IntToStr(vBufferB^.Offline_Time) + ' Sekunden');
                WriteLn('');
                WriteLn('Upspeed  : ' + FloatToStr(vBufferB^.UpSpeed / 1000) + ' kBytes/s');
                WriteLn('Downspeed: ' + FloatToStr(vBufferB^.DownSpeed / 1000) + ' kBytes/s');
                WriteLn('');
                WriteLn('Betriebsart  : ' + IntToStr(vBufferB^.OpMode) + ' (' + OperationModeToString(GetOperationMode(vBufferB^.OpMode)) + ')');
                WriteLn('Signalstaerke: ' + IntToStr(vBufferB^.Signal_Raw) + ' = ' + IntToStr(vBufferB^.Signal_Percent) + '% = ' + IntToStr(vBufferB^.Signal_DBM) + ' DBM');
                WriteLn('');
                WriteLn('Netzname: ' + String(vBufferB^.Network_Name));
                WriteLn('PLMN    : ' + String(vBufferB^.PLMN));
                WriteLn('LAC     : ' + String(vBufferB^.LAC));
                WriteLn('Cell-ID : ' + String(vBufferB^.CID));
                WriteLn('');
                WriteLn('Meldung      : ' + String(vBufferB^.Message));
                WriteLn('Mini-Meldung : ' + String(vBufferB^.Mini_Message));
                WriteLn('Fehlermeldung: ' + String(vBufferB^.Error_Message));
              except
                WriteLn('An error has occurred.');
                WriteLn('Probably you do not have READ access.');
              end;
            end
            else
            begin
              WriteLn('The execution has been denied.');
              WriteLn('You do not have READ access.');
            end;
          end
          else
          begin
            if (AnsiLowerCase(vNextLine) <> AnsiLowerCase(cExitCommand)) then
            begin
              if ((vAccessMode = mwamWrite) or (vAccessMode = mwamAll)) then
              begin
                try
                  vBufferB^.Answer := '';

                  CopyMemory(@vBufferB^.Command[0], @vNextLine[1], Length(vNextLine));
                  vBufferB^.Command[Length(vNextLine)] := #0;

                  if (Pos(cFirstChar, vNextLine) = 1) then
                  begin
                    vTemp := vBufferB^.Answer;

                    while (vBufferB^.Answer = '') do
                      Sleep(100);
                  end;

                  WriteLn(vBufferB^.Answer);
                except
                  WriteLn('An error has occurred.');
                  WriteLn('Probably you do not have WRITE access.');
                end;
              end
              else
              begin
                WriteLn('The execution has been denied.');
                WriteLn('You do not have WRITE access.');
              end;
            end;
          end;

          WriteLn('');
        end;
      until (AnsiLowerCase(vNextLine) = AnsiLowerCase(cExitCommand));
    finally
      if (vAccessMode <> mwamNone) then
        CloseMWconnIO(vBufferA, vBufferB);
    end;
  end
  else
  begin
    WriteLn('An error has occurred.');
    WriteLn('MWconn is not running.');
  end;
end.
