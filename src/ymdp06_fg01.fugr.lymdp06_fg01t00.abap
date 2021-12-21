*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YVMDP_06_020....................................*
TABLES: YVMDP_06_020, *YVMDP_06_020. "view work areas
CONTROLS: TCTRL_YVMDP_06_020
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_YVMDP_06_020. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YVMDP_06_020.
* Table for entries selected to show on screen
DATA: BEGIN OF YVMDP_06_020_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YVMDP_06_020.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YVMDP_06_020_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YVMDP_06_020_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YVMDP_06_020.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YVMDP_06_020_TOTAL.

*.........table declarations:.................................*
TABLES: YTMDP_06_010                   .
TABLES: YTMDP_06_020                   .
