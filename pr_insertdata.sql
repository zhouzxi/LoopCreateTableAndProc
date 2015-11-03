begin
    declare v_i int;v_procname varchar(50);v_employeeinfotbl varchar(50);strsql varchar(4000);
begin
    v_i := 0;
    while v_i < 10 loop
        v_procname        := 'pr_insertdata'||substr(to_char(v_i),1,1);
        v_employeeinfotbl := 'tb_employeeinfo'||substr(to_char(v_i),1,1);

        v_i := v_i + 1;
        strsql := 'create or replace procedure '||v_procname||'(
            v_employeeno   in   varchar2,
            v_employeeage  in   int
        )
        as
            v_employeecnt     int;

        begin       
            select count(*) into v_employeecnt from '||v_employeeinfotbl||' where employeeno = v_employeeno;
            if v_employeecnt > 0 then       -- the employeeno is already in DB
            begin
                return;
            end;
            else                            -- the employeeno is not in DB
            begin
                insert into '||v_employeeinfotbl||'(employeeno, employeeage) values(v_employeeno, v_employeeage);
            end;
            end if;
            commit;
        exception when others then
            begin
                rollback;
                return;
            end;
        end;';
        execute immediate strsql;
    end loop;
    end;
end;
/
