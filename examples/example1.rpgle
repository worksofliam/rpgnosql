**FREE

Ctl-Opt BndDir('RPGNOSQL') DftActGrp(*No);

/copy ./headers/rpgnosql.rpgle_h

Dcl-S index Int(3);
Dcl-S CurrentName Char(30);
Dcl-S CurrentBalance Packed(9:2);

NoSQL_Table('barry.docs');
NoSQL_Equal('$.favoriteFruit':TYPE_STRING:'orange');
NoSQL_Equal('$.index':TYPE_NUMBER:'3606');

If (NoSQL_Open());
  index = 0;
  Dow (NoSQL_Next() and index < 10);
    CurrentName = NoSQL_AsString('$.name');
    CurrentBalance = NoSQL_AsNumber('$.balance');

    Dsply (%TrimR(CurrentName) + ' - ' + %Char(CurrentBalance));
    index += 1;
  Enddo;

  NoSQL_Close();
Endif;

Return;