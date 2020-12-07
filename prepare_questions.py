import re
import os

def format_single_question(split_chunk):
    question      = '"' +split_chunk[0] + '"'
    answer        = '"' +split_chunk[1] + '"'
    other_choices = '"' + '","'.join(split_chunk[2:]) + '"'
  
    question_string = "\n$mc->qa(" + question + ", " + answer + ");\n"
    question_string += "$mc->extra(" + other_choices + ");\n\n"
    
    return(question_string)
  
  
  
def format_questions(input_file, output_path):

    #output_path = output_path.replace(" ", "-") + "/"
    os.system("mkdir -p " + output_path)
    os.system("rm -f " + output_path + "*")
    
    with open("header_text.txt", "r") as f:
        header = f.read()
    with open("footer_text.txt", "r") as f:
        footer = f.read()     

    with open(input_file, "r", encoding='utf-8-sig') as f:
        lines = f.read()
        lines = re.sub("\r", "\n", lines)

    question_number = 1
    for chunk in lines.split("##"):
        chunk_stripped = chunk.strip()
        if chunk_stripped == "":
            continue
        else:
            split_chunk = chunk_stripped.split("\n")    
            # Save to a file
            with open(output_path + "question" + str(question_number) + ".pg", "w") as f:
                f.write(header)
                f.write(format_single_question(split_chunk))    
                f.write(footer)
            question_number += 1

