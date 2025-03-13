CLASS zcl_abap_report_timeout DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    DATA:
      timeout_in_seconds TYPE i                   READ-ONLY,
      exit_immediately   TYPE abap_bool           READ-ONLY,
      elapsed_seconds    TYPE decfloat34          READ-ONLY,
      timer              TYPE REF TO cl_gui_timer READ-ONLY.

    EVENTS:
      timeout_reached.

    METHODS:
      constructor IMPORTING timeout_in_seconds TYPE i
                            exit_immediately   TYPE abap_bool DEFAULT abap_false
                            start_immediately  TYPE abap_bool DEFAULT abap_true,

      set_timeout          IMPORTING timeout_in_seconds TYPE i         OPTIONAL,

      set_exit_immediately IMPORTING exit_immediately   TYPE abap_bool DEFAULT abap_false,

      start,

      cancel.

  PROTECTED SECTION.
    DATA:
      timestamp_start TYPE timestampl,
      timestamp_end   TYPE timestampl.

    METHODS:
      handle_timer_finished FOR EVENT finished OF cl_gui_timer,

      calculate_elapsed_seconds,

      exit_report,

      popup_stay_or_exit IMPORTING !titlebar          TYPE clike     DEFAULT TEXT-001
                                   text_question      TYPE clike     DEFAULT TEXT-002
                                   text_button_1      TYPE clike     DEFAULT TEXT-003
                                   icon_button_1      TYPE icon-name DEFAULT 'ICON_SYSTEM_BACK'
                                   text_button_2      TYPE clike     DEFAULT TEXT-004
                                   icon_button_2      TYPE icon-name DEFAULT 'ICON_SYSTEM_END'
                                   default_button     TYPE clike     DEFAULT '1'
                                   start_column       TYPE sy-cucol  DEFAULT 25
                                   start_row          TYPE sy-curow  DEFAULT 6
                                   popup_type         TYPE icon-name DEFAULT 'ICON_MESSAGE_CRITICAL'
                                   quickinfo_button_1 TYPE clike     DEFAULT ''
                                   quickinfo_button_2 TYPE clike     DEFAULT ''
                         EXPORTING answer             TYPE string.

ENDCLASS.



CLASS zcl_abap_report_timeout IMPLEMENTATION.
  METHOD constructor.
    timer = NEW #( ).
    SET HANDLER handle_timer_finished FOR timer.

    set_timeout( timeout_in_seconds ).
    set_exit_immediately( exit_immediately ).

    IF start_immediately = abap_true.
      start( ).
    ENDIF.
  ENDMETHOD.

  METHOD set_exit_immediately.
    me->exit_immediately = exit_immediately.
  ENDMETHOD.

  METHOD set_timeout.
    IF timeout_in_seconds IS SUPPLIED.
      me->timeout_in_seconds = timeout_in_seconds.
    ENDIF.
    timer->interval = timeout_in_seconds.
  ENDMETHOD.

  METHOD start.
    IF timestamp_start IS INITIAL.
      GET TIME STAMP FIELD timestamp_start.
    ENDIF.

    timer->run( ).
  ENDMETHOD.

  METHOD cancel.
    timer->cancel( ).
  ENDMETHOD.

  METHOD handle_timer_finished.
    RAISE EVENT timeout_reached.

    IF exit_immediately = abap_true.
      exit_report( ).
      RETURN.
    ENDIF.

    popup_stay_or_exit( IMPORTING answer = DATA(popup_answer) ).
    CASE popup_answer.
      WHEN '1'.
        start( ).
      WHEN '2'.
        exit_report( ).
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD calculate_elapsed_seconds.
    GET TIME STAMP FIELD timestamp_end.
    elapsed_seconds = timestamp_end - timestamp_start.
  ENDMETHOD.

  METHOD exit_report.
    calculate_elapsed_seconds( ).
    LEAVE PROGRAM.
  ENDMETHOD.

  METHOD popup_stay_or_exit.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = titlebar
        text_question         = text_question
        text_button_1         = text_button_1
        icon_button_1         = icon_button_1
        text_button_2         = text_button_2
        icon_button_2         = icon_button_2
        default_button        = default_button
        display_cancel_button = abap_false
        start_column          = start_column
        start_row             = start_row
        popup_type            = popup_type
        iv_quickinfo_button_1 = quickinfo_button_1
        iv_quickinfo_button_2 = quickinfo_button_2
      IMPORTING
        answer                = answer.
  ENDMETHOD.
ENDCLASS.
