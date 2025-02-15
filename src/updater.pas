unit updater;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, process, inifiles;

type

  { Tupdater1 }

  Tupdater1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Process1: TProcess;
    Process2: TProcess;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    //procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  updater1: Tupdater1;
  updater2: Tinifile;
  agcfg: Tinifile;

implementation
 uses zclmain;

{ Tupdater1 }

procedure Tupdater1.Button1Click(Sender: TObject);
begin
memo1.Lines.Clear;
agcfg := Tinifile.Create('zcl.ini');
if fileexists('update.ini') then begin
deletefile('update.ini');
end;

try
process1.CommandLine := 'wget http://sjnetwork.net/update.ini';
process1.execute;
except
on Exception do
begin
memo1.Lines.Add('ZCL Updater Backend is missing. We can not do updates without it!');
end;
end;

//version checking
          if fileexists('update.ini') then begin
             updater2 := Tinifile.Create('update.ini');
                       {$ifdef win32}
                      if updater2.readstring('UPDATE' , 'WINDOWS' , '') = agcfg.ReadString('VERSIONS', 'ZELDAWIN', '' ) then begin
                       {$endif}

                          {$ifdef linux}
                      if updater2.readstring('UPDATE' , 'LINUX' , '') = agcfg.ReadString('VERSIONS', 'ZELDALIN', '' ) then begin
                       {$endif}
                      memo1.Lines.Add('You are currently using the latest version');

                      end else begin
                      memo1.lines.Add('New Version Available! Click update to begin');
                      button2.Visible:= true;
                      end;
            end else begin
            memo1.Lines.Add('Connection to the update server has failed. This can be caused if you are not connected to the internet. This may also be caused if the update server is down.');
            end;


end;

procedure Tupdater1.Button2Click(Sender: TObject);
begin
{$ifdef win32}
//We need some tools
process1.CommandLine := 'wget http://sjnetwork.net/update.exe';
process1.Execute;
process1.CommandLine := 'wget http://sjnetwork.net/unzip.exe';
process1.Execute;
process2.CommandLine := 'update.exe';
{$endif}
{$ifdef linux}
//Linux comes with them all the time anymore =/
process1.CommandLine := 'wget http://sjnetwork.net/update';
process1.Execute;
//Permission issues = Yuck
process1.CommandLine := 'chmod 777 update';
process1.Execute;
process2.CommandLine := './update';
{$endif}
  process2.Execute;
  //Bye Bye Updater I Will Miss You :'(
  application.Terminate;

end;



initialization
  {$I updater.lrs}

end.

