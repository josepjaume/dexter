Feature: Dexter organises series

  In order to order my TV series in a clean and neat manner
  As a great series freak
  Dexter should be able to get its name and season & episode numbers and move them to its appropiate paths

  #@announce
  Scenario: Basic 1 file move
    Given a directory named "Downloads"
    And a directory named "Downloads/mess"
    And a directory named "Video"
    And an empty file named "Downloads/dexter s01e09.avi"
    And an empty file named "Downloads/Fringe.1x03.HDTV.avi"
    And an empty file named "Downloads/The.big.bang.theory.s01e09.avi"
    And an empty file named "Downloads/mess/MY NAME IS EARL - s08e04 HDTV.avi"
    When I run "../../bin/dexter --input Downloads --output Video"
    Then the following directories should exist:
      | Video/Dexter/S01                 |
      | Video/The Big Bang Theory/S01    |
      | Video/Fringe/S01                 |
      | Video/My Name Is Earl/S08        |
