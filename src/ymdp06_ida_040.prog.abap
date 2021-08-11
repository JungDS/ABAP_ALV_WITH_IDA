*&---------------------------------------------------------------------*
*& Report YMDP06_IDA_030
*&---------------------------------------------------------------------*
*& YTMDP_06_010 출력 SALV
*&---------------------------------------------------------------------*
REPORT YMDP06_IDA_040.


TABLES YVMDP_06_010.


SELECT-OPTIONS SO_MATNR FOR YVMDP_06_010-MATNR.
SELECT-OPTIONS SO_MTART FOR YVMDP_06_010-MTART.

DATA GO_SALV TYPE REF TO CL_SALV_TABLE.

START-OF-SELECTION.

  SELECT *
    FROM MARA
   WHERE MATNR IN @SO_MATNR
     AND MTART IN @SO_MTART
   ORDER BY PRIMARY KEY
    INTO TABLE @DATA(GT_DATA).

  TRY.
    CL_SALV_TABLE=>FACTORY(
*      EXPORTING
*        LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE " ALV Displayed in List Mode
*        R_CONTAINER    =                           " Abstract Container for GUI Controls
*        CONTAINER_NAME =
      IMPORTING
        R_SALV_TABLE   = GO_SALV
      CHANGING
        T_TABLE        = GT_DATA
    ).
    CATCH CX_SALV_MSG. " ALV: General Error Class with Message

  ENDTRY.


  GO_SALV->DISPLAY( ).
