#  Sparky - Build ChatGPT prompts from templates and paramaters

Freeport.Software - for internal use only 0.0.1ß

```
OVERVIEW: Generate Many Outputs From One Template and A CSV File of Parameters

The template file is any file with $0 - $9 symbols that are replaced by values
supplied in the CSV File.
Each line of the CSV generates another output file.


USAGE: sparky <input-text-file-url> <substitutions-csv-file-url> [--output <output>]

ARGUMENTS:
  <input-text-file-url>   The input text file URL
  <substitutions-csv-file-url>
                          The substitutions CSV file URL

OPTIONS:
  -o, --output <output>   The optional output text file URL otherwise outputs
                          to the console
  -h, --help              Show help information.
  
  ```
