class YCL_ALV_IDA_010 definition
  public
  final
  create private .

public section.

  interfaces YIF_ALV_IDA .

  types:
    TY_RAGNE_MATNR TYPE RANGE OF MATNR .
  types:
    TY_RAGNE_MTART TYPE RANGE OF MTART .

  methods CONSTRUCTOR
    importing
      !IT_MATNR type TY_RAGNE_MATNR
      !IT_MTART type TY_RAGNE_MTART .

  class-methods GET_INSTANCE
    importing
      !IT_MATNR type TY_RAGNE_MATNR
      !IT_MTART type TY_RAGNE_MTART
    returning
      value(RO_RESULT) type ref to YIF_ALV_IDA .
  PROTECTED SECTION.

private section.

  constants MC_CDS_VIEW_NAME type DBTABL value 'YDDMDP_06_010' ##NO_TEXT.
  class-data MO_INSTANCE type ref to YIF_ALV_IDA .
  data MO_ALV_WITH_IDA type ref to IF_SALV_GUI_TABLE_IDA .

  methods ON_DOUBLE_CLICK_ON_CELL
    for event DOUBLE_CLICK of IF_SALV_GUI_TABLE_DISPLAY_OPT
    importing
      !EV_FIELD_NAME
      !EO_ROW_DATA .
  methods ON_TOOLBAR_FUNCTION_SELECTED
    for event FUNCTION_SELECTED of IF_SALV_GUI_TOOLBAR_IDA
    importing
      !EV_FCODE .
  methods CREATE_ALV_WITH_IDA .
  methods PROVIDE_SELECT_OPTIONS
    importing
      !IT_SELECTION_MATNR type TY_RAGNE_MATNR
      !IT_SELECTION_MTART type TY_RAGNE_MTART .
  methods ACTIVATE_TEXT_SEARCH .
  methods ACTIVATE_LAYOUT_PERSISTENCE .
  methods REGISTER_DOUBLE_CLICK_EVENT .
  methods GET_ROW_DATA
    importing
      !ROW_OBJECT type ref to IF_SALV_GUI_ROW_DATA_IDA
    returning
      value(RS_RESULT) type YDDMDP_06_010 .
  methods ADD_BUTTONS_TO_TOOLBAR .
  methods CHANGE_TOOLBAR .
  methods REGISTER_TOOLBAR_EVENT .
ENDCLASS.



CLASS YCL_ALV_IDA_010 IMPLEMENTATION.


  METHOD ACTIVATE_LAYOUT_PERSISTENCE.
    DATA(ls_persistence_key) =
      VALUE if_salv_gui_layout_persistence=>ys_persistence_key(
        report_name = sy-repid
        handle = 'ZMDP06_010'
    ).

    TRY.
        mo_alv_with_ida->layout_persistence( )->set_persistence_options(
          EXPORTING
            is_persistence_key             = ls_persistence_key
*           i_global_save_allowed          = ABAP_TRUE
*           i_user_specific_save_allowed   = ABAP_TRUE
        ).
      CATCH cx_salv_ida_layout_key_invalid.
    ENDTRY.
  ENDMETHOD.


  METHOD ACTIVATE_TEXT_SEARCH.
    mo_alv_with_ida->standard_functions( )->set_text_search_active( abap_true ).

    TRY.
*        mo_alv_with_ida->field_catalog( )->enable_text_search( 'SHORT_TEXT' ).
*        mo_alv_with_ida->field_catalog( )->enable_text_search( 'LONG_TEXT' ).
      CATCH cx_salv_ida_unknown_name.
      CATCH cx_salv_call_after_1st_display.
    ENDTRY.
  ENDMETHOD.


  METHOD ADD_BUTTONS_TO_TOOLBAR.
    mo_alv_with_ida->toolbar( )->add_button(
      iv_fcode                     = 'REFRESH'
      iv_icon                      = icon_refresh
      iv_is_checked                = abap_false
      iv_text                      = space
      iv_quickinfo                 = 'Refresh list'
      iv_before_standard_functions = abap_false
    ).

    mo_alv_with_ida->toolbar( )->add_separator(
      iv_before_standard_functions = abap_true
    ).

  ENDMETHOD.


  METHOD CHANGE_TOOLBAR.
    add_buttons_to_toolbar( ).
    register_toolbar_event( ).
  ENDMETHOD.


  METHOD CONSTRUCTOR.
    create_alv_with_ida( ).

    provide_select_options( IT_SELECTION_MATNR = IT_MATNR
                            IT_SELECTION_MTART = IT_MTART ).

    activate_text_search( ).
    activate_layout_persistence( ).
    change_toolbar( ).
    register_double_click_event( ).
  ENDMETHOD.


  METHOD CREATE_ALV_WITH_IDA.
*
*    TRY.
*        mo_alv_with_ida = cl_salv_gui_table_ida=>CREATE(
*          IV_TABLE_NAME         = 'MARA'
**         IO_GUI_CONTAINER      =
**         IO_CALC_FIELD_HANDLER =
*        ).
*      CATCH CX_SALV_DB_CONNECTION.          " Error connecting to database
*      CATCH CX_SALV_DB_TABLE_NOT_SUPPORTED. " DB table / view is not supported
*      CATCH CX_SALV_IDA_CONTRACT_VIOLATION. " IDA API contract violated by caller
*    ENDTRY.

    TRY.
        mo_alv_with_ida = cl_salv_gui_table_ida=>create_for_cds_view(
          EXPORTING
            iv_cds_view_name               = mc_cds_view_name
*           io_gui_container               =
*           io_calc_field_handler          =
      ).
      CATCH cx_salv_db_connection.
      CATCH cx_salv_db_table_not_supported.
      CATCH cx_salv_ida_contract_violation.
      CATCH cx_salv_function_not_supported.
    ENDTRY.
  ENDMETHOD.


  METHOD GET_INSTANCE.
    IF MO_INSTANCE IS NOT BOUND.
      MO_INSTANCE = NEW YCL_ALV_IDA_010(
          IT_MATNR = IT_MATNR
          IT_MTART = IT_MTART ).
    ENDIF.

    RO_RESULT = MO_INSTANCE.
  ENDMETHOD.


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


  METHOD PROVIDE_SELECT_OPTIONS.
    DATA(lo_collector) = NEW cl_salv_range_tab_collector( ).

*    lo_collector->add_ranges_for_name(
*      iv_name = 'UNIT_OF_MEASUREMENT'
*      it_ranges = it_uom_selection
*    ).
*
*    lo_collector->add_ranges_for_name(
*      iv_name = 'LANGUAGE'
*      it_ranges = it_language_selection
*    ).

    lo_collector->get_collected_ranges(
      IMPORTING
        et_named_ranges = DATA(lt_ranges)
    ).

    TRY.
        mo_alv_with_ida->set_select_options(
           EXPORTING
             it_ranges                     = lt_ranges
*            io_condition                  =
        ).
      CATCH cx_salv_ida_associate_invalid.
      CATCH cx_salv_db_connection.
      CATCH cx_salv_ida_condition_invalid.
      CATCH cx_salv_ida_unknown_name.
    ENDTRY.
  ENDMETHOD.


  METHOD REGISTER_DOUBLE_CLICK_EVENT.

    TRY.
        MO_ALV_WITH_IDA->SELECTION( )->SET_SELECTION_MODE(
          IF_SALV_GUI_SELECTION_IDA=>CS_SELECTION_MODE-MULTI
        ).

      CATCH CX_SALV_IDA_CONTRACT_VIOLATION.
    ENDTRY.


    MO_ALV_WITH_IDA->DISPLAY_OPTIONS( )->ENABLE_DOUBLE_CLICK( ).

    SET HANDLER :
      ON_DOUBLE_CLICK_ON_CELL FOR MO_ALV_WITH_IDA->DISPLAY_OPTIONS( ).

  ENDMETHOD.


  METHOD REGISTER_TOOLBAR_EVENT.

    SET HANDLER :
      on_toolbar_function_selected FOR mo_alv_with_ida->toolbar( ).

  ENDMETHOD.


  METHOD YIF_ALV_IDA~DISPLAY.
    TRY.
        mo_alv_with_ida->fullscreen( )->display( ).
      CATCH cx_salv_ida_contract_violation.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
