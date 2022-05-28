program main;
uses listUnit, biListUnit;

function block(val : ListNodeType) : Boolean;
    begin
        block := (val.value = 'D') or (val.value = 'E');
    end;
function conditionBlock(val1, val2 : ListNodeType) : Boolean;
    begin
        conditionBlock := (val1.value >= val2.value);
    end;
var aText : Text;
    list : ListType;
    aChar : Char;
begin
    assign(aText, 'text.txt');
    reset(aText);
    readList(aText, list);
    close(aText);
    unshift(list, #10);
    unshift(list, #64);
    add(list, #81);
    add(list, #80);
    writeList(list);
    writeln(findByBlock(list, @block).value);
    reset(aText);
    while not EOF(aText) do begin
        read(aText, aChar);
        insertBy(@conditionBlock, list, aChar);
    end;
    close(aText);
    writeList(list);
    findByBlock(list, @block);
    deleteBy(@block, list);
    writeList(list);
    delete(list);
end.
