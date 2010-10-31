Feature: Dexter organises series

  In order to order my TV series in a clean and neat manner
  As a great series freak
  Dexter should be able to get its name and season & episode numbers and move them to its appropiate paths

  @announce
  Scenario: Dexter organizes only one file 
    Given a directory named "Downloads"
    And a directory named "Downloads/mess"
    And a directory named "Video"
    And an empty file named "Downloads/dexter s01e09.avi"
    When I run "dexter --input \"Downloads/dexter s01e09.avi\" --output Video"
    Then the following files should exist:
      | Video/Dexter/S01/Dexter S01E09.avi             |

  @announce
  Scenario: Dexter organizes a subtitle 
    Given a directory named "Downloads"
    And a directory named "Downloads/mess"
    And a directory named "Video"
    And an empty file named "Downloads/dexter s01e09.srt"
    When I run "dexter --input \"Downloads/dexter s01e09.srt\" --output Video"
    Then the following files should exist:
      | Video/Dexter/S01/Dexter S01E09.srt             |
      
  @announce
  Scenario: Dexter tries to move a file that's already organized 
    Given a directory named "Dexter/S01"
    And an empty file named "Dexter/Dexter S01E01.avi"
    When I run "dexter"
    Then the following files should exist:
      | Dexter/S01/Dexter S01E01.avi |

  @announce
  Scenario: Dexter organises using a custom format 
    Given a directory named "Downloads"
    And a directory named "Downloads/mess"
    And a directory named "Video"
    And an empty file named "Downloads/dexter s01e09.avi"
    When I run "dexter --input \"Downloads/dexter s01e09.avi\" --output Video --format \":name (Season :season)/:episode.:extension\""
    Then the following files should exist:
      | Video/Dexter (Season 01)/09.avi                 |

  @announce
  Scenario: Dexter isn't verbose
    Given a directory named "Downloads"
    And a directory named "Downloads/mess"
    And a directory named "Video"
    And an empty file named "Downloads/dexter s01e09.avi"
    When I run "dexter --input \"Downloads/dexter s01e09.avi\" --output Video --verbose false"
    Then the following files should exist:
      | Video/Dexter/S01/Dexter S01E09.avi           |
    And the output should contain exactly ""
      
  @announce
  Scenario: Dexter organizes a whole directory 
    Given a directory named "Downloads"
    And a directory named "Downloads/mess"
    And a directory named "Video"
    And an empty file named "Downloads/dexter s01e09.avi"
    And an empty file named "Downloads/dexter s01e09.srt"
    And an empty file named "Downloads/Fringe.1x03.HDTV.avi"
    And an empty file named "Downloads/The.big.bang.theory.s01e09.avi"
    And an empty file named "Downloads/mess/MY NAME IS EARL - s08e04 HDTV.avi"
    And an empty file named "Downloads/Treme.S01E04.HDTV.XviD-NoTV.avi"
    When I run "dexter --input Downloads --output Video"
    Then the following files should exist:
      | Video/Dexter/S01/Dexter S01E09.srt                           |
      | Video/Dexter/S01/Dexter S01E09.avi                           |
      | Video/Fringe/S01/Fringe S01E03.avi                           |
      | Video/The Big Bang Theory/S01/The Big Bang Theory S01E09.avi |
      | Video/My Name Is Earl/S08/My Name Is Earl S08E04.avi         |
      | Video/Treme/S01/Treme S01E04.avi                             |
