import mysql.connector

# Connect to MySQL
mydb = mysql.connector.connect(
    user='testuser',
    passwd='testuser',
    database='PDA',   # Lab7 database
    host='127.0.0.1',
    allow_local_infile=True
)

print("Connected:", mydb)

# Create a cursor
myc = mydb.cursor()

# Show all databases
print("\nDatabases on server:")
myc.execute("SHOW DATABASES")
for db in myc:
    print(" -", db[0])

# List tables in PDA
print("\nTables in PDA:")
myc.execute("SHOW TABLES")
for table in myc:
    print(" -", table[0])

# Game search menu

search_type= input("\nWhat would you like to search for?\n 1. Title\n 2. Genre\n 3. Platform\n 4. Publisher\nEnter choice (1-4): ").strip()

if search_type == "1":
    print("Game title search")


    # Get user input for game title search
    game_title = input("\nEnter game title (or part of it): ").strip()

    if not game_title:
        print("ERROR: Title cannot be empty.")
    else:
        print(f"\nSearching for games with '{game_title}' in the title...\n")
        
        # SQL query to search for games by title with joins
        search_query = """
        SELECT g.game_id, g.title, gen.name as genre, p.name as platform, 
            pub.name as publisher, gr.release_date
        FROM Game g
        JOIN GameRelease gr ON g.game_id = gr.game_id
        JOIN Genre gen ON gr.genre_id = gen.genre_id
        JOIN Platform p ON gr.platform_id = p.platform_id
        JOIN Publisher pub ON gr.publisher_id = pub.publisher_id
        WHERE g.title LIKE %s
        ORDER BY gr.release_date DESC
        """
        
        # Execute the search query
        myc.execute(search_query, (f"%{game_title}%",))
        results = myc.fetchall()
        
        # Display results
        if results:
            print(f"SEARCH RESULTS: Found {len(results)} game(s)")
            
            for idx, game in enumerate(results, 1):
                print(f"\n{idx}. {game[1]}")  # game[1] is title
                print(f"   Genre:        {game[2]}")  # game[2] is genre
                print(f"   Platform:     {game[3]}")  # game[3] is platform
                print(f"   Publisher:    {game[4]}")  # game[4] is publisher
                print(f"   Release Date: {game[5]}")  # game[5] is release_date
                print(f"   Game ID:      {game[0]}")  # game[0] is game_id
        else:

            print(f"NO RESULTS: No games found matching '{game_title}'")

elif search_type == "2":
    print("GAMES BY GENRE")

    
    # First, fetch all available genres
    print("\nFetching available genres...\n")
    genre_query = "SELECT genre_id, name FROM Genre ORDER BY name"
    myc.execute(genre_query)
    genres = myc.fetchall()
    
    if genres:
        print("Available Genres:")
        for idx, genre in enumerate(genres, 1):
            print(f"  {idx}. {genre[1]}")  # genre[1] is name
        
        try:
            genre_choice = int(input("\nSelect a genre number: ").strip())
            
            if 1 <= genre_choice <= len(genres):
                selected_genre = genres[genre_choice - 1][1]  # Get genre name
                
                print(f"\nSearching for games in '{selected_genre}' genre...\n")
                
                # SQL query to search for games by genre
                search_by_genre_query = """
                SELECT g.game_id, g.title, p.name as platform, 
                       pub.name as publisher, gr.release_date
                FROM Game g
                JOIN GameRelease gr ON g.game_id = gr.game_id
                JOIN Genre gen ON gr.genre_id = gen.genre_id
                JOIN Platform p ON gr.platform_id = p.platform_id
                JOIN Publisher pub ON gr.publisher_id = pub.publisher_id
                WHERE gen.name = %s
                ORDER BY gr.release_date DESC
                """
                
                # Execute the search query
                myc.execute(search_by_genre_query, (selected_genre,))
                results = myc.fetchall()
                
                # Display results
                if results:
                    print("="*70)
                    print(f"SEARCH RESULTS: Found {len(results)} game(s)")
                    
                    for idx, game in enumerate(results, 1):
                        print(f"\n{idx}. {game[1]}")  # game[1] is title
                        print(f"   Genre:        {selected_genre}")  # selected_genre
                        print(f"   Platform:     {game[2]}")  # game[2] is platform
                        print(f"   Publisher:    {game[3]}")  # game[3] is publisher
                        print(f"   Release Date: {game[4]}")  # game[4] is release_date
                        print(f"   Game ID:      {game[0]}")  # game[0] is game_id
                else:
                    print("="*70)
                    print(f"NO RESULTS: No games found in '{selected_genre}' genre")
                    print("="*70)
            else:
                print("ERROR: Invalid selection. Please enter a valid genre number.")
        
        except ValueError:
            print("ERROR: Please enter a valid number.")
    else:
        print("ERROR: No genres found in the database.")



elif search_type == "3":
    print("\n" + "="*70)
    print("GAMES BY PLATFORM")
    print("="*70)
    
    # First, fetch all available platforms
    print("\nFetching available platforms...\n")
    platform_query = "SELECT platform_id, name FROM Platform ORDER BY name"
    myc.execute(platform_query)
    platforms = myc.fetchall()
    
    if platforms:
        print("Available Platforms:")
        for idx, platform in enumerate(platforms, 1):
            print(f"  {idx}. {platform[1]}")  # platform[1] is name
        
        try:
            platform_choice = int(input("\nSelect a platform number: ").strip())
            
            if 1 <= platform_choice <= len(platforms):
                selected_platform = platforms[platform_choice - 1][1]  # Get platform name
                
                print(f"\nSearching for games on '{selected_platform}' platform...\n")
                
                # SQL query to search for games by platform
                search_by_platform_query = """
                SELECT g.game_id, g.title, gen.name as genre, 
                       pub.name as publisher, gr.release_date
                FROM Game g
                JOIN GameRelease gr ON g.game_id = gr.game_id
                JOIN Platform p ON gr.platform_id = p.platform_id
                JOIN Genre gen ON gr.genre_id = gen.genre_id
                JOIN Publisher pub ON gr.publisher_id = pub.publisher_id
                WHERE p.name = %s
                ORDER BY gr.release_date DESC
                """
                
                # Execute the search query
                myc.execute(search_by_platform_query, (selected_platform,))
                results = myc.fetchall()
                
                # Display results
                if results:
                    print("="*70)
                    print(f"SEARCH RESULTS: Found {len(results)} game(s)")
                    
                    for idx, game in enumerate(results, 1):
                        print(f"\n{idx}. {game[1]}")  # game[1] is title
                        print(f"   Genre:        {game[2]}")  # game[2] is genre
                        print(f"   Platform:     {selected_platform}")  # selected_platform
                        print(f"   Publisher:    {game[3]}")  # game[3] is publisher
                        print(f"   Release Date: {game[4]}")  # game[4] is release_date
                        print(f"   Game ID:      {game[0]}")  # game[0] is game_id
                else:
                    print("="*70)
                    print(f"NO RESULTS: No games found on '{selected_platform}' platform")
                    print("="*70)
            else:
                print("ERROR: Invalid selection. Please enter a valid platform number.")
        
        except ValueError:
            print("ERROR: Please enter a valid number.")
    else:
        print("ERROR: No platforms found in the database.")

elif search_type == "4":
    print("\n" + "="*70)
    print("GAMES BY PUBLISHER")
    print("="*70)
    
    # First, fetch all available publishers
    print("\nFetching available publishers...\n")
    publisher_query = "SELECT publisher_id, name FROM Publisher ORDER BY name"
    myc.execute(publisher_query)
    publishers = myc.fetchall()
    
    if publishers:
        print("Available Publishers:")
        for idx, publisher in enumerate(publishers, 1):
            print(f"  {idx}. {publisher[1]}")  # publisher[1] is name
        
        try:
            publisher_choice = int(input("\nSelect a publisher number: ").strip())
            
            if 1 <= publisher_choice <= len(publishers):
                selected_publisher = publishers[publisher_choice - 1][1]  # Get publisher name
                
                print(f"\nSearching for games by '{selected_publisher}' publisher...\n")
                
                # SQL query to search for games by publisher
                search_by_publisher_query = """
                SELECT g.game_id, g.title, gen.name as genre, 
                       p.name as platform, gr.release_date
                FROM Game g
                JOIN GameRelease gr ON g.game_id = gr.game_id
                JOIN Publisher pub ON gr.publisher_id = pub.publisher_id
                JOIN Genre gen ON gr.genre_id = gen.genre_id
                JOIN Platform p ON gr.platform_id = p.platform_id
                WHERE pub.name = %s
                ORDER BY gr.release_date DESC
                """
                
                # Execute the search query
                myc.execute(search_by_publisher_query, (selected_publisher,))
                results = myc.fetchall()
                
                # Display results
                if results:
                    print("="*70)
                    print(f"SEARCH RESULTS: Found {len(results)} game(s)")
                    
                    for idx, game in enumerate(results, 1):
                        print(f"\n{idx}. {game[1]}")  # game[1] is title
                        print(f"   Genre:        {game[2]}")  # game[2] is genre
                        print(f"   Platform:     {game[3]}")  # game[3] is platform
                        print(f"   Publisher:    {selected_publisher}")  # selected_publisher
                        print(f"   Release Date: {game[4]}")  # game[4] is release_date
                        print(f"   Game ID:      {game[0]}")  # game[0] is game_id
                else:
                    print("="*70)
                    print(f"NO RESULTS: No games found by '{selected_publisher}' publisher")
                    print("="*70)
            else:
                print("ERROR: Invalid selection. Please enter a valid publisher number.")
        
        except ValueError:
            print("ERROR: Please enter a valid number.")
    else:
        print("ERROR: No publishers found in the database.")
else:
    print("\nERROR: Invalid choice. Please enter 1, 2, 3, or 4.")



# Close cursor and connection
myc.close()
mydb.close()
print("\n✓ Database connection closed.")



