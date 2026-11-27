import psycopg2
from tabulate import tabulate
"""
Note: It's essential never to include database credentials in code pushed to GitHub. 
Instead, sensitive information should be stored securely and accessed through environment variables or similar. 
However, in this particular exercise, we are allowing it for simplicity, as the focus is on a different aspect.
Remember to follow best practices for secure coding in production environments.
"""

#Öppna terminalen

# scp "C:\Users\CNG\OneDrive\KTH\DD1368 Databasteknik för D\Module 4\connect.py" elinys@staff-shell-1.sys.kth.se:~/Documents/
# Skriv lösen

# ssh elinys@staff-shell-1.sys.kth.se
# skriv lösen

# cd Documents
# python3 connect.py

# Acquire a connection to the database by specifying the credentials.
conn = psycopg2.connect(
    host="psql-dd1368-ht26.sys.kth.se", 
    database="elinys",
    user="elinys",
    password="8s6Lvzde",
    options = "-c search_path=lab3")
print(conn)

# Create a cursor. The cursor allows you to execute database queries.
cur = conn.cursor()

def get_airports():
    iata = input("Please enter the IATA-code (empty or partial is okay): ")
    name = input("Please enter the airport-name (empty or partial is okay): ")

    query = f"""SELECT 
                    Name, 
                    IATACode,
                    Country 
                FROM Airport
                WHERE IATACode LIKE '%{iata}%' AND Name LIKE '%{name}%';
            """  
    cur.execute(query)
    result = cur.fetchall()
    headers = ["Name", "IATA", "Country"]
    print(tabulate(result, headers= headers, tablefmt="rounded_grid", floatfmt=".0f"))


def get_countries_by_language():
    language = input("Please enter a language: ")
    query = f"""SELECT 
                Country.Name, 
                ROUND(Country.Population * Spoken.Percentage / 100) AS speakers
            FROM Country
            JOIN Spoken ON Country.Code = Spoken.Country
            WHERE Spoken.Language = '{language.capitalize()}'
            ORDER BY speakers DESC;
            """ #SKA JAG GODKÄNNNA DE SOM FÅR NOLL I SPEAKERS? 
    cur.execute(query)
    result = cur.fetchall()
    headers = ["Country", "Speakers"]
    print(tabulate(result, headers= headers, tablefmt="rounded_grid", floatfmt=".0f"))

def insert_deserts():
    pass

if __name__ == "__main__":
    keep_going = True

    while keep_going:
        choice = input(
            """ Choose 1. to search for an airport\n
                Choose 2. to search for a langauge\n
                Choose 3. to create a new desert\n
                Choose 4. to exit\n
                Choice: """)

        try:
            choice = int(choice)
        except:
            print("Not an integer, try again")

        if choice == 1:
            get_airports()
        elif choice == 2: 
            get_countries_by_language()
        elif choice == 3: 
            pass
        elif choice == 4: 
            keep_going = False
        else: 
            print("Not a valid integer, try again")

    conn.close()