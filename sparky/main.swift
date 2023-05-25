//
//  main.swift
//  substitute
//
//  Created by bill donner on 5/14/23.
//
/*
 Generate a swift command line program for macOS named Sparky using spm Argument Parser

 The three arguments are an input text file url , a substitutions csv file url, and an optional  output file text url

 Note Each of these urls should be accepted from the command line as a string, and then conditionally converted to URLs

 The format of the substitutions file is a valid headerless CSV file with columns implicitly named “A0” thru “A9”, e.g:

 Input.txt
 I like $0
 U like $1 $2

 substitutions.csv
 ArgA,ArgB,ArgC
 ArgD,ArgE


 Each line in the substitutions file produces a new output file with a name derived from the input file as input + 001, + 002, etc

 Each output file is generated by substituting the”A0” thru “A9” values with the corresponding symbols $0 thru $9 from the input file
 
 Replacing words or phrases
 Capitalizing or lowercasing text
 Removing punctuation
 Formatting text
 The possibilities are endless!
 
 
 */

import Foundation

import ArgumentParser


func generatePumperStuff(_ inputTextFile: URL, _ substitutions: [[String]]) throws  -> String  {
  let template0:String = try String(contentsOf: inputTextFile)
  var output = ""
  for row in 0..<substitutions.count {
    var line = template0.replacingOccurrences(of: "$GENERATED", with: "\(Date())")
    for col in 0..<substitutions[row].count {
      let el = substitutions[row][col]
      line = line.replacingOccurrences(of: "$\(col)", with: el)
    }
    output  += line + "***"
  }
  return output
}

extension String {
    func removeLinesStartingWithDoubleSlashes() -> String {
        let lines = self.components(separatedBy: CharacterSet.newlines)
        var result = [String]()

        for line in lines {
          if !line.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("//") {
                result.append(line)
            }
        }
        return result.joined(separator: "\n")
    }
}
func parseSubstitutionsCSVFile(_ url: URL) throws -> [[String]] {
  // Load substitutions CSV file
  let csvString = try String(contentsOf: url)
  let csvRows = csvString.removeLinesStartingWithDoubleSlashes().components(separatedBy: .newlines)
  let substitutions = csvRows.map { row in
    return row.components(separatedBy: ",")
  }
  return substitutions
}

func generateFileName(prefixPath:String) -> String {
  let date = Date()
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyyMMdd_HHmmss"
  let dateString = formatter.string(from: date)
  let fileName = prefixPath + "_" + dateString + ".txt"
  return fileName
}

struct Sparky: ParsableCommand { 
  static var configuration = CommandConfiguration(
    abstract: "Generate Many Outputs From One Template and A CSV File of Parameters",
    discussion: "The template file is any file with $0 - $9 symbols that are replaced by values supplied in the CSV File.\nEach line of the CSV generates another output file.\n")
  
  @Argument(  help: "The input text file URL")
  var inputTextFileURL: String
  
  @Argument(  help: "The substitutions CSV file URL")
  var substitutionsCSVFileURL: String

  @Option(name: .shortAndLong, help: "The optional output text file URL otherwise outputs to the console")
  var output: String?

  func sparky_essence(_ substitutionsCSVFile: URL, _ inputTextFile: URL) throws {
    let outputTextFile = output != nil ? URL(string: output!) : nil
    let substitutions = Array(try parseSubstitutionsCSVFile(substitutionsCSVFile).dropLast())
    let fallback = URL(string:"~/sparky")!
    let primary = outputTextFile?.deletingPathExtension()
    let outputFileName = generateFileName(prefixPath: "\(primary ?? fallback)")
    let outputFilesString =  try generatePumperStuff(inputTextFile, substitutions)
    if output != nil {
      if let outputFile  = URL(string:outputFileName) {
        do {
          print("Writing \(substitutions.count) prompts to \(outputFileName).")
          try outputFilesString.write(to:outputFile,atomically:true, encoding: .utf8)
          print("Generated \(outputFilesString.count) bytes of prompts files.")
        }
        catch {
          print("could not write to \(outputFileName), \(error)")
        }
      }
    } else {
      print(outputFilesString)
    }
  }
  func run() throws {
    guard let inputTextFile = URL(string: inputTextFileURL),
          let substitutionsCSVFile = URL(string: substitutionsCSVFileURL) else {
      throw ValidationError("Input and substitutions file URLs must be valid")
    }
    let start_time = Date()
    print("Command Line: \(CommandLine.arguments) \n")
    try sparky_essence(substitutionsCSVFile, inputTextFile)
    let elapsed = Date().timeIntervalSince(start_time)
    print("Elapsed \(elapsed) secs")
  }
}

Sparky.main()

//func generatePumperFiles(_ inputTextFile: URL, _ substitutions: [[String]], _ outputTextFile: URL?) throws -> [URL] {
//  let date = Date()
//  var outputFiles = [URL]()
//  for (index, substitution) in substitutions.enumerated()  {
//    if substitution != [] {
//
//      let outputFileName = (outputTextFile?.deletingPathExtension().lastPathComponent ?? inputTextFile.deletingPathExtension().lastPathComponent) + String(format:"%03d",index+1)
//
//      let outputFile = outputTextFile?.deletingLastPathComponent().appendingPathComponent(outputFileName).appendingPathExtension("txt") ?? inputTextFile.deletingLastPathComponent().appendingPathComponent(outputFileName).appendingPathExtension("txt")
//
//      let inputString = try String(contentsOf: inputTextFile)
//
//      var outputString = inputString
//      for (i, symbol) in substitution.enumerated() {
//        outputString = outputString.replacingOccurrences(of: "$\(i)", with: symbol)
//      }
//      // insert batchid
//
//      outputString = outputString.replacingOccurrences(of: "$GENERATED", with: "\(date)")
//      if outputString != "" {
//        if outputTextFile != nil { // output filespec was given
//
//          try outputString.write(to: outputFile, atomically: true, encoding: .utf8)
//
//        } else {
//          print("Prompt: \(index+1)")
//          print("generated: \(date)")
//          print("args: \(substitution)")
//          print("template: \(inputTextFile)")
//          print("+--------------- Cut Here and Paste into AI--------------------------+\n")
//
//          print(outputString)
//
//          print("+------------------  End of Cut Area  -------------------------------+\n")
//        }
//      }
//      outputFiles.append(outputFile)
//    }
//  }
//  return outputFiles
//}
