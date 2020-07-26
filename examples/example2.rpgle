**FREE

Ctl-Opt BndDir('RPGNOSQL') DftActGrp(*No);

/copy ./headers/rpgnosql.rpgle_h

Dcl-S index Int(3);
Dcl-S CurrentName Char(30);
Dcl-S CurrentBalance Packed(9:2);

NoSQL_Table('barry.docs');
NoSQL_Equal('$.balance':COMP_MORETHAN:'5000':TYPE_NUMBER);

If (NoSQL_Open());
  Dow (NoSQL_Next());
    CurrentName = NoSQL_AsString('$.name');
    CurrentBalance = NoSQL_AsNumber('$.balance');

    Dsply (%TrimR(CurrentName) + ' - ' + %Char(CurrentBalance));
  Enddo;

  NoSQL_Close();
Endif;

Return;