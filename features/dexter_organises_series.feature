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
    Then the following directories should exist:
      | Video/Dexter/S01                 |

  @announce
  Scenario: Dexter organises using a custom format 
    Given a directory named "Downloads"
    And a directory named "Downloads/mess"
    And a directory named "Video"
    And an empty file named "Downloads/dexter s01e09.avi"
    When I run "dexter --input \"Downloads/dexter s01e09.avi\" --output Video --format \":name (Season :season)/:name S:seasonE:episode.:extension\""
    Then the following directories should exist:
      | Video/Dexter (Season 01)                 |

  @announce
  Scenario: Dexter isn't verbose
    Given a directory named "Downloads"
    And a directory named "Downloads/mess"
    And a directory named "Video"
    And an empty file named "Downloads/dexter s01e09.avi"
    When I run "dexter --input \"Downloads/dexter s01e09.avi\" --output Video --verbose false"
    Then the following directories should exist:
      | Video/Dexter/S01                 |
    And the output should contain exactly ""
      
  @announce
  Scenario: Dexter organizes a whole directory 
    Given a directory named "Downloads"
    And a directory named "Downloads/mess"
    And a directory named "Video"
    And an empty file named "Downloads/dexter s01e09.avi"
    And an empty file named "Downloads/Fringe.1x03.HDTV.avi"
    And an empty file named "Downloads/The.big.bang.theory.s01e09.avi"
    And an empty file named "Downloads/mess/MY NAME IS EARL - s08e04 HDTV.avi"
    When I run "dexter --input Downloads --output Video"
    Then the following directories should exist:
      | Video/Dexter/S01                 |
      | Video/The Big Bang Theory/S01    |
      | Video/Fringe/S01                 |
      | Video/My Name Is Earl/S08        |
