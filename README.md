#  Sparky - Build ChatGPT prompts from templates and paramaters

Freeport.Software - for internal use only 0.2.13
now supports --unique

```
OVERVIEW: Generate A Script of Prompts From One Template and A CSV File of
Parameters

The template file is any file with $0 - $9 symbols that are replaced by values
supplied in the CSV File.
Each line of the CSV generates another prompt appended to the output script.


USAGE: sparky <input-text-file-url> <substitutions-csv-file-url> [--output <output>] [--unique <unique>]

ARGUMENTS:
  <input-text-file-url>   The input text file URL
  <substitutions-csv-file-url>
                          The substitutions CSV file URL

OPTIONS:
  -o, --output <output>   The optional output text file URL of prompts;
                          otherwise outputs to the console (Between_0_1.txt)
  -u, --unique <unique>   Make output file name unique (default: false)
  -h, --help              Show help information.

  ```
