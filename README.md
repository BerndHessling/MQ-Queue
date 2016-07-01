# MQ-Queue
Queue MaxQuant analysis by saving MaxQuant parameter files in a watch folder.

## Discription
This tool looks for mqpar.xml files in a specified folder and carries out the MaxQuant analsis for according to these files. This allows the efficient use of a dedicated MaxQuant Server, as different analysis can be queed and will be carried out with no downtime in between.
XML filen names should contain the project name as well as an operator name, which will be used to parse the resulting txt output files in a result folder according to this information.

## Prerequisits
* MaxQuant must be installed (any Version should be supported)
* R needs to be installed (package was developed for version 3.3.0).


## Running the script
A watch-folder must be created and should contain one sub-folder named "priority". XML files can be copied in the watch folder and will be be queued up for analysis by file date. Data analysis that should be carried out immideatly can be copied in the "priority" sub-folder and would therefore be queued first.
The XML-file should be named by the project name followed by an underscore, followed by a user-name:

```
Projectname_User01.xml
```

When this is done the script can be started and the program will asked for the location of:
1. watch folder
2. MaxQuant/bin folder
3. Result folder

If there are XML files to be found in the watch folder theses analysis will be carried out and the MaxQuant txt output-folder as well as the XML parameter file will be copied in the specified result folder as follows:

```
/ResultFolder/User01/Projectname
```
