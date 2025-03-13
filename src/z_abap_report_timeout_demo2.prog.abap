*&---------------------------------------------------------------------*
*& Report z_abap_report_timeout_demo2
*&---------------------------------------------------------------------*
*& this demonstrates reaching the timeout while giving the user a choice to stay in the report
*&---------------------------------------------------------------------*
REPORT z_abap_report_timeout_demo2.


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
                                 exit_immediately   = abap_false ).

    WRITE |Timeout in { ptimeout } seconds|.
  ENDMETHOD.

ENDCLASS.
