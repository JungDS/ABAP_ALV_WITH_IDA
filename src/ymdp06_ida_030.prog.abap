*&---------------------------------------------------------------------*
*& Report YMDP06_IDA_030
*&---------------------------------------------------------------------*
*& YTMDP_06_010 출력 ALV IDA
*&---------------------------------------------------------------------*
REPORT YMDP06_IDA_030.

INCLUDE YMDP06_IDA_030_TOP.
INCLUDE YMDP06_IDA_030_F01.

START-OF-SELECTION.

*  PERFORM UPDATE_MAKTX.

  PERFORM DISPLAY_ALV_WITH_IDA.
