======================================================================
          WAYBACK DEEP URL EXTRACTOR (ADVANCED VERSION)
======================================================================

Wayback Deep URL Extractor ek powerful reconnaissance tool hai jo 
Internet Archive (Wayback Machine) se kisi bhi domain ke historical 
URLs ko automate aur fast tarike se extract karta hai.

----------------------------------------------------------------------
[+] MUKHYA FEATURES (What's New?)
----------------------------------------------------------------------

1. MULTI-THREADING: Xargs ka upyog karke parallel processing karta hai,
   jo ise purani script se 5x tez banata hai.
2. JUNK FILTERING: --filter flag se images, fonts aur CSS jaise 
   bekaar links ko automatic hata deta hai.
3. SENSITIVE FILE DETECTION: Script ke ant mein .env, .sql, .bak aur 
   .log jaise sensitive files ki report deta hai.
4. DEEP MODE: Archive ke har ek record ko nikaalne ke liye --deep flag.
5. CLEAN OUTPUT: Duplicate URLs ko hata kar automatic sorting karta hai.

----------------------------------------------------------------------
[+] INSTALLATION
----------------------------------------------------------------------

Is script ko chalane ke liye aapke system mein 'curl' aur 'bash' hona 
chahiye (Jo lagbhag har Linux/Termux/macOS mein hota hai).

1. Script ko save karein:
   $ nano wayback_extractor.sh

2. Execution permission dein:
   $ chmod +x wayback_extractor.sh

----------------------------------------------------------------------
[+] USAGE (Kaise Chalayein)
----------------------------------------------------------------------

1. Ek single target ke liye:
   $ ./wayback_extractor.sh example.com

2. Multiple targets (file) ke liye:
   $ ./wayback_extractor.sh -f targets.txt

3. Sirf kaam ke links chahiye (Filter images/css):
   $ ./wayback_extractor.sh example.com --filter

4. Deep extraction aur custom output file:
   $ ./wayback_extractor.sh example.com --deep -o my_results.txt

----------------------------------------------------------------------
[+] ARGUMENTS SUMMARY
----------------------------------------------------------------------

   -f <file>      Targets ki list wali file (e.g., domains.txt)
   -o <file>      Output file ka naam badalne ke liye
   --filter       Faltu files (jpg, png, css) ko hatane ke liye
   --deep         Bina kisi filter ke archive ka saara data nikaalne ke liye

----------------------------------------------------------------------
[!] DISCLAIMER
----------------------------------------------------------------------
Yeh tool sirf educational aur security research purposes ke liye hai.
Hamesha target owner ki permission ke saath hi scanning karein.

======================================================================
developer: ![Uploading 1000104261.jpg…]()
🌸 vishal ❤️ subhi 🌸 
======================================================================
