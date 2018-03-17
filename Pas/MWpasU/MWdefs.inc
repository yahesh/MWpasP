// Please, don't delete this comment. \\
(*
  Copyright Owner: Yahe
  Copyright Year : 2007-2018

  Include: MWdefs (platform independant)
  Version: 1.4.5c

  Contact E-Mail: hello@yahe.sh
*)
// Please, don't delete this comment. \\

(*
  Description:

  This include file contains the definition of the type TMWconnIO.
  This definition is based on compiler switches.
*)

(*
  Change Log:

  // See "change.log" for Information.
*)

// define if you want to select the correct Structure-Version
// by defining the MWconn-Version you are using
{$DEFINE DEFINE_STRUCTURE_VERSION_BY_MWCONN_VERSION}

{$IF DEFINED(DEFINE_STRUCTURE_VERSION_BY_MWCONN_VERSION)}
  // define if latest MWconn-Version is to be used
  {$DEFINE MWCONN_LATEST}

  {$IF DEFINED(MWCONN_LATEST)}
    // should define the latest MWconn-Version available

    {$DEFINE MWCONN_4_1_TO_4_5}
  {$ELSE}
    // if MWCONN_LATEST is not defined:
    // the MWconn-Version to be used has to be defined correctly
    // keep in mind that the highest version defined will be used

    {.$DEFINE MWCONN_4_1_TO_4_5}
    {$DEFINE MWCONN_3_10_TO_4_0}
    {.$DEFINE MWCONN_3_9_TO_3_9}
  {$IFEND}

  // DO NOT MODIFY >>
  // maps the MWconn-Version to the corresponding Structure-Version
  {$IF DEFINED(MWCONN_4_1_TO_4_5)}
    {$DEFINE STRUCTURE_3}
  {$ELSEIF DEFINED(MWCONN_3_10_TO_4_0)}
    {$DEFINE STRUCTURE_2}
  {$ELSEIF DEFINED(MWCONN_3_9_TO_3_9)}
    {$DEFINE STRUCTURE_1}
  {$IFEND}
  // << DO NOT MODIFY
{$ELSE}
  // define if latest Structure-Version is to be used
  {$DEFINE STRUCTURE_LATEST}

  {$IF DEFINED(STRUCTURE_LATEST)}
    // should define the latest Structure-Version available

    {$DEFINE STRUCTURE_3}
  {$ELSE}
    // if STRUCTURE_LATEST is not defined:
    // the Structure-Version to be used has to be defined correctly
    // keep in mind that the highest version defined will be used

    {.$DEFINE STRUCTURE_3}
    {$DEFINE STRUCTURE_2}
    {.$DEFINE STRUCTURE_1}
  {$IFEND}
{$IFEND}

// DO NOT MODIFY >>
// the actual type definition
{$IF DEFINED(STRUCTURE_3)}
const
  MWconnIOMaxVersion = MWconnIOMaxVersion_3;
  MWconnIOMinVersion = MWconnIOMinVersion_3;

type
  TMWconnIO = TMWconnIO_3;
{$ELSEIF DEFINED(STRUCTURE_2)}
const
  MWconnIOMaxVersion = MWconnIOMaxVersion_2;
  MWconnIOMinVersion = MWconnIOMinVersion_2;

type
  TMWconnIO = TMWconnIO_2;
{$ELSEIF DEFINED(STRUCTURE_1)}
const
  MWconnIOMaxVersion = MWconnIOMaxVersion_1;
  MWconnIOMinVersion = MWconnIOMinVersion_1;

type
  TMWconnIO = TMWconnIO_1;
{$ELSE}
// raise compiler error as no version is defined
{$MESSAGE Fatal 'There is no structure version defined.'}
{$IFEND}

type
  PMWconnIO = ^TMWconnIO;
// << DO NOT MODIFY

