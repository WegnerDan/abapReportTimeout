CLASS zcl_abap_report_timeout DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    DATA:
      timeout_in_seconds TYPE i                   READ-ONLY,
      exit_immediately   TYPE abap_bool           READ-ONLY,
      timer              TYPE REF TO cl_gui_timer READ-ONLY.

    METHODS:
      constructor IMPORTING timeout_in_seconds TYPE i
                            exit_immediately   TYPE abap_bool DEFAULT abap_false,

      set_timeout          IMPORTING timeout_in_seconds TYPE i,

      set_exit_immediately IMPORTING exit_immediately   TYPE abap_bool DEFAULT abap_false.

  PROTECTED SECTION.
    METHODS:
      handle_timer_finished FOR EVENT finished OF cl_gui_timer,

      exit_report,

      repeat_timer,

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

    timer->run( ).
  ENDMETHOD.

  METHOD set_exit_immediately.
    me->exit_immediately = exit_immediately.
  ENDMETHOD.

  METHOD set_timeout.
    me->timeout_in_seconds = timeout_in_seconds.
    timer->interval = timeout_in_seconds.
  ENDMETHOD.

  METHOD handle_timer_finished.
    IF exit_immediately = abap_true.
      exit_report( ).
      RETURN.
    ENDIF.

    popup_stay_or_exit( IMPORTING answer = DATA(popup_answer) ).
    CASE popup_answer.
      WHEN '1'.
        repeat_timer( ).
      WHEN '2'.
        exit_report( ).
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD exit_report.
    LEAVE PROGRAM.
  ENDMETHOD.

  METHOD repeat_timer.
    timer->run( ).
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
