===============================================================================
                    GUTENDX API - BOOK READING INSTRUCTIONS
===============================================================================

OVERVIEW
--------
This guide shows you how to READ books online using the Gutendx API without 
downloading them to your device. Perfect for web applications, online readers, 
or quick book browsing.

WHAT IS GUTENDX?
---------------
Gutendx is a free JSON web API that provides access to over 70,000 public 
domain books from Project Gutenberg. It allows you to:
- Search through thousands of classic books
- Access books in multiple formats (TXT, HTML, EPUB, PDF)
- Read books directly in your browser
- Filter by author, language, topic, and time period
- Get detailed book metadata and author information

All books are completely FREE and in the public domain, meaning no copyright 
restrictions and no registration required.

BASE API URL: https://gutendx.com

===============================================================================
                         UNDERSTANDING THE API
===============================================================================

API STRUCTURE
-------------
The Gutendx API uses simple REST endpoints:

1. BOOK LISTS: /books (with optional search parameters)
   Returns paginated lists of books matching your criteria

2. INDIVIDUAL BOOKS: /books/{id} 
   Returns detailed information about a specific book

3. SEARCH PARAMETERS: Added as URL parameters (?parameter=value)
   Allows filtering and searching through the book collection

RESPONSE FORMAT
---------------
All API responses return JSON data in this structure:

For book lists:
{
  "count": 70000,                    // Total books matching search
  "next": "URL to next page",        // Next page of results
  "previous": "URL to previous page", // Previous page of results  
  "results": [...]                   // Array of book objects (max 32)
}

For individual books:
{
  "id": 1342,                        // Project Gutenberg ID
  "title": "Pride and Prejudice",    // Book title
  "authors": [...],                  // Author information
  "subjects": [...],                 // Book topics/subjects
  "languages": ["en"],               // Language codes
  "formats": {                       // Available download formats
    "text/plain": "URL to .txt file",
    "text/html": "URL to .html file",
    "application/epub+zip": "URL to .epub file"
  },
  "download_count": 45000            // Popularity metric
}

SEARCH PARAMETERS EXPLAINED
---------------------------
Here are all the ways you can search and filter books:

search=TERM
  - Searches in book titles and author names
  - Example: ?search=shakespeare
  - Example: ?search=alice%20wonderland (use %20 for spaces)

languages=CODE
  - Filter by language (2-letter codes)
  - Example: ?languages=en (English only)
  - Example: ?languages=en,fr,de (multiple languages)

topic=KEYWORD  
  - Search in book subjects and categories
  - Example: ?topic=children
  - Example: ?topic=science%20fiction

author_year_start=YEAR & author_year_end=YEAR
  - Filter by when authors were alive
  - Example: ?author_year_start=1800&author_year_end=1899 (19th century)
  - Example: ?author_year_end=-500 (before 500 BCE)

ids=NUMBER,NUMBER
  - Get specific books by their ID numbers
  - Example: ?ids=11,1342,74

copyright=true/false/null
  - Filter by copyright status
  - false = public domain (most Project Gutenberg books)
  - true = still under copyright
  - null = unknown copyright status

sort=METHOD
  - popular (default) = most downloaded first
  - ascending = lowest ID numbers first  
  - descending = highest ID numbers first

mime_type=TYPE
  - Filter by available file formats
  - Example: ?mime_type=text%2Fplain (books with .txt files)
  - Example: ?mime_type=application%2Fepub (books with .epub files)

COMBINING PARAMETERS
-------------------
You can combine multiple parameters with & symbol:
?search=dickens&languages=en&sort=popular&author_year_start=1800

===============================================================================
                              QUICK START
===============================================================================

1. FIND A BOOK
   URL: https://gutendx.com/books?search=YOUR_SEARCH_TERM
   Example: https://gutendx.com/books?search=alice%20wonderland

2. GET BOOK DETAILS  
   URL: https://gutendx.com/books/BOOK_ID
   Example: https://gutendx.com/books/11

3. READ THE BOOK
   Use the URLs from the "formats" section in the book details

===============================================================================
                           READING FORMATS
===============================================================================

TEXT FORMAT (Best for simple reading)
-------------------------------------
- Format: "text/plain"
- File type: .txt
- Pros: Fast loading, works everywhere
- Cons: No formatting, plain text only

Example URL: https://www.gutenberg.org/files/11/11-0.txt

HTML FORMAT (Best for formatted reading)
----------------------------------------
- Format: "text/html" 
- File type: .htm/.html
- Pros: Formatted text, chapters, table of contents
- Cons: Slightly larger file size

Example URL: https://www.gutenberg.org/files/11/11-h/11-h.htm

EPUB FORMAT (Best for e-readers)
--------------------------------
- Format: "application/epub+zip"
- File type: .epub
- Pros: Professional formatting, works in e-reader apps
- Cons: Need compatible app/browser

Example URL: https://www.gutenberg.org/ebooks/11.epub.noimages

===============================================================================
                        STEP-BY-STEP READING GUIDE
===============================================================================

STEP 1: SEARCH FOR A BOOK
-------------------------
Open your browser and go to:
https://gutendx.com/books?search=BOOK_NAME

Replace BOOK_NAME with what you want to read:
- alice%20wonderland (for "Alice in Wonderland")
- shakespeare (for Shakespeare's works)
- pride%20prejudice (for "Pride and Prejudice")

STEP 2: FIND THE BOOK ID
------------------------
Look for the book you want in the search results.
Find the "id" number (example: "id": 11)

STEP 3: GET BOOK DETAILS
------------------------
Go to: https://gutendx.com/books/BOOK_ID
Replace BOOK_ID with the number from step 2
Example: https://gutendx.com/books/11

STEP 4: CHOOSE READING FORMAT
-----------------------------
Look for the "formats" section in the results.
Choose your preferred format:

For simple reading: Copy the "text/plain" URL
For formatted reading: Copy the "text/html" URL  
For e-reader: Copy the "application/epub+zip" URL

STEP 5: START READING
--------------------
Paste the URL from step 4 into your browser
The book will open and you can start reading!

===============================================================================
                            READING EXAMPLES
===============================================================================

EXAMPLE 1: READ ALICE IN WONDERLAND
-----------------------------------
1. Search: https://gutendx.com/books?search=alice%20wonderland
2. Get book: https://gutendx.com/books/11
3. Read HTML: https://www.gutenberg.org/files/11/11-h/11-h.htm
4. Read Text: https://www.gutenberg.org/files/11/11-0.txt

EXAMPLE 2: READ PRIDE AND PREJUDICE  
-----------------------------------
1. Search: https://gutendx.com/books?search=pride%20prejudice
2. Get book: https://gutendx.com/books/1342
3. Read HTML: https://www.gutenberg.org/files/1342/1342-h/1342-h.htm
4. Read Text: https://www.gutenberg.org/files/1342/1342-0.txt

EXAMPLE 3: READ SHAKESPEARE
---------------------------
1. Search: https://gutendx.com/books?search=shakespeare
2. Pick a book (example: Romeo and Juliet - ID 1513)
3. Get book: https://gutendx.com/books/1513
4. Read: Use any format URL from the results

===============================================================================
                          ADVANCED READING TIPS
===============================================================================

FIND POPULAR BOOKS
------------------
URL: https://gutendx.com/books?sort=popular
This shows the most downloaded books first

BROWSE BY LANGUAGE
------------------
English only: https://gutendx.com/books?languages=en
French only: https://gutendx.com/books?languages=fr
Multiple: https://gutendx.com/books?languages=en,fr

FIND BOOKS BY TOPIC
-------------------
Children's books: https://gutendx.com/books?topic=children
Science fiction: https://gutendx.com/books?topic=science%20fiction
Adventure: https://gutendx.com/books?topic=adventure

BROWSE BY AUTHOR PERIOD
-----------------------
19th century: https://gutendx.com/books?author_year_start=1800&author_year_end=1899
Modern: https://gutendx.com/books?author_year_start=1900

===============================================================================
                           MOBILE READING
===============================================================================

FOR PHONES/TABLETS
------------------
1. Use HTML format for best mobile experience
2. HTML pages usually have responsive design
3. Text format works but may not look as good
4. EPUB format works great in dedicated e-reader apps

RECOMMENDED MOBILE WORKFLOW
---------------------------
1. Search on mobile browser: https://gutendx.com/books?search=BOOK_NAME
2. Find book ID in results
3. Go to: https://gutendx.com/books/BOOK_ID  
4. Copy the "text/html" URL
5. Open URL in new tab to start reading

===============================================================================
                          TROUBLESHOOTING
===============================================================================

PROBLEM: Book won't load
SOLUTION: Try different format (text/plain instead of text/html)

PROBLEM: Search returns no results  
SOLUTION: Try simpler search terms (use "alice" instead of "alice wonderland")

PROBLEM: Can't find book ID
SOLUTION: Look for "id": NUMBER in the search results JSON

PROBLEM: Format not available
SOLUTION: Not all books have all formats, try text/plain (most common)

PROBLEM: Page loads slowly
SOLUTION: Use text/plain format for faster loading

===============================================================================
                         USEFUL SEARCH EXAMPLES
===============================================================================

BASIC SEARCHES
--------------
Most popular books:
https://gutendx.com/books?sort=popular

All books (paginated):
https://gutendx.com/books

Search by title/author:
https://gutendx.com/books?search=alice%20wonderland
https://gutendx.com/books?search=shakespeare
https://gutendx.com/books?search=dickens
https://gutendx.com/books?search=mark%20twain

SEARCH BY TOPIC/GENRE
--------------------
Classic literature:
https://gutendx.com/books?topic=classic

Detective/Mystery stories:
https://gutendx.com/books?topic=detective

Children's stories:
https://gutendx.com/books?topic=children

Science fiction:
https://gutendx.com/books?topic=science%20fiction

Adventure stories:
https://gutendx.com/books?topic=adventure

Poetry:
https://gutendx.com/books?topic=poetry

Short stories:
https://gutendx.com/books?topic=short%20stories

Romance novels:
https://gutendx.com/books?topic=romance

Historical fiction:
https://gutendx.com/books?topic=historical

Philosophy:
https://gutendx.com/books?topic=philosophy

SEARCH BY LANGUAGE
------------------
English books only:
https://gutendx.com/books?languages=en

French books only:
https://gutendx.com/books?languages=fr

German books only:
https://gutendx.com/books?languages=de

Spanish books only:
https://gutendx.com/books?languages=es

Multiple languages:
https://gutendx.com/books?languages=en,fr,de

SEARCH BY TIME PERIOD
---------------------
Ancient authors (before 0 CE):
https://gutendx.com/books?author_year_end=-1

Medieval authors (500-1500 CE):
https://gutendx.com/books?author_year_start=500&author_year_end=1500

Renaissance authors (1400-1600):
https://gutendx.com/books?author_year_start=1400&author_year_end=1600

18th century authors:
https://gutendx.com/books?author_year_start=1700&author_year_end=1799

19th century authors (Victorian era):
https://gutendx.com/books?author_year_start=1800&author_year_end=1899

Early 20th century authors:
https://gutendx.com/books?author_year_start=1900&author_year_end=1950

SEARCH BY SPECIFIC AUTHORS
--------------------------
Jane Austen:
https://gutendx.com/books?search=austen

Charles Dickens:
https://gutendx.com/books?search=dickens

William Shakespeare:
https://gutendx.com/books?search=shakespeare

Mark Twain:
https://gutendx.com/books?search=twain

Lewis Carroll:
https://gutendx.com/books?search=carroll

Arthur Conan Doyle:
https://gutendx.com/books?search=doyle

Edgar Allan Poe:
https://gutendx.com/books?search=poe

H.G. Wells:
https://gutendx.com/books?search=wells

Jules Verne:
https://gutendx.com/books?search=verne

Oscar Wilde:
https://gutendx.com/books?search=wilde

ADVANCED COMBINED SEARCHES
--------------------------
Popular English classics:
https://gutendx.com/books?languages=en&topic=classic&sort=popular

19th century English novels:
https://gutendx.com/books?languages=en&author_year_start=1800&author_year_end=1899&sort=popular

Children's books in English:
https://gutendx.com/books?topic=children&languages=en&sort=popular

Detective stories by British authors:
https://gutendx.com/books?topic=detective&languages=en&sort=popular

Short stories from any era:
https://gutendx.com/books?topic=short%20stories&sort=popular

Science fiction classics:
https://gutendx.com/books?topic=science%20fiction&languages=en&sort=popular

Poetry in multiple languages:
https://gutendx.com/books?topic=poetry&languages=en,fr,de&sort=popular

Public domain books only:
https://gutendx.com/books?copyright=false&sort=popular

SPECIFIC BOOK ID SEARCHES
-------------------------
Get multiple famous books at once:
https://gutendx.com/books?ids=11,1342,74,2701,1661

Famous book IDs to try:
- 11: Alice's Adventures in Wonderland
- 1342: Pride and Prejudice  
- 74: The Adventures of Tom Sawyer
- 2701: Moby Dick
- 1661: The Adventures of Sherlock Holmes
- 1952: The Yellow Wallpaper
- 345: Dracula
- 84: Frankenstein
- 25344: The Scarlet Letter
- 1184: The Count of Monte Cristo

SEARCHING FOR SPECIFIC FORMATS
------------------------------
Books available as plain text:
https://gutendx.com/books?mime_type=text%2Fplain

Books available as HTML:
https://gutendx.com/books?mime_type=text%2Fhtml

Books available as EPUB:
https://gutendx.com/books?mime_type=application%2Fepub

Books available as PDF:
https://gutendx.com/books?mime_type=application%2Fpdf

===============================================================================
                              NOTES
===============================================================================

- All books are FREE and in the public domain
- No registration or login required
- Works on any device with internet browser
- Over 70,000 books available
- Books available in multiple languages
- New books added regularly

For downloading instead of reading online, see the main README.md file.

===============================================================================
                           HAPPY READING!
===============================================================================