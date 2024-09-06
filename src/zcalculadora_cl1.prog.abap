CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS calc.
    METHODS backspace.
    METHODS remove_zeros_visor.
endclass.
CLASS lcl_main IMPLEMENTATION.
  METHOD backspace.
    DATA: ld_length TYPE int4.
    ld_length = strlen( gs_data-visor ) - 1.
    IF ld_length <= 0.
      gs_data-visor = ''.
    ELSE.
      gs_data-visor = gs_data-visor(ld_length).
    ENDIF.
  ENDMETHOD.
  METHOD remove_zeros_visor.
    DATA: ld_length TYPE int4.
    DATA: ld_index  TYPE int4.
    DATA: ld_char   TYPE char1.

    CONDENSE gs_data-visor NO-GAPS.
    ld_length = strlen( gs_data-visor ).
    DO ld_length TIMES.
      ld_index = ld_length - sy-index.
      ld_char = gs_data-visor+ld_index(1).
      IF ld_char = '0'.
        CONTINUE.
      ENDIF.

      IF ld_char <> '.'.
        ld_index = ld_index + 1.
      ENDIF.
      gs_data-visor = gs_data-visor(ld_index).
      EXIT.
    ENDDO.
  ENDMETHOD.
  METHOD calc.
    DATA: ld_result(16)  TYPE p DECIMALS 14.
    DATA: ld_number1(16) TYPE p DECIMALS 14.
    DATA: ld_number2(16) TYPE p DECIMALS 14.
    DATA: ld_buffer      TYPE string.
    DATA: ld_operation   TYPE string.
    DATA: ld_step        TYPE char10.

    ld_result = 0.

    LOOP AT gt_buffer INTO ld_buffer.
      CASE ld_buffer.
      WHEN '-' OR '+' OR '*' OR '/'.
        ld_operation = ld_buffer.
        CONTINUE.
      WHEN OTHERS.
        IF ld_step = ''.
          ld_number1 = ld_buffer.
          ld_step = 'number2'.
          CONTINUE.
        ENDIF.

        IF ld_step = 'number2'.
          ld_number2 = ld_buffer.
          ld_step = 'calc'.
        ENDIF.
      ENDCASE.

      IF ld_step = 'calc'.
        CASE ld_operation.
        WHEN '-'. ld_result = ld_number1 - ld_number2.
        WHEN '+'. ld_result = ld_number1 + ld_number2.
        WHEN '*'. ld_result = ld_number1 * ld_number2.
        WHEN '/'. ld_result = ld_number1 / ld_number2.
        ENDCASE.

        gs_data-visor = ld_result.
        ld_step = 'number2'.
        ld_number1 = ld_result.
        ld_number2 = 0.
      ENDIF.
    ENDLOOP.

    me->remove_zeros_visor( ).

    " resetando calculadora no final
    CLEAR gt_buffer.
    CLEAR gs_data-memoria.
    CONCATENATE LINES OF gt_buffer INTO gs_data-memoria SEPARATED BY ' '.
  ENDMETHOD.
ENDCLASS.
