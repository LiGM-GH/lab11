unit listUnit;
interface
    // uses
        uses sysUtils;
    // type definitions
        type ListNodeType = record
                                next  : ^ListNodeType;
                                value : Pointer;
                                valueType : String;
                            end;
        type ListType     = record first  : ^ListNodeType; end;
        type BlockType = function(val : ListNodeType) : Boolean;
    // List methods
        procedure init(var list : ListType); overload;
        // adds
            function add(var list  : ListType;
                               var value : ListNodeType) : ListType; overload;

            function add(var list  : ListType;
                               value     : Pointer; 
                               valueType : String) : ListType; overload;

        // unshifts
            function unshift(var list  : ListType;
                                 var value : ListNodeType) : ListType; overload;

            function unshift(var list  : ListType;
                                     value : Pointer;
                                 valueType : String) : ListType; overload;
        // inspect/to_s/print_self
            function inspect( const node : ListNodeType) : String; overload;
            function toString(const node : ListNodeType) : String; overload;
            function inspect( const list : ListType)     : String; overload;
            function toString(const list : ListType)     : String; overload;
            procedure writeList(const list : ListType); overload;
        // finds
            function findNodeWithIndex(const node : ListNodeType; 
                                        var index : Integer; 
                                           number : Integer) : ListNodeType; overload;
        // inserts
            function insert(var list : ListType; 
                                      what : ListNodeType;
                                     where : Integer) : ListType; overload;
implementation
    procedure init(var list : ListType);
        begin
            list.first := nil;
        end;

    function add(var list  : ListType;
                       var value : ListNodeType) : ListType; overload;
        var elem : ListNodeType;
        begin
            // writeln('List#add');
            // writeln(toString(value));
            if (Pointer(list.first) = nil)
            then begin
                // writeln('List#add::then');
                list.first := @value;
                value.next := nil;
            end else begin
                // writeln('List#add::else');
                elem := ListNodeType(list.first^);
                while not (Pointer(elem.next) = nil) do begin
                    elem := ListNodeType(elem.next^);
                end;
                elem.next := @value;
            end;
            // writeln('List#add -> List#to_s');
            // writeln(toString(list));
            // writeln('List#to_s -> List#add');
            // writeln;
            add := list;
        end;

    function add(var list  : ListType;
                       value     : Pointer; 
                       valueType : String) : ListType; overload;
        var valueNode : ListNodeType;
        begin
            valueNode.value := value;
            valueNode.next := nil;
            valueNode.valueType := valueType;
            add := add(list, valueNode);
        end;

    function unshift(var list  : ListType;
                         var value : ListNodeType) : ListType; overload;
        begin
            if (Pointer(list.first) = nil)
            then value.next := nil
            else value.next := list.first;
            list.first := @value;
            unshift := list;
        end;

    function unshift(var list  : ListType;
                             value : Pointer;
                         valueType : String) : ListType; overload;
        var valueNode : ListNodeType;
        begin
            valueNode.value := value;
            valueNode.next := nil;
            valueNode.valueType := valueType;
            unshift := unshift(list, valueNode);
        end;

    function toString(const list : ListType) : String; overload;
        var toReturn : String;
            elem     : ListNodeType;
        begin
            // writeln('List#to_s');
            toReturn := '';
            if (Pointer(list.first) = nil)
            then begin
                // writeln('List#to_s::then');
            end else begin
                // writeln('List#to_s::else');
                elem := list.first^;
                if Pointer(elem.next) = nil
                then begin
                    // writeln('List#to_s::else::then');
                    // writeln('List#to_s -> Node#to_s');
                    toReturn := toReturn + toString(elem);
                    // writeln('Node#to_s -> List#to_s');
                end else repeat
                    // writeln('List#to_s::else::else::repeat');
                    // writeln('List#to_s -> Node#to_s');
                    toReturn := toReturn + toString(elem);
                    // writeln('Node#to_s -> List#to_s');
                    if not (Pointer(elem.next) = nil)
                    then toReturn := toReturn + #10;
                    elem := elem.next^;
                until Pointer(elem.next) = nil;
            end;
            toString := toReturn;
        end;

    function toString(const node : ListNodeType) : String; overload;
        var toReturn : String;
        begin
            // write('Node#to_s');
            toReturn := '';
            case node.valueType of
                'String', 'string', 'Char', 'char'  : 
                            toReturn := String(node.value^);
                'Integer' : toReturn := intToStr(Integer(node.value^));
                'Real'    : toReturn := FloatToStr(Real(node.value^));
                else begin writeln('::UNKNOWN TYPE!'); toReturn := 'ERR::NOTYPE'; end;
            end;
            toString := toReturn;
        end;

    function inspect(const node : ListNodeType) : String; overload;
        var toReturn : String;
        begin
            toReturn := '';
            case node.valueType of
                'String', 'string', 'Char', 'char'  : 
                            toReturn := '"' + String(node.value^) + '"';
                'Integer' : toReturn := intToStr(Integer(node.value^));
                'Real'    : toReturn := FloatToStr(Real(node.value^));
                else toReturn := 'ERR::NOTYPE'; 
            end;
            inspect := toReturn;
        end;

    function inspect(const list : ListType) : String; overload;
        var toReturn : String;
            elem     : ListNodeType;
        begin
            // writeln('List#to_s');
            toReturn := 'List[';
            if (Pointer(list.first) = nil)
            then begin
                // writeln('List#to_s::then');
            end else begin
                // writeln('List#to_s::else');
                elem := list.first^;
                if Pointer(elem.next) = nil
                then begin
                    // writeln('List#to_s::else::then');
                    // writeln('List#to_s -> Node#to_s');
                    toReturn := toReturn + inspect(elem);
                    // writeln('Node#to_s -> List#to_s');
                end else repeat
                    // writeln('List#to_s::else::else::repeat');
                    // writeln('List#to_s -> Node#to_s');
                    toReturn := toReturn + inspect(elem);
                    // writeln('Node#to_s -> List#to_s');
                    if not (Pointer(elem.next) = nil)
                    then toReturn := toReturn + ', ';
                    elem := elem.next^;
                until Pointer(elem.next) = nil;
            end;
            inspect := toReturn + ']';
        end;

    procedure writeList(const list : ListType); overload;
        begin
            write(toString(list));
        end;
    function findNodeWithIndex(const node : ListNodeType; 
                                var index : Integer; 
                                   number : Integer) : ListNodeType; overload;
        begin
            if index = number
            then findNodeWithIndex := node
            else begin
                index := index + 1;
                findNodeWithIndex := findNodeWithIndex(
                    node.next^, 
                    index, 
                    number
                )
            end;
        end;
    function insert(var list : ListType; 
                              what : ListNodeType;
                             where : Integer) : ListType; overload;
        var index : Integer;
            node  : ListNodeType;
        begin
            index := 0;
            node := findNodeWithIndex(list.first^, index, where);
            what.next := node.next;
            node.next := @what;
            insert := list;
        end;
    function delete(var list : ListType; where : Integer) : ListType; overload;
        var node  : ListNodeType;
            index : Integer;
        begin
            index := 0;
            node := findNodeWithIndex(list.first^, index, where - 1);
            if not (Pointer(node.next^.next) = nil)
            then node.next := node.next^.next 
            else node.next := nil;
            delete := list;
        end;
    procedure recursiveDelete(var node : ListNodeType); overload;
        begin
            if not (Pointer(node.next) = nil)
            then recursiveDelete(node.next^);
            node.next := nil;
        end;
    procedure delete(var list  : ListType); overload;
        var elem : ListNodeType;
        begin
            if not (Pointer(list.first) = nil)
            then begin
                elem := list.first^;
                recursiveDelete(elem);
            end;
        end;

    function findByBlock(const node : ListNodeType; block : BlockType) : ListNodeType; overload;
        begin
            if not(Pointer(node.next) = nil)
            then findByBlock := findByBlock(node.next^, block)
            else findByBlock := node;
        end;

    function findByBlock(const list : ListType; block : BlockType) : ListNodeType; overload;
        begin
            if not(Pointer(list.first) = nil)
            then findByBlock := findByBlock(list.first^, block);
        end;
end.
