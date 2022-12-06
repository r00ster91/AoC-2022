with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;

-- the whole program is in this procedure
procedure Supply_Stacks is
function getIndex(thing: String; startIndex: Integer) return Integer is
begin
    declare
        index : Integer := startIndex;
    begin
        for i in 1 .. Length (To_Unbounded_String (thing)) loop
            if Element(To_Unbounded_String (thing), i) = ' ' then
                return i;
            end if;
        end loop;
    end;
end getIndex;

    subtype Crate is Character range 'A' .. 'Z';
    -- `Positive range <>` means the length is runtime-known
    type Stack is array (Positive range <>) of Crate;
    File : File_Type;
    Skip : exception;
    Line_Number: Integer := 1;
    Stacks : array (1 .. 100) of Stack (1 .. 100) := (others => (others => 'A'));
    Moves : Boolean := false;
begin

    Put_Line(getIndex("hello world", 2)'image);

    Open (File => File,
          Mode => In_File,
          Name => "input");
   
    while not End_Of_File (File) loop
        -- in Ada we always have to declare the scope of variables!
        declare
            Line : Unbounded_String := To_Unbounded_String (Get_Line (File));
        begin
            if Moves or Length (Line) = 0 then
                if not Moves then
                    Moves := true;
                else
                    Put_Line (To_String (Line));
                    declare
                        Index : Integer := 1;
                        Crates_To_Move_Count : Integer := -1;
                        SourceThing : Integer := -1;
                        Destination : Integer := -1;
                        BoundedLine : String := To_String (Line);
                    begin
                        loop
                            if Element (Line, Index) in '0'..'9' then
                                --Put_Line (To_String ((Line (Line'First(1) .. Line'Last(1)));
                                declare
                                    Number : Integer := Integer'value (BoundedLine(Index + 1.. getIndex(BoundedLine, Index + 2)));
                                begin
                                    Put_Line (Number'Image);
                                --if Crates_To_Move_Count = -1 then
                                --    Crates_To_Move_Count := Integer'value (BoundedLine(Index .. getIndex(BoundedLine, Index)));
                                --elsif SourceThing = -1 then
                                --    SourceThing := Integer'value (BoundedLine(Index .. getIndex(BoundedLine, Index)));
                                --elsif Destination = -1 then
                                --    Destination := Integer'value (BoundedLine(Index .. getIndex(BoundedLine, Index)));
                                --else
                                --    exit;
                                --end if;
                                end;
                            else
                                Index := Index + 1;
                            end if;
                            Put_Line(Crates_To_Move_Count'Image);
                            Put_Line(SourceThing'Image);
                            Put_Line(Destination'Image);
                        end loop;
                    end;

                    --declare
                    --    Start_Index : Integer := 0;
                    --    End_Index : Integer := 1;
                    --    Sub_String : String (1 .. 10);
                    --    Bounded_Line : String := To_String (Line);
                    --begin
                    --    while End_Index <= Length (Line) loop
                    --        Put_Line ("Start_Index: " & Start_Index'Image & "EndIndex: " & End_Index'Image & ",Element: " & Character'Image(Element (Line, End_Index)));
                    --        if Element (Line, End_Index) = ' ' then
                    --            declare
                    --                Sub_String : String := (Bounded_Line (Bounded_Line'First(1) + Start_Index..Bounded_Line'First(1) + End_Index - 2));
                    --            begin
                    --                Put_Line ("Sub_String: " & Sub_String & ",Length: " & Length (To_Unbounded_String (Sub_String))'Image);
                    --                Start_Index := End_Index;
                    --                End_Index := End_Index + Length (To_Unbounded_String (Sub_String));
                    --            end;
                    --        else
                    --            End_Index := End_Index + 1;
                    --        end if;
                    --    end loop;
                    --end;
                end if;
            else
                declare
                    Index : Integer := 2;
                begin
                    loop
                        begin
                            if Index >= Length (Line) then
                                exit;
                            end if;

                            if Element (Line, Index) in 'A'..'Z' then
                                declare
                                    Crate_To_Move : Crate := Crate (Element (Line, Index));
                                    x : Integer := 1;
                                begin
                                    Put_Line ("Index: " & (Integer(((index - 2) / 4))'Image));
                                    Stacks(Line_Number)(((Index - 2) / 4) + 1) := Crate'('A');
                                    Put_Line (Crate_To_Move'Image);
                                end;
                            end if;

                            Index := Index + 4;
                        exception
                            -- this is currently unused
                            when Skip => null;
                        end;
                    end loop;
                end;
            end if;
        end;
        Line_Number := Line_Number + 1;
    end loop;

    Close (File);
end Supply_Stacks;
