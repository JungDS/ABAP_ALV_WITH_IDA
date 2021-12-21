interface YIF_ALV_IDA
  public .


  methods DISPLAY .
  methods GET_FIELD_CATALOG
    returning
      value(RO_FIELD_CATALOG) type ref to IF_SALV_GUI_FIELD_CATALOG_IDA .
endinterface.
