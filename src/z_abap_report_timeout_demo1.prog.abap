*&---------------------------------------------------------------------*
*& Report z_abap_report_timeout_demo1
*&---------------------------------------------------------------------*
*& this demonstrates the timeout and exits immediately after reaching it
*&---------------------------------------------------------------------*
REPORT z_abap_report_timeout_demo1.


CLASS lcl_report DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      run.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

PARAMETERS:
  ptimeout TYPE i DEFAULT 3.



START-OF-SELECTION.
  NEW lcl_report( )->run( ).



CLASS lcl_report IMPLEMENTATION.
  METHOD run.
    NEW zcl_abap_report_timeout( timeout_in_seconds = ptimeout
                                 exit_immediately   = abap_true ).

    WRITE |Exiting in { ptimeout } seconds|.
  ENDMETHOD.

ENDCLASS.
