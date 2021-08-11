*&---------------------------------------------------------------------*
*& Report YMDP06_IDA_020
*&---------------------------------------------------------------------*
*& MARA -> YTMDP_06_010 데이터 구성
*&---------------------------------------------------------------------*
REPORT YMDP06_IDA_020.

DATA: GT_YTMDP_06_010 TYPE TABLE OF YTMDP_06_010.

SELECT *
  FROM MARA
 ORDER BY PRIMARY KEY
  INTO CORRESPONDING FIELDS OF TABLE @GT_YTMDP_06_010.

MODIFY YTMDP_06_010 FROM TABLE @GT_YTMDP_06_010.
