from csv import Dialect
import io
import pandas as pd 
import re

 

# for encoding in encodings:
#     try:
#         lab_data = pd.read_csv('C:/Users/Arde/DTEK-projektit/tietokanta-normalisointi/Labrat_tietokanta.csv', 
#                             names=['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'],
#                             encoding=encoding)
#         break  # Exit loop if file is read successfully
#     except UnicodeDecodeError:
#         print(f"Failed to read with encoding '{encoding}'. Trying next encoding...")


########### Reading file and printing it out in chunks, no csv -formatting. ######## 

def read_by_row(csv_file_path):
    chunk_size = 1
    for chunk in pd.read_csv(csv_file_path, 
                                chunksize=chunk_size,
                                low_memory=False, 
                                encoding=encoding):
        chunk_string = chunk.to_string(index=False)
        
        # Process each chunk (here, we print the chunk)
        print(chunk_string)
        print("Just in the read_by_row function")

########## Formats now rows into separate strings to better handling. #######"
def read_by_row_csvformat(csv_file, output_file):
    chunk_size = 1
    modified_rows = []
    # Read the CSV file in chunks
    for chunk in pd.read_csv(csv_file, 
                            #names= ['Keskuksen nimi','Keskuksen perustamisvuosi','Hoitajan nimi','El�in','El�imen lempilelut','El�imen ik�','Toimenpide','Toimenpiteen pvm','Hoitajan palkka','El�imen kiinniottopaikka','Kiinniottopvm','El�imen laji','Keskuksen osoite','lisä1','lisä2', 'lisä3'],


                            chunksize=chunk_size, 
                            encoding=encoding):
        # Convert each row in the chunk to a CSV-formatted string
        #chunk_string = chunk.to_string(index=False)
        chunk_string = '\n'.join(','.join(map(str, row)) for row in chunk.values)
        #print("This is chunk_string: ", chunk_string, "\n")
        print("This is chunk_toString: ", chunk_string, "\n")

        # Find the brackets -> input str, output LIST
        matches = re.findall(r"\['(.*?)'\]", chunk_string) 
        # append LIST if EMPTY
        if not matches:
            matches.append("")

        # Make a string from found brackets 
        matches_string = ",".join(str(element) for element in matches)
        comma_count = matches_string.count(',')

        # Adding right amount of commas to the list in brackets
        if comma_count == 0:
            new_string = matches_string + ",,"
        elif comma_count == 1:
            new_string = matches_string + ","
        else:
            new_string = matches_string
        new_string = new_string.replace(' ','')    

        # Replace the original occurrences of text within brackets with modified ones
        modified_chunk_string = re.sub(r"\[(.*?)\]", new_string, chunk_string) # Had to remove quotes from the search word to make it work
        modified_chunk_string = modified_chunk_string.replace('[', '').replace(']', '').replace("'", '') # Cleaning brackets and quotes

        modified_rows.append(modified_chunk_string)


    with open(output_file, 'w') as f:
        for row in modified_rows:
            f.write(row + '\n')

    print(f"CSV data has been written to: {output_file}")








# modified_lab_data = pd.read_csv(io.StringIO(read_by_row_csvformat(csv_file)))
# Write the modified DataFrame to a new CSV file
# modified_lab_data.to_csv('C:/Users/Arde/DTEK-projektit/tietokanta-normalisointi/Modified_Labrat_tietokanta.csv', index=False, header=None)

if __name__ == '__main__':
    #Take the file

    print("Running the __name__=='__main__")
    csv_file = 'C:/Users/Arde/DTEK-projektit/tietokanta-normalisointi/Labrat_tietokanta.csv'
    output_file = 'C:/Users/Arde/DTEK-projektit/tietokanta-normalisointi/Modified_Labrat_tietokanta.csv'
    encodings = ['utf-8', 'iso-8859-1', 'cp1252']

    # Only one row reading with exception handling
    # for encoding in encodings:
    #     try:        
    #         read_by_row(csv_file)
    #     except UnicodeDecodeError:
    #         print(f"Failed to read with encoding '{encoding}'. Trying next encoding...")

    # Choose read and write files to clean up csv file. 
    for encoding in encodings:
        try:        
            read_by_row_csvformat(csv_file, output_file) #if not returning then only calling the function
        except UnicodeDecodeError:
            print(f"Failed to read with encoding '{encoding}'. Trying next encoding...")

    # Load csv-file and print it
    for encoding in encodings:
        try:
            lab_data = pd.read_csv('C:/Users/Arde/DTEK-projektit/tietokanta-normalisointi/Modified_Labrat_tietokanta.csv', 
                                encoding=encoding)
            print(lab_data)
            break  # Exit loop if file is read successfully
        except UnicodeDecodeError:
            print(f"Failed to read with encoding '{encoding}'. Trying next encoding...")
        

