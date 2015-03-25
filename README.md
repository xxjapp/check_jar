# check_jar
A ruby tool to check version info of java jar file

## Installation

Execute:

    $ bash <(curl -sk https://raw.githubusercontent.com/xxjapp/check_jar/master/install.sh)

## Usage

Example 1:

    $ check_jar standard.jar

    Summary
    --------------------------------
    JDK 1.2  (46): 254 class files

    Time Used:	0:0:0.064

Example 2:

    $ check_jar standard.jar -v
    META-INF/MANIFEST.MF
    --------------------------------
    Manifest-Version: 1.0
    Ant-Version: Apache Ant 1.6.1
    Created-By: 1.4.2-38 ("Apple Computer, Inc.")
    ...

    Details
    --------------------------------
    JDK 1.2  (46): org/apache/taglibs/standard/Version.class
    JDK 1.2  (46): org/apache/taglibs/standard/extra/spath/ASCII_CharStream.class
    ...
    JDK 1.2  (46): org/apache/taglibs/standard/tlv/JstlXmlTLV.class

    Summary
    --------------------------------
    JDK 1.2  (46): 254 class files

    Time Used:	0:0:0.057
