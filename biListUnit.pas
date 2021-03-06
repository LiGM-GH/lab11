{$MODE OBJFPC}
unit biListUnit;
interface
    uses sysUtils;
    type BiListNodeType = record next, last : ^BiListNodeType;
                                 value      : Char;
                          end;
    type BiListType = record first, last : ^BiListNodeType; end;
    type BlockType = function(val : BiListNodeType) : Boolean;
    type ConditionBlockType = function(val1, val2 : BiListNodeType) : Boolean;
    function last(const node : BiListNodeType) : BiListNodeType; overload;
    function init(var list : BiListType) : BiListType; overload;
    function last(const list : BiListType) : BiListNodeType; overload;
    function add(var list : BiListType; value : char) : BiListType;
    function add(var list : BiListType;
                     node : BiListNodeType
                )         : BiListType; overload;
    function unshift(var list : BiListType;
                         node : BiListNodeType
                    )         : BiListType; overload;
    function get(var list : BiListType; which : Integer) : BiListNodeType; overload;
    function get(var node           : BiListNodeType;
                     counter, which : Integer
                )                   : BiListNodeType; overload;
    procedure deleteBy(block : BlockType; var node : BiListNodeType); overload;
    function deleteBy(block : BlockType; var list : BiListType) : BiListType; overload;
    function readList(var aFile : Text; var list : BiListType) : BiListType; overload;
    function insertBy(block : ConditionBlockType; const list : BiListType; node : BiListNodeType) : BiListType; overload;
implementation
    function init(var list : BiListType) : BiListType; overload;
        begin
            list.first := nil;
            list.last  := nil;
            init := list;
        end;

    function last(const node : BiListNodeType) : BiListNodeType; overload;
        begin
            if Pointer(node.next) = nil
            then last := node
            else last := last(node.next^);
        end;
    function last(const list : BiListType) : BiListNodeType; overload;
        begin
            last := list.last^;
        end;
    function add(var list : BiListType; value : char) : BiListType;
        var node : BiListNodeType;
        begin
            node.last := nil;
            node.next := nil;
            node.value := value;
            add := add(list, node)
        end;
    function add(
            var list : BiListType;
            node : BiListNodeType
        ) : BiListType; overload;
        var last : BiListNodeType;
        begin
            if Pointer(list.first) = nil
            then begin
                list.first := @node;
                list.last  := @node;
            end
            else begin
                last := list.last^;
                last.next := @node;
                node.last := @last;
                list.last := @node;
            end;
            add := list;
        end;

    function unshift(var list : BiListType;
                         node : BiListNodeType
                    )         : BiListType; overload;
        var first : BiListNodeType;
        begin
            if Pointer(list.first) = nil
            then begin
                list.first := @node;
                list.last  := @node;
            end
            else begin
                first := list.first^;
                first.last := @node;
                node.next  := @first;
                list.first := @node;
            end;
            unshift := list;
        end;
    function get(var node           : BiListNodeType;
                     counter, which : Integer
                )                   : BiListNodeType; overload;
        begin
            if counter = which
            then get := node
            else
            if Pointer(node.next) = nil
            then writeln('No such node!')
            else get := get(node.next^, counter + 1, which);
        end;
    function get(var list : BiListType; which : Integer) : BiListNodeType; overload;
        begin
            get := get(list.first^, 0, which);
        end;
    function insert(var list      : BiListType;
                        node      : BiListNodeType;
                        afterWhat : Integer
                   )              : BiListType; overload;
        var nodeBefore, nodeAfter : BiListNodeType;
        begin
            nodeBefore := get(list, afterWhat);
            nodeAfter  := nodeBefore.next^;
            nodeBefore.next := @node;
            nodeAfter.last  := @node;
            node.last := @nodeBefore;
            node.next := @nodeAfter;
            insert := list;
        end;
    function findBy(block : BlockType; node : BiListNodeType) : BiListNodeType; overload;
        begin
            if block(node)
            then findBy := node
            else
            if Pointer(node.next) = nil
            then writeln('Not found')
            else findBy := findBy(block, node.next^);
        end;
    function rFindBy(block : BlockType; node : BiListNodeType) : BiListNodeType; overload;
        begin
            if block(node)
            then rFindBy := node
            else
            if Pointer(node.last) = nil
            then writeln('Not found')
            else rFindBy := rFindBy(block, node.last^);
        end;
    function rFindBy(block : BlockType; const list : BiListType) : BiListNodeType; overload;
        begin rFindBy := rFindBy(block, list.last^); end;
    function findBy(block : BlockType; var list : BiListType) : BiListNodeType; overload;
        begin
            findBy := findBy(block, list.first^);
        end;

    function insertBy(block : ConditionBlockType; node : BiListNodeType; given : BiListNodeType) : BiListNodeType; overload;
        begin
            if Pointer(node.next) = nil
            then begin
                node.next := @given;
                given.last := @node;
            end
            else
            if block(node, given) and block(given, node.next^)
            then begin
                given.next := node.next;
                node.next := @given;
                given.last := @node;
            end
            else insertBy := insertBy(block, node.next^, given);
        end;

    function insertBy(block : ConditionBlockType; const list : BiListType; node : BiListNodeType) : BiListType; overload;
        begin
            insertBy(block, list.first^, node);
            insertBy := list;
        end;
    procedure deleteBy(block : BlockType; var node : BiListNodeType); overload;
        begin
            if block(node)
            then begin
                node.last^.next := node.next;
                node.next^.last := node.last;
            end;
            if Pointer(node.next) <> nil
            then deleteBy(block, node.next^);
        end;
    function deleteBy(block : BlockType; var list : BiListType) : BiListType; overload;
        begin
            deleteBy(block, list.first^);
            deleteBy := list;
        end;
    function readList(var aFile : Text; var list : BiListType) : BiListType; overload;
        var aChar : Char;
        begin
            aChar := #0;

            while not EOF(aFile) do begin
                read(aFile, aChar);
                add(list, aChar);
            end;
            readList := list;
        end;
    procedure writeList(const node : BiListNodeType); overload;
        begin
            writeln(node.value);
            if Pointer(node.next) <> nil
            then writeList(node.next^);
        end;
    procedure writeList(const list : BiListType); overload;
        begin
            if Pointer(list.first) <> nil
            then writeList(list.first^)
            else writeln('Nil list@first');
        end;

    procedure rWriteList(const node : BiListNodeType); overload;
        begin
            writeln(node.value);
            if Pointer(node.last) <> nil
            then rWriteList(node.last^);
        end;
    procedure rWriteList(const list : BiListType); overload;
        begin
            if Pointer(list.last) <> nil
            then rWriteList(list.last^)
            else writeln('Nil list@last');
        end;
end.
