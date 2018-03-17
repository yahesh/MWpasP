// Please, don't delete this comment. \\
(*
  Copyright Owner: Yahe            
  Copyright Year : 2007-2018

  Include: MWpasU (platform independant)
  Version: 1.4.5c

  Contact E-Mail: hello@yahe.sh
*)
// Please, don't delete this comment. \\

(*
  Description:

  This include file contains all other includes in their correct order.
*)

(*
  Change Log:

  // See "change.log" for Information.
*)

// all constants are included here
{$I MWconsts.inc}

// all different structure versions are included here
// has to be done BEFORE including "MWdefs.inc"
{$I MWstruct1.inc}
{$I MWstruct2.inc}
{$I MWstruct3.inc}

// all compiler switches are included here
// has to be done AFTER including "MWstruct[N].inc"
{$I MWdefs.inc}

// all additional types are included here
{$I MWtypes.inc}

