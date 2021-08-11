*&---------------------------------------------------------------------*
*& Report ymdp06_ida_010
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YMDP06_IDA_010.

DATA GS_UOM_TEXTS TYPE T006A.

SELECT-OPTIONS SO_UOM FOR GS_UOM_TEXTS-MSEHI.
SELECT-OPTIONS SO_LANGU FOR GS_UOM_TEXTS-SPRAS.

START-OF-SELECTION.
  DATA(GO_UOM_ALV_IDA) = YCL_ALV_IDA_UOM=>GET_INSTANCE(
                                            IT_UOM_SELECTION      = SO_UOM[]
                                            IT_LANGUAGE_SELECTION = SO_LANGU[] ).

  GO_UOM_ALV_IDA->DISPLAY( ).
