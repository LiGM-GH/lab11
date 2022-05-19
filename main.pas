program main;
uses list;
var a   : ListNodeType;
    b   : Integer;
    str : String;
begin
    b := 4;
    a.value := @b;
    str := 'HELLO!';
    // writeln(a.value^);
    a.value := @str;
    if ParamCount = 1
    then a.valueType := ParamStr(1)
    else a.valueType := 'String';
    writeln(toString(a));
end.
