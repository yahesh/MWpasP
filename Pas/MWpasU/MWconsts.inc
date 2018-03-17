// Please, don't delete this comment. \\
(*
  Copyright Owner: Yahe
  Copyright Year : 2007-2018

  Include: MWconsts (platform independant)
  Version: 1.4.5c

  Contact E-Mail: hello@yahe.sh
*)
// Please, don't delete this comment. \\

(*
  Description:

  This include file contains constants that are important for MWconnU.
*)

(*
  Change Log:

  // See "change.log" for Information.
*)

// unit-specific constants (interoperability)
const
  MWconn_CopyrightOwner = 'Yahe';
  MWconn_CopyrightYear  = '2007-2018';
  MWconn_Name           = 'MWpas';
  MWconn_ReleaseDate    = '09.10.2008';
  MWconn_ReleaseName    = 'MWconn 4.5 release';
  MWconn_Version        = '1.4.5c';

// unit-specific constants
const
  CopyrightOwner = MWconn_CopyrightOwner;
  CopyrightYear  = MWconn_CopyrightYear;
  Name           = MWconn_Name;
  ReleaseDate    = MWconn_ReleaseDate;
  ReleaseName    = MWconn_ReleaseName;
  Version        = MWconn_Version;

// MWconn-specific constants
const
  MWconnFile       = 'MWCONN_IO';
  MWconnFileGlobal = 'Global\' + MWconnFile;

  MWconnSemaphore = 'MWconn_Aktivsignal';

  MWconn_Connect    = 'MWCONN_CONNECT';
  MWconn_Disconnect = 'MWCONN_DISCONNECT';
  MWconn_Reconnect  = 'MWCONN_RECONNECT';
  MWconn_End        = 'MWCONN_END';
  
