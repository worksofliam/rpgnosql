**FREE

//compile:crtsqlrpgi_mod

Ctl-Opt NoMain;

//***********************************

/copy ./headers/rpgnosql.rpgle_h

//***********************************

Dcl-S SQLStatement Varchar(1024);

Dcl-DS CurrentRow;
  CurrentDocument SQLTYPE(BLOB:500);
End-Ds;

//***********************************

Dcl-Proc NoSQL_Table Export;
  Dcl-Pi NoSQL_Table;
    pTableName Pointer Value options(*string);
  End-Pi;

  SQLStatement = 'SELECT DCONTENT FROM ' + %Str(pTableName);
End-Proc;

//***********************************

Dcl-Proc NoSQL_Equal Export;
  Dcl-Pi NoSQL_Equal;
    pJSONPath   Pointer Value options(*string);
    pComparison Int(3) Const;
    pValue      Pointer Value options(*string);
    pPathType   Int(3) Const;
  End-Pi;

  Dcl-S lIndex Int(5);

  lIndex = %Scan('WHERE':SQLStatement);

  If (lIndex = 0);
    SQLStatement += ' WHERE ';
  Else;
    SQLStatement += ' AND ';
  Endif;

  SQLStatement += 'JSON_VALUE(DCONTENT, ''' + %Str(pJSONPath) + ''' ';

  Select;
    When (pPathType = TYPE_STRING);
      SQLStatement += 'RETURNING VARCHAR(1024)';
    When (pPathType = TYPE_NUMBER);
      SQLStatement += 'RETURNING DOUBLE';
  Endsl;

  SQLStatement += ') ';

  Select;
    When (pComparison = COMP_EQUAL);
      SQLStatement += '= ';
    When (pComparison = COMP_NOTEQUAL);
      SQLStatement += '!= ';
    When (pComparison = COMP_MORETHAN);
      SQLStatement += '> ';
    When (pComparison = COMP_LESSTHAN);
      SQLStatement += '< ';
  Endsl;

  Select;
    When (pPathType = TYPE_STRING);
      SQLStatement += '''' + %Str(pValue) + '''';
    When (pPathType = TYPE_NUMBER);
      SQLStatement += %Str(pValue);
  Endsl;
End-Proc;

//***********************************

Dcl-Proc NoSQL_Open Export;
  Dcl-Pi NoSQL_Open Ind End-Pi;

  EXEC SQL PREPARE S1 FROM :SQLStatement;
  
  EXEC SQL DECLARE JSON_Cursor CURSOR FOR S1;
  
  EXEC SQL OPEN JSON_Cursor;

  Return (SQLSTATE = '00000');
End-Proc;

//***********************************

Dcl-Proc NoSQL_Next Export;
  Dcl-Pi NoSQL_Next Ind End-Pi;

  EXEC SQL FETCH JSON_Cursor INTO :CurrentRow;

  Return (SQLSTATE = '00000');
End-Proc;

//***********************************

Dcl-Proc NoSQL_Exists Export;
  Dcl-Pi NoSQL_Exists Ind;
    pJSONPath Pointer Value options(*string);
  End-Pi;

  Dcl-S ReturnValue Varchar(2);
  Dcl-S Path        Varchar(128);

  Path = %Str(pJSONPath);
  
  EXEC SQL SET :ReturnValue =
    JSON_Value(:CurrentDocument, 
               :Path RETURNING VARCHAR(1024)
                     DEFAULT '*N' ON ERROR);

  Return (ReturnValue <> '*N');
End-Proc;

//***********************************

Dcl-Proc NoSQL_AsString Export;
  Dcl-Pi NoSQL_AsString Varchar(1024);
    pJSONPath Pointer Value options(*string);
  End-Pi;

  Dcl-S ReturnValue Varchar(1024);
  Dcl-S Path        Varchar(128);

  Path = %Str(pJSONPath);

  EXEC SQL SET :ReturnValue =
    JSON_Value(:CurrentDocument, :Path RETURNING VARCHAR(1024));

  Return ReturnValue; 
End-Proc;

//***********************************

Dcl-Proc NoSQL_AsNumber Export;
  Dcl-Pi NoSQL_AsNumber Float(8);
    pJSONPath Pointer Value options(*string);
  End-Pi;

  Dcl-S ReturnValue Float(8);
  Dcl-S Path        Varchar(128);

  Path = %Str(pJSONPath);

  EXEC SQL SET :ReturnValue =
    JSON_Value(:CurrentDocument, :Path RETURNING DOUBLE);

  Return ReturnValue; 
End-Proc;

//***********************************

Dcl-Proc NoSQL_Close Export;
  EXEC SQL CLOSE JSON_Cursor;
End-Proc;