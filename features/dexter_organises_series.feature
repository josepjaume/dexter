Feature: Dexter organises series
  In order to order my TV series in a clean and neat manner
  As a great series freak
  Dexter should be able to get its name and season & episode numbers and move them to its appropiate paths

  Scenario: Basic 1 file move
    Given a directory named "Downloads"
    And a directory named "Video"
    And an empty file named "Downloads/dexter s01e09.avi"
    When I run "dexter Downloads Video"
    Then the following directories should exist:
      |Video/Dexter/S01|

