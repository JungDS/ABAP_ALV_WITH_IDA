*&---------------------------------------------------------------------*
*& Report YMDP06_IDA_030
*&---------------------------------------------------------------------*
*& YTMDP_06_010 출력 ALV IDA
*&---------------------------------------------------------------------*
REPORT YMDP06_IDA_030.


TABLES YVMDP_06_010.


SELECT-OPTIONS SO_MATNR FOR YVMDP_06_010-MATNR.
SELECT-OPTIONS SO_MTART FOR YVMDP_06_010-MTART.

START-OF-SELECTION.

  YCL_ALV_IDA_010=>GET_INSTANCE(
    IT_MATNR = SO_MATNR[]
    IT_MTART = SO_MTART[] )->DISPLAY( ).
