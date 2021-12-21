class YCL_ALV_IDA_UOM definition
  public
  final
  create private .

public section.

  interfaces YIF_ALV_IDA .

  types:
    ty_uom_selection TYPE RANGE OF msehi .
  types:
    ty_language_selection TYPE RANGE OF spras .

  methods CONSTRUCTOR
    importing
      !IT_UOM_SELECTION type TY_UOM_SELECTION
      !IT_LANGUAGE_SELECTION type TY_LANGUAGE_SELECTION .
  class-methods GET_INSTANCE
    importing
      !IT_UOM_SELECTION type TY_UOM_SELECTION
      !IT_LANGUAGE_SELECTION type TY_LANGUAGE_SELECTION
    returning
      value(RO_RESULT) type ref to YIF_ALV_IDA .
  PROTECTED SECTION.

  PRIVATE SECTION.
    CONSTANTS mc_cds_view_name TYPE dbtabl VALUE 'YDDMDP_06_040'.

    CLASS-DATA mo_instance TYPE REF TO YIF_ALV_IDA.

    DATA mo_alv_with_ida TYPE REF TO if_salv_gui_table_ida.

    METHODS on_double_click_on_cell FOR EVENT double_click OF if_salv_gui_table_display_opt
      IMPORTING
          ev_field_name
          eo_row_data.

    METHODS on_toolbar_function_selected FOR EVENT function_selected OF if_salv_gui_toolbar_ida
      IMPORTING ev_fcode.

    METHODS create_alv_with_ida.

    METHODS provide_select_options
      IMPORTING
        it_uom_selection      TYPE ty_uom_selection
        it_language_selection TYPE ty_language_selection.

    METHODS activate_text_search.

    METHODS activate_layout_persistence.

    METHODS register_double_click_event.

    METHODS get_row_data
      IMPORTING
        row_object       TYPE REF TO if_salv_gui_row_data_ida
      RETURNING
        VALUE(rs_result) TYPE YVMDP_06_040.

    METHODS add_buttons_to_toolbar.

    METHODS change_toolbar.

    METHODS register_toolbar_event.
ENDCLASS.



CLASS YCL_ALV_IDA_UOM IMPLEMENTATION.


  METHOD ACTIVATE_LAYOUT_PERSISTENCE.
    DATA(ls_persistence_key) = VALUE if_salv_gui_layout_persistence=>ys_persistence_key( report_name = sy-repid
                                                                                         handle = 'ZUOM' ).

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
        mo_alv_with_ida->field_catalog( )->enable_text_search( 'SHORT_TEXT' ).
        mo_alv_with_ida->field_catalog( )->enable_text_search( 'LONG_TEXT' ).
      CATCH cx_salv_ida_unknown_name.
      CATCH cx_salv_call_after_1st_display.
    ENDTRY.
  ENDMETHOD.


  METHOD ADD_BUTTONS_TO_TOOLBAR.
    mo_alv_with_ida->toolbar( )->add_button( iv_fcode                     = 'REFRESH'
                                             iv_icon                      = icon_refresh
                                             iv_is_checked                = abap_false
                                             iv_text                      = space
                                             iv_quickinfo                 = 'Refresh list'
                                             iv_before_standard_functions = abap_false ).

    mo_alv_with_ida->toolbar( )->add_separator( EXPORTING iv_before_standard_functions = abap_true ).
  ENDMETHOD.


  METHOD CHANGE_TOOLBAR.
    add_buttons_to_toolbar( ).
    register_toolbar_event( ).
  ENDMETHOD.


  METHOD CONSTRUCTOR.
    create_alv_with_ida( ).
    provide_select_options( it_uom_selection      = it_uom_selection
                            it_language_selection = it_language_selection ).

    activate_text_search( ).
    activate_layout_persistence( ).
    change_toolbar( ).
    register_double_click_event( ).
  ENDMETHOD.


  METHOD CREATE_ALV_WITH_IDA.
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
    IF mo_instance IS NOT BOUND.
      mo_instance = NEW YCL_ALV_IDA_UOM(
          it_uom_selection      = it_uom_selection
          it_language_selection = it_language_selection ).
    ENDIF.

    ro_result = mo_instance.
  ENDMETHOD.


  METHOD GET_ROW_DATA.
    TRY.
        row_object->get_row_data(
          EXPORTING
            iv_request_type                = if_salv_gui_selection_ida=>cs_request_type-all_fields
*           its_requested_fields           =
          IMPORTING
            es_row                         = rs_result ).

      CATCH cx_salv_ida_contract_violation.
      CATCH cx_salv_ida_sel_row_deleted.
    ENDTRY.
  ENDMETHOD.


  METHOD ON_DOUBLE_CLICK_ON_CELL.
    DATA(ls_row_data) = get_row_data( eo_row_data ).
    DATA(lv_message_text) = |Double click on field in column { ev_field_name }|.
    MESSAGE lv_message_text TYPE 'S'.
  ENDMETHOD.


  METHOD ON_TOOLBAR_FUNCTION_SELECTED.
    mo_alv_with_ida->refresh( ).
  ENDMETHOD.


  METHOD PROVIDE_SELECT_OPTIONS.
    DATA(lo_collector) = NEW cl_salv_range_tab_collector( ).

    lo_collector->add_ranges_for_name( iv_name = 'UNIT_OF_MEASUREMENT'
                                    it_ranges = it_uom_selection ).

    lo_collector->add_ranges_for_name( iv_name = 'LANGUAGE'
                                    it_ranges = it_language_selection ).


    lo_collector->get_collected_ranges( IMPORTING et_named_ranges = DATA(lt_ranges) ).

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
        mo_alv_with_ida->selection( )->set_selection_mode( if_salv_gui_selection_ida=>cs_selection_mode-single ).

      CATCH cx_salv_ida_contract_violation.
    ENDTRY.

    mo_alv_with_ida->display_options( )->enable_double_click( ).
    SET HANDLER on_double_click_on_cell FOR mo_alv_with_ida->display_options( ).
  ENDMETHOD.


  METHOD REGISTER_TOOLBAR_EVENT.
    SET HANDLER on_toolbar_function_selected FOR mo_alv_with_ida->toolbar( ).
  ENDMETHOD.


  METHOD YIF_ALV_IDA~DISPLAY.
    TRY.
        mo_alv_with_ida->fullscreen( )->display( ).
      CATCH cx_salv_ida_contract_violation.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
