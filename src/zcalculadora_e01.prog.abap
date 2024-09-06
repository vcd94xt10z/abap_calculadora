MODULE pbo_9000 OUTPUT.
  SET PF-STATUS 'S9000'.
  SET TITLEBAR 'T9000'.
ENDMODULE.
MODULE pai_9000 INPUT.
  " numeros
  IF strlen( sy-ucomm ) >= 3 AND sy-ucomm(3) = 'NUM'.
    REPLACE ALL OCCURRENCES OF 'NUM' IN sy-ucomm WITH ''.
    CONCATENATE gs_data-visor sy-ucomm INTO gs_data-visor SEPARATED BY ''.
    CONDENSE gs_data-visor NO-GAPS.
  ENDIF.

  IF sy-ucomm = 'OP_BS'.
    go_main->backspace( ).
    EXIT.
  ENDIF.

  " operacoes
  IF sy-ucomm(2) = 'OP'.
    APPEND gs_data-visor TO gt_buffer.
    gs_data-visor = ''.
  ENDIF.

  CASE sy-ucomm.
  WHEN 'OP_MINUS'. APPEND '-' TO gt_buffer.
  WHEN 'OP_PLUS'.  APPEND '+' TO gt_buffer.
  WHEN 'OP_MUL'.   APPEND '*' TO gt_buffer.
  WHEN 'OP_DIV'.   APPEND '/' TO gt_buffer.
  WHEN 'OP_EQ'.
    go_main->calc( ).
  WHEN 'OP_CE'.
    gs_data-visor = ''.
    CLEAR gt_buffer.
  WHEN 'BACK' OR 'UP' OR 'CANCEL'.
    LEAVE TO SCREEN 0.
  ENDCASE.

  CONCATENATE LINES OF gt_buffer INTO gs_data-memoria SEPARATED BY ' '.
ENDMODULE.
