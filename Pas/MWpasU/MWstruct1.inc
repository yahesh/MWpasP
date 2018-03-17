// Please, don't delete this comment. \\
(*
  Copyright Owner: Yahe            
  Copyright Year : 2007-2018

  Include: MWstruct1 (platform independant)
  Version: 1.4.5c

  Contact E-Mail: hello@yahe.sh
*)
// Please, don't delete this comment. \\

(*
  Description:

  This include file contains the definition of the type TMWconnIO_1.
*)

(*
  Change Log:

  // See "change.log" for Information.
*)

(* VERSION 1
typedef struct { // Struktur für Datenaustausch mit externen Programmen
  unsigned long len; // Länge dieser Struktur in Bytes

  unsigned short structure_version; // Version dieser Struktur: 1
  unsigned short program_version;   // Version des MWconn-Programms
                                    // (Hauptversion*256+Nebenversion)

  unsigned long res1[3]; // reserviert

  // Datenrichtung extern->MWconn
  char command[100]; // von MWconn auszuführendes Kommando;
                     // "MWCONN_CONNECT": verbinden;
                     // "MWCONN_DISCONNECT": trennen;
                     // "MWCONN_RECONNECT": neu verbinden;
                     // "MWCONN_END": Programm beenden;

  // Datenrichtung MWconn->extern
  // Hinweis: nicht alle Datenkarten unterstützen alle Informationen;
  unsigned long process_counter; // dieser Zähler wird von MWconn mit
                                 // jedem Verarbeitungstakt inkrementiert;

  unsigned long volume;         // summiertes Datenvolumen in kBytes
  unsigned long time;           // summierte Onlinezeit in Minuten
  unsigned long online_time;    // aktuelle Onlinezeit in Sekunden; ==0: offline
  unsigned long offline_time;   // aktuelle Offline-Zeit in Sekunden
  unsigned long upspeed;        // aktuelle Sendegeschwindigkeit in Bytes/s
  unsigned long downspeed;      // aktuelle Empfangsgeschwindigkeit in Bytes/s
  unsigned char opmode;         // Betriebsart; 0: nicht bekannt; 1: GPRS; 2: UMTS;
  unsigned char signal_raw;     // Signalstärke als GSM-Standardwert (0..31)
  unsigned char signal_percent; // Signalstärke in Prozent (0..100);
                                // nur gültig, wenn signal_raw>0
  signed short signal_dbm;      // Signalstärke in dBm
  char network_name[32+1];      // Name des Netzwerks
  char plmn[5+1];               // Public Land Mobile Network, bestehend aus MCC und MNC
  char lac[4+1];                // Location Area Code
  char cid[4+1];                // Cell-ID
  char message[64+1];           // ggf. Meldungstext
  char mini_message[48+1];      // ggf. verkürzter Meldungstext
  char error_message[32+1];     // ggf. Fehlermeldung

  unsigned char res2[3];        // reserviert
  unsigned long res3[3];        // reserviert
} mwcio_t;
VERSION 1 *)

type
  TMWconnIO_1 = record
    Len : LongWord;

    Structure_Version : Word;
    Program_Version   : Word;

    Res1 : array [0..2] of LongWord;

    Command : array [0..99] of Char;

    Process_Counter : LongWord;

    Volume         : LongWord;
    Time           : LongWord;
    Online_Time    : LongWord;
    Offline_Time   : LongWord;
    UpSpeed        : LongWord;
    DownSpeed      : LongWord;
    OpMode         : Byte; // unsigned char
    Signal_Raw     : Byte; // unsigned char
    Signal_Percent : Byte; // unsigned char
    Signal_DBM     : SmallInt;
    Network_Name   : array [0..32] of Char;
    PLMN           : array [0..5]  of Char;
    LAC            : array [0..4]  of Char;
    CID            : array [0..4]  of Char;
    Message        : array [0..64] of Char;
    Mini_Message   : array [0..48] of Char;
    Error_Message  : array [0..32] of Char;

    Res2 : array [0..2] of Byte; // unsigned char
    Res3 : array [0..2] of LongWord;
  end;

const
  MWconnIOMaxVersion_1 = $0309; // 3.9
  MWconnIOMinVersion_1 = $0309; // 3.9

