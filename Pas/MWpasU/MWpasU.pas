unit MWpasU;

// Please, don't delete this comment. \\
(*
  Copyright Owner: Yahe            
  Copyright Year : 2007-2018

  Unit   : MWpasU (platform dependant)
  Version: 1.4.5c

  Contact E-Mail: hello@yahe.sh
*)
// Please, don't delete this comment. \\

(*
  Description:

  This unit contains the shared memory interface
  implementation for the application MWconn by
  Markus B. Weber.

  It is a plain C to Pascal translation.
*)

(*
  Change Log:

  // See "change.log" for Information.
*)

interface

uses
  Windows,
  SysUtils;

// includes all other include files  
{$I MWpasU.inc}

// opens the shared memory interface of MWconn
// use CloseMWconnIO() to close it again
function OpenMWconnIO(var AFile : THandle; var AMapping : PMWconnIO; const AInstance : String = '') : TMWconnAccessMode;

// closes an already open shared memory interface
// of MWconn opened with OpenMWconnIO()
procedure CloseMWconnIO(var AFile : THandle; var AMapping : PMWconnIO);

// returns whether the MWconn semaphore exists
function IsMWconnRunning(const AInstance : String = '') : Boolean;

// returns a data snapshot returned by MWconn
function ReturnMWconnIO(var AData : TMWconnIO; const AInstance : String = '') : Boolean;

// takes an enumerator and returns a string with the access mode
function AccessModeToString(const AAccessMode : TMWconnAccessMode) : String;

// duration values less than 0 are replaced by empty strings
// durations are millisecond values
// the result is: ":<aWaitDuration>:<aReadDuration>:<aCommand>"
function BuildATCommand(const ACommand : String; const AWaitDuration : LongInt; const AReadDuration : LongInt) : String;

// takes a number and returns an enumerator denoting the operation mode
function GetOperationMode(const AOpMode : Byte) : TMWconnOperationMode;

// takes an enumerator and returns a string with the operation mode
function OperationModeToString(const AOperationMode : TMWconnOperationMode) : String;

// takes a number and returns a string with the correct version number
function ProgramVersionToString(const AProgramVersion : Word) : String;

implementation

// opens the shared memory interface of MWconn
// use CloseMWconnIO() to close it again
function OpenMWconnIO(var AFile : THandle; var AMapping : PMWconnIO; const AInstance : String = '') : TMWconnAccessMode;
  function MapMWconnIO(const AMappedFile : String; const AMapMode : Cardinal; var AFile : THandle; var AMapping : PMWconnIO) : Boolean;
  begin
    Result := false;

    AFile := OpenFileMapping(AMapMode, false, PChar(AMappedFile));
    if (AFile <> 0) then
    begin
      try
        AMapping := MapViewOfFile(AFile, AMapMode, 0, 0, SizeOf(TMWconnIO));

        Result := (AMapping <> nil);
      except
        CloseHandle(AFile);
      end;
    end;
  end;
type
  TMapModeData = record
    AccessMode : TMWconnAccessMode;
    MapMode    : Cardinal;
  end;
const
  CMapFile : array [0..1] of String       = (MWconnFileGlobal, MWconnFile);
  CMapMode : array [0..2] of TMapModeData = ((AccessMode : mwamAll;   MapMode : FILE_MAP_ALL_ACCESS;),
                                             (AccessMode : mwamWrite; MapMode : FILE_MAP_WRITE;),
                                             (AccessMode : mwamRead;  MapMode : FILE_MAP_READ;));
var
  LIndexA : Byte;
  LIndexB : Byte;
begin
  Result := mwamNone;

  for LIndexA := Low(CMapFile) to High(CMapFile) do
  begin
    for LIndexB := Low(CMapMode) to High(CMapMode) do
    begin
      if MapMWconnIO(CMapFile[LIndexA] + Trim(AInstance), CMapMode[LIndexB].MapMode, AFile, AMapping) then
        Result := CMapMode[LIndexB].AccessMode;

      if (Result <> mwamNone) then
        Break;
    end;

    if (Result <> mwamNone) then
      Break;
  end;
end;

// closes an already open shared memory interface
// of MWconn opened with OpenMWconnIO()
procedure CloseMWconnIO(var AFile : THandle; var AMapping : PMWconnIO);
begin
  if (AMapping <> nil) then
    UnmapViewOfFile(AMapping);
  if (AFile <> 0) then
    CloseHandle(AFile);

  AFile    := 0;
  AMapping := nil;
end;

// returns whether the MWconn semaphore exists
function IsMWconnRunning(const AInstance : String = '') : Boolean;
const
  SEMAPHORE_ALL_ACCESS = STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or 3;
var
  LSemaphore : THandle;
begin
  LSemaphore := OpenSemaphore(SEMAPHORE_ALL_ACCESS, true, PChar(MWconnSemaphore + AInstance));
  try
    Result := (LSemaphore <> 0);
  finally
    CloseHandle(LSemaphore);
  end;
end;

// returns a data snapshot returned by MWconn
function ReturnMWconnIO(var AData : TMWconnIO; const AInstance : String = '') : Boolean;
var
  LBuffer : PMWconnIO;
  LHandle : THandle;
begin
  Result := false;

  if (OpenMWconnIO(LHandle, LBuffer, AInstance) <> mwamNone) then
  begin
    try
      CopyMemory(@AData, LBuffer, SizeOf(TMWconnIO));

      Result := true;
    finally
      CloseMWconnIO(LHandle, LBuffer);
    end;
  end;
end;

// takes an enumerator and returns a string with the access mode
function AccessModeToString(const AAccessMode : TMWconnAccessMode) : String;
begin
  case AAccessMode of
    mwamAll   : Result := 'ALL';
    mwamRead  : Result := 'READ';
    mwamWrite : Result := 'WRITE';
  else
    Result := 'NONE';
  end;
end;

// duration values less than 0 are replaced by empty strings
// durations are millisecond values
// the result is: ":<aWaitDuration>:<aReadDuration>:<aCommand>"
function BuildATCommand(const ACommand : String; const AWaitDuration : LongInt; const AReadDuration : LongInt) : String;
const
  CSeperator = ':';
begin
  Result := CSeperator;

  if (AWaitDuration >= 0) then
    Result := Result + IntToStr(AWaitDuration);
  Result := Result + CSeperator;

  if (AReadDuration >= 0) then
    Result := Result + IntToStr(AReadDuration);
  Result := Result + CSeperator;

  Result := Result + ACommand;
end;

// takes a number and returns an enumerator denoting the operation mode
function GetOperationMode(const AOpMode : Byte) : TMWconnOperationMode;
begin
  case AOpMode of
    1 : Result := mwomGPRS;
    2 : Result := mwomUMTS;
  else
    Result := mwomUnknown;
  end;
end;

// takes an enumerator and returns a string with the operation mode
function OperationModeToString(const AOperationMode : TMWconnOperationMode) : String;
begin
  case AOperationMode of
    mwomGPRS : Result := 'GPRS';
    mwomUMTS : Result := 'UMTS';
  else
    Result := 'unknown';
  end;
end;

// takes a number and returns a string with the correct version number
function ProgramVersionToString(const AProgramVersion : Word) : String;
begin
  Result := IntToStr(AProgramVersion shr $08) + '.' + IntToStr(AProgramVersion and $FF);
end;

end.

