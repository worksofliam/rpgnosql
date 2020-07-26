## RPGNoSQL

This is an idea for a service program to fetch data from a table which contains a BSON (blob) column. This means not only can your data scale veritcally, it also means it can grow horizontally.

Inspiration from the post [JSON data in SQL Server](https://docs.microsoft.com/en-us/sql/relational-databases/json/json-data-sql-server?view=sql-server-ver15).

#### Installation

1. Clone
2. `cd rpgnosql`
3. Create the `RPGNOSQL` library
4. `gmake`

#### Example

See the `examples` directory for an example.

```
Dcl-S index Int(3);
Dcl-S CurrentName Char(30);
Dcl-S CurrentBalance Packed(9:2);

NoSQL_Table('barry.docs');

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
```