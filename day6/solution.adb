with Ada.Text_IO; use Ada.Text_IO;

procedure Tuning_Trouble is
    File : File_Type;
begin
    Open (File => File,
          Mode => In_File,
          Name => "input");

    Put_Line ("-- Part 1 --");
    -- this solution is hard-coded
    declare
        Input : String := Get_Line (File);
    begin
        declare
            Index : Integer := 1;
        begin
            loop
                declare
                    One   : Character := Input (Index);
                    Two   : Character := Input (Index + 1);
                    Three : Character := Input (Index + 2);
                    Four  : Character := Input (Index + 3);
                begin
                    Put_Line (One'image & Two'image & Three'image & Four'image);
                    if One   /= Two and One   /= Three and One   /= Four  and
                       Two   /= One and Two   /= Three and Two   /= Four  and
                       Three /= One and Three /= Two   and Three /= Four  and
                       Four  /= One and Four  /= Two   and Four  /= Three then
                       exit;
                    end if;
                end;
                Index := Index + 1;
                if Index = Input'length - 4 then
                    exit;
                end if;
            end loop;
            Put_Line (Integer'image(Index + 3));
        end;

        Put_Line ("-- Part 2 --");
        -- this solution works with any length
        pragma Assert (Input'length >= 14);
        declare
            Index : Integer := 1;
            Characters : array (1 .. 14) of Character range 'a' .. 'z' := (others => 'a');
        begin
            loop
                if Index > 14 then
                    -- now we have to shift all characters back by one
                    -- (meaning we drop the first character) and then add
                    -- the new character to the end
                    for ShiftIndex in 1 .. Characters'length loop
                        if (ShiftIndex > 1) then
                            Characters (ShiftIndex - 1) := Characters (ShiftIndex);
                        end if;
                    end loop;
                    Characters (Characters'last) := Input (Index);
                    
                    -- are all characters in `Characters` unique?
                    for X in 1 .. Characters'length loop
                        for Y in 1 .. Characters'length loop
                            if X /= Y and Characters (X) = Characters (Y) then
                                goto not_unique;
                            end if;
                        end loop;
                    end loop;
                    <<unique>>
                    exit;
                    <<not_unique>>
                    null;
                else
                    Characters (Index) := Input (Index);
                end if;
                Index := Index + 1;
                if Index = Input'length then
                    exit;
                end if;

                for PrintIndex in 1 .. Characters'length loop
                    Put (Character'image(Characters(PrintIndex)));
                end loop;
                Put_Line ("");
            end loop;
            Put_Line (Integer'image(Index));
        end;
    end; 
end Tuning_Trouble;
