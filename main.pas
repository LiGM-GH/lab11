program main;
uses listUnit;
var a   : ListNodeType;
    b   : Integer;
    str : String;
    list : ListType;
begin
    b := 4;
    a.value := @b;
    a.valueType := 'Integer';
    str := 'HELLO!';
    initList(list);                             writeln('Initted list');
    addToList(list, a);                         writeln('Added to list');
    a.value := @str; a.valueType := 'String';   writeln('Changed a');
    addToList(list, a);                         writeln('Added to list');
    writeList(list); writeln;
    writeln(inspect(list));
    b := 0;
    findNodeWithIndex(list.first^, b, 0);
    writeln(b);
end.
