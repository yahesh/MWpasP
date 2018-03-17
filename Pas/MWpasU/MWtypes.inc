// Please, don't delete this comment. \\
(*
  Copyright Owner: Yahe            
  Copyright Year : 2007-2018

  Include: MWtypes (platform independant)
  Version: 1.4.5c

  Contact E-Mail: hello@yahe.sh
*)
// Please, don't delete this comment. \\

(*
  Description:

  This include file contains types that are important for MWconnU.
*)

(*
  Change Log:

  // See "change.log" for Information.
*)

type
// defines the access levels that are available for the shared memory
  TMWconnAccessMode    = (mwamNone, mwamRead, mwamWrite, mwamAll);
// defines the operation modes that are supported by MWconn
  TMWconnOperationMode = (mwomUnknown, mwomGPRS, mwomUMTS);

