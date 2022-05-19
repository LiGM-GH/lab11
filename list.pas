unit list;
interface
    uses sysUtils;
    type ListNodeType = record
                            next  : ^ListNodeType;
                            value : Pointer;
                            valueType : String;
                        end;
    type ListType     = record
                            first  : ^ListNodeType;
                            length : Integer;
                        end;
    function inspect(node  : ListNodeType) : String; overload;
    function inspect(list  : ListType)     : String; overload;
    function toString(node : ListNodeType) : String; overload;
    function toString(list : ListType)     : String; overload;

    function addToList(list : ListType; value : Pointer; valueType : String) : Pointer;
implementation
    function toString(node : ListNodeType) : String; overload;
    begin
        case node.valueType of
            'String'  : toString := String(node.value^);
            'Integer' : toString := intToStr(Integer(node.value^));
            'Real'    : toString := FloatToStr(Real(node.value^));
            'Char'    : toString := String(node.value^);
        end;
    end;

    function inspect(node : ListNodeType) : String;
    begin
        inspect := 'ListNode[' + toString(node) + ']'
    end;

    procedure initList(list : ListType);
    begin
        list.first := nil;
    end;

    function addToList(list : ListType; value : Pointer; valueType : String) : Pointer;
    var elem      : ListNodeType;
        valueNode : ListNodeType;
    begin
        elem := ListNodeType(list.first^);
        while elem.next <> nil do begin
            elem := ListNodeType(elem.next^);
        end;
        valueNode.value := value;
        elem.next := @valueNode;
        valueNode.next := nil;
        valueNode.valueType := valueType;
        addToList := Pointer(@valueNode);
    end;

    function inspect(list  : ListType) : String; overload;
    var toReturn : String;
        elem     : ListNodeType;
    begin
        toReturn := 'List[';
        elem := list.first^;
        while elem.next <> nil do begin
            toReturn := toReturn + toString(elem);
            elem := elem.next^;
            if elem.next <> nil then toReturn := toReturn + ', ';
        end;
        toReturn := toReturn + ']';
        inspect := toReturn;
    end;

    function toString(list : ListType) : String; overload;
    var toReturn : String;
        elem     : ListNodeType;
    begin
        toReturn := '';
        elem := list.first^;
        while elem.next <> nil do begin
            toReturn := toReturn + toString(elem);
            elem := elem.next^;
            if elem.next <> nil then toReturn := toReturn + #10;
        end;
        toReturn := toReturn + '';
        toString := toReturn;
    end;
end.
