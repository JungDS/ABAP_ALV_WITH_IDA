class YCL_YDDMDP_06_010 definition
  public
  inheriting from CL_SADL_GTK_EXPOSURE_MPC
  final
  create public .

public section.
protected section.

  methods GET_PATHS
    redefinition .
  methods GET_TIMESTAMP
    redefinition .
private section.
ENDCLASS.



CLASS YCL_YDDMDP_06_010 IMPLEMENTATION.


  method GET_PATHS.
et_paths = VALUE #(
( |CDS~YDDMDP_06_010| )
).
  endmethod.


  method GET_TIMESTAMP.
RV_TIMESTAMP = 20210907051433.
  endmethod.
ENDCLASS.
