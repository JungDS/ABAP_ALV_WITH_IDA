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
DATA OKCODE  TYPE SY-UCOMM.

START-OF-SELECTION.

  SELECT *
    FROM SFLIGHT
*   WHERE MATNR IN @SO_MATNR
*     AND MTART IN @SO_MTART
   ORDER BY PRIMARY KEY
    INTO TABLE @DATA(GT_DATA).

  CALL SCREEN 0100.

*  TRY.
*    CL_SALV_TABLE=>FACTORY(
**      EXPORTING
**        LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE " ALV Displayed in List Mode
**        R_CONTAINER    =                           " Abstract Container for GUI Controls
**        CONTAINER_NAME =
*      IMPORTING
*        R_SALV_TABLE   = GO_SALV
*      CHANGING
*        T_TABLE        = GT_DATA
*    ).
*    CATCH CX_SALV_MSG. " ALV: General Error Class with Message
*
*  ENDTRY.
*
*
*  GO_SALV->DISPLAY( ).
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'PF_0100'.
  SET TITLEBAR  'TT_0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE OKCODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0100 OUTPUT.

  DATA GO_CON TYPE REF TO CL_GUI_CONTAINER.
  DATA GO_ALV TYPE REF TO CL_GUI_ALV_GRID.

  CHECK GO_ALV IS NOT BOUND.

  CREATE OBJECT GO_ALV
    EXPORTING
      I_PARENT                = GO_CON
    EXCEPTIONS
      ERROR_CNTL_CREATE       = 1                " Error when creating the control
      ERROR_CNTL_INIT         = 2                " Error While Initializing Control
      ERROR_CNTL_LINK         = 3                " Error While Linking Control
      ERROR_DP_CREATE         = 4                " Error While Creating DataProvider Control
      OTHERS                  = 5.

  GO_ALV->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      I_STRUCTURE_NAME              = 'SFLIGHT'            " Internal Output Table Structure Name
    CHANGING
      IT_OUTTAB                     = GT_DATA                 " Output Table
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).

ENDMODULE.
