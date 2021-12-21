class YCL_ALV_IDA_020 definition
  public
  create public .

public section.

  types:
    TY_RAGNE_MATNR TYPE RANGE OF MATNR .
  types:
    TY_RAGNE_MTART TYPE RANGE OF MTART .

  methods DISPLAY .
  methods SET_SELECT_OPTIONS
    importing
      !IT_RANGES type IF_SALV_SERVICE_TYPES=>YT_NAMED_RANGES .
  methods CONSTRUCTOR
    importing
      !I_TABNAME type TABNAME
      !IT_RANGES type IF_SALV_SERVICE_TYPES=>YT_NAMED_RANGES optional
      !I_SELECTION_MODE type IF_SALV_GUI_SELECTION_IDA=>Y_SELECTION_MODE optional .
  PROTECTED SECTION.

private section.

  data MO_ALV_WITH_IDA type ref to IF_SALV_GUI_TABLE_IDA .
  class-data MV_HANDLE type I .

  methods ACTIVATE_SELECTION_MODE
    importing
      !I_SELECTION_MODE type IF_SALV_GUI_SELECTION_IDA=>Y_SELECTION_MODE optional .
  methods ON_DOUBLE_CLICK_ON_CELL
    for event DOUBLE_CLICK of IF_SALV_GUI_TABLE_DISPLAY_OPT
    importing
      !EV_FIELD_NAME
      !EO_ROW_DATA .
  methods ON_TOOLBAR_FUNCTION_SELECTED
    for event FUNCTION_SELECTED of IF_SALV_GUI_TOOLBAR_IDA
    importing
      !EV_FCODE .
  methods CREATE_ALV_WITH_IDA
    importing
      !I_TABNAME type TABNAME .
  methods ACTIVATE_LAYOUT_PERSISTENCE .
  methods REGISTER_DOUBLE_CLICK_EVENT .
  methods GET_ROW_DATA
    importing
      !ROW_OBJECT type ref to IF_SALV_GUI_ROW_DATA_IDA
    returning
      value(RS_RESULT) type YDDMDP_06_010 .
  methods ADD_BUTTONS_TO_TOOLBAR_REFRESH .
  methods CHANGE_TOOLBAR .
  methods REGISTER_TOOLBAR_EVENT .
ENDCLASS.



CLASS YCL_ALV_IDA_020 IMPLEMENTATION.


  METHOD ACTIVATE_LAYOUT_PERSISTENCE.


    DATA LV_HANDLE TYPE N LENGTH 4.

    ADD 1 TO MV_HANDLE.
    LV_HANDLE = MV_HANDLE.

    DATA(LS_PERSISTENCE_KEY) =
      VALUE IF_SALV_GUI_LAYOUT_PERSISTENCE=>YS_PERSISTENCE_KEY(
        REPORT_NAME = SY-REPID
        HANDLE = LV_HANDLE
    ).

    TRY.
        MO_ALV_WITH_IDA->LAYOUT_PERSISTENCE( )->SET_PERSISTENCE_OPTIONS(
          EXPORTING
            IS_PERSISTENCE_KEY             = LS_PERSISTENCE_KEY
*           i_global_save_allowed          = ABAP_TRUE
*           i_user_specific_save_allowed   = ABAP_TRUE
        ).
      CATCH CX_SALV_IDA_LAYOUT_KEY_INVALID.
    ENDTRY.

  ENDMETHOD.


  method ACTIVATE_SELECTION_MODE.

    TRY.

      CASE I_SELECTION_MODE.
        WHEN IF_SALV_GUI_SELECTION_IDA=>CS_SELECTION_MODE-NONE
          OR IF_SALV_GUI_SELECTION_IDA=>CS_SELECTION_MODE-SINGLE
          OR IF_SALV_GUI_SELECTION_IDA=>CS_SELECTION_MODE-MULTI.

          MO_ALV_WITH_IDA->SELECTION( )->SET_SELECTION_MODE(
            I_SELECTION_MODE
          ).

        WHEN OTHERS.
          MO_ALV_WITH_IDA->SELECTION( )->SET_SELECTION_MODE(
            IF_SALV_GUI_SELECTION_IDA=>CS_SELECTION_MODE-MULTI
          ).
      ENDCASE.

    CATCH CX_SALV_IDA_CONTRACT_VIOLATION.
    ENDTRY.

  endmethod.


  METHOD ADD_BUTTONS_TO_TOOLBAR_REFRESH.

    MO_ALV_WITH_IDA->TOOLBAR( )->ADD_BUTTON(
      IV_FCODE                     = 'REFRESH'
      IV_ICON                      = ICON_REFRESH
      IV_IS_CHECKED                = ABAP_FALSE
      IV_TEXT                      = SPACE
      IV_QUICKINFO                 = 'Refresh list'
      IV_BEFORE_STANDARD_FUNCTIONS = ABAP_FALSE
    ).

    MO_ALV_WITH_IDA->TOOLBAR( )->ADD_SEPARATOR(
      IV_BEFORE_STANDARD_FUNCTIONS = ABAP_TRUE
    ).

  ENDMETHOD.


  METHOD CHANGE_TOOLBAR.

    ADD_BUTTONS_TO_TOOLBAR_REFRESH( ).
    REGISTER_TOOLBAR_EVENT( ).

  ENDMETHOD.


  METHOD CONSTRUCTOR.

    CREATE_ALV_WITH_IDA( I_TABNAME ).
    SET_SELECT_OPTIONS( IT_RANGES ).
    ACTIVATE_SELECTION_MODE( I_SELECTION_MODE ).
    ACTIVATE_LAYOUT_PERSISTENCE( ).

*    CHANGE_TOOLBAR( ).
*    REGISTER_DOUBLE_CLICK_EVENT( ).

  ENDMETHOD.


  METHOD CREATE_ALV_WITH_IDA.

    TRY.

      SELECT COUNT(*)
        FROM DDDDLSRC
       WHERE DDLNAME EQ @I_TABNAME.

      IF SY-SUBRC EQ 0.
        MO_ALV_WITH_IDA = CL_SALV_GUI_TABLE_IDA=>CREATE_FOR_CDS_VIEW(
                            IV_CDS_VIEW_NAME      = I_TABNAME
*                           IO_GUI_CONTAINER       =
*                           IO_CALC_FIELD_HANDLER  =
                          ).
      ELSE.
        MO_ALV_WITH_IDA = CL_SALV_GUI_TABLE_IDA=>CREATE(
                            IV_TABLE_NAME         = I_TABNAME
*                            IO_GUI_CONTAINER      =
*                            IO_CALC_FIELD_HANDLER =
                          ).
      ENDIF.


      CATCH CX_SALV_DB_CONNECTION.            " Error connecting to database
      CATCH CX_SALV_DB_TABLE_NOT_SUPPORTED.   " DB table / view is not supported
      CATCH CX_SALV_IDA_CONTRACT_VIOLATION.   " IDA API contract violated by caller
      CATCH CX_SALV_FUNCTION_NOT_SUPPORTED.

    ENDTRY.

  ENDMETHOD.


  method DISPLAY.
    TRY.
        mo_alv_with_ida->fullscreen( )->display( ).
      CATCH cx_salv_ida_contract_violation.
    ENDTRY.
  endmethod.


  METHOD GET_ROW_DATA.
    TRY.
        ROW_OBJECT->GET_ROW_DATA(
          EXPORTING
            IV_REQUEST_TYPE                = IF_SALV_GUI_SELECTION_IDA=>CS_REQUEST_TYPE-ALL_FIELDS
*           its_requested_fields           =
          IMPORTING
            ES_ROW                         = RS_RESULT ).

      CATCH CX_SALV_IDA_CONTRACT_VIOLATION.
      CATCH CX_SALV_IDA_SEL_ROW_DELETED.
    ENDTRY.
  ENDMETHOD.


  METHOD ON_DOUBLE_CLICK_ON_CELL.

    DATA(LS_ROW_DATA) = GET_ROW_DATA( EO_ROW_DATA ).

    DATA(LV_MESSAGE_TEXT) = |Double click on field in column { EV_FIELD_NAME }|.


    ASSIGN COMPONENT EV_FIELD_NAME OF STRUCTURE LS_ROW_DATA TO FIELD-SYMBOL(<FS_VALUE>).
    IF SY-SUBRC EQ 0.
      LV_MESSAGE_TEXT = LV_MESSAGE_TEXT && |VALUE = { <FS_VALUE> }|.
    ENDIF.

    MESSAGE LV_MESSAGE_TEXT TYPE 'S'.

  ENDMETHOD.


  METHOD ON_TOOLBAR_FUNCTION_SELECTED.

    CASE EV_FCODE.
      WHEN 'REFRESH'.
        mo_alv_with_ida->refresh( ).

    ENDCASE.
  ENDMETHOD.


  METHOD REGISTER_DOUBLE_CLICK_EVENT.

    MO_ALV_WITH_IDA->DISPLAY_OPTIONS( )->ENABLE_DOUBLE_CLICK( ).

    SET HANDLER :
      ON_DOUBLE_CLICK_ON_CELL FOR MO_ALV_WITH_IDA->DISPLAY_OPTIONS( ).

  ENDMETHOD.


  METHOD REGISTER_TOOLBAR_EVENT.

    SET HANDLER :
      on_toolbar_function_selected FOR mo_alv_with_ida->toolbar( ).

  ENDMETHOD.


  METHOD SET_SELECT_OPTIONS.
    TRY.
        MO_ALV_WITH_IDA->SET_SELECT_OPTIONS(
           EXPORTING
             IT_RANGES                     = IT_RANGES
*            io_condition                  =
        ).
      CATCH CX_SALV_IDA_ASSOCIATE_INVALID.
      CATCH CX_SALV_DB_CONNECTION.
      CATCH CX_SALV_IDA_CONDITION_INVALID.
      CATCH CX_SALV_IDA_UNKNOWN_NAME.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
