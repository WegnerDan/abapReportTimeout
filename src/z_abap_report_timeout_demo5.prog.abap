*&---------------------------------------------------------------------*
*& Report z_abap_report_timeout_demo2
*&---------------------------------------------------------------------*
*& demo for elapsed seconds
*&---------------------------------------------------------------------*
REPORT z_abap_report_timeout_demo5.


CLASS lcl_report DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      run.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA timeout TYPE REF TO zcl_abap_report_timeout.

    METHODS handle_timeout_reached FOR EVENT timeout_reached OF zcl_abap_report_timeout.
ENDCLASS.

PARAMETERS:
  ptimeout TYPE i DEFAULT 3.



START-OF-SELECTION.
  NEW lcl_report( )->run( ).



CLASS lcl_report IMPLEMENTATION.
  METHOD run.
    timeout = NEW zcl_abap_report_timeout( timeout_in_seconds = ptimeout
                                           exit_immediately   = abap_false ).

    SET HANDLER handle_timeout_reached FOR timeout.

    WRITE |Timeout in { ptimeout } seconds|.
  ENDMETHOD.

  METHOD handle_timeout_reached.
    MESSAGE |You've wasted { timeout->elapsed_seconds } seconds| TYPE 'S'.
  ENDMETHOD.

ENDCLASS.
