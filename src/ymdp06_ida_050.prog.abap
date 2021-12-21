*&---------------------------------------------------------------------*
*& Report YMDP06_IDA_030
*&---------------------------------------------------------------------*
*& YTMDP_06_010 출력 ALV IDA
*&---------------------------------------------------------------------*
REPORT YMDP06_IDA_050.


TABLES YVMDP_06_010.

DATA GO_IDA TYPE REF TO YCL_ALV_IDA_020.
DATA GT_RANGES TYPE IF_SALV_SERVICE_TYPES=>YT_NAMED_RANGES WITH HEADER LINE.

SELECT-OPTIONS SO_MATNR FOR YVMDP_06_010-MATNR.
SELECT-OPTIONS SO_MTART FOR YVMDP_06_010-MTART.

START-OF-SELECTION.

  PERFORM SET_RANGES.
  PERFORM DISPLAY_ALV_IDA.

*&---------------------------------------------------------------------*
*& Form SET_RANGES
*&---------------------------------------------------------------------*
FORM SET_RANGES .


  IF SO_MATNR[] IS NOT INITIAL.
    GT_RANGES[] = CORRESPONDING #( SO_MATNR[] ).
    GT_RANGES-NAME = 'MATNR'.
    MODIFY GT_RANGES TRANSPORTING NAME WHERE NAME IS INITIAL.
  ENDIF.

  IF SO_MTART[] IS NOT INITIAL.
    GT_RANGES[] = CORRESPONDING #( SO_MTART[] ).
    GT_RANGES-NAME = 'MTART'.
    MODIFY GT_RANGES TRANSPORTING NAME WHERE NAME IS INITIAL.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_IDA
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_IDA .

  CREATE OBJECT GO_IDA
    EXPORTING
      I_TABNAME        = 'YTMDP_06_010'                 " 테이블이름
      IT_RANGES        = GT_RANGES[]
*      I_SELECTION_MODE =
    .
  CALL METHOD GO_IDA->DISPLAY.

ENDFORM.
