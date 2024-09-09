CLASS lcl_main DEFINITION DEFERRED.

  TYPES: BEGIN OF gy_data
       , visor   TYPE string
       , memoria TYPE string
       , END OF gy_data.

DATA: go_main       TYPE REF TO lcl_main.
DATA: gs_data       TYPE gy_data.

DATA: gd_index_curr TYPE int4.
DATA: gd_index_prev TYPE int4.
DATA: gt_buffer     TYPE STANDARD TABLE OF string.
DATA: gd_buffer     TYPE string.
