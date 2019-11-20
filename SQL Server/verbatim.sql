CREATE FUNCTION dbo.words
(
    @num INT,
    @a INT
)
RETURNS varchar (500)
AS
BEGIN
    RETURN
    case
/* ��������, ����� ����� */
    when (@num between 0 and 19) then
      case @a when 1 then
		  case @num
		  when 1 then '����' when 6 then '����' when 11 then '����������' when 16 then '�����������'
		  when 2 then '���' when 7 then '�����' when 12 then '����������' when 17 then '������������'
		  when 3 then '���' when 8 then '����' when 13 then '����������' when 18 then '�����������'
		  when 4 then '������' when 9 then '�����' when 14 then '�������������' when 19 then '������������'
		  when 5 then '���' when 10 then '�����' when 15 then '����������' when 0 then '����'
		  END
      else 
		  case @num
		  when 1 then '����' when 6 then '����' when 11 then '����������' when 16 then '�����������'
		  when 2 then '���' when 7 then '�����' when 12 then '����������' when 17 then '������������'
		  when 3 then '���' when 8 then '����' when 13 then '����������' when 18 then '�����������'
		  when 4 then '������' when 9 then '�����' when 14 then '�������������' when 19 then '������������'
		  when 5 then '���' when 10 then '�����' when 15 then '����������' when 0 then '����'
		  END
	   end
      /* �������� */
    when (@num between 20 and 90) and (@num % 10 = 0) then
      case @num
      when 20 then '��������' when 60 then '���������'
      when 30 then '��������' when 70 then '����������'
      when 40 then '�����������' when 80 then '���������'
      when 50 then '��������' when 90 then '����������'
      end
    /* ����� ���������� */
    when (@num between 20 and 99) and (@num % 10 != 0) then (select dbo.words(((@num/ 10) * 10),@a))+ ' � ' + (select dbo.words((@num % 10),@a))
    
    /* �������, ������ */
	when (@num between 100 and 900) and (@num % 100 = 0) then
	  case @num
	  when 100 then '���' when 600 then '����������'
	  when 200 then '������' when 700 then '�����������'
	  when 300 then '������' when 800 then '����������'
	  when 400 then '������������' when 900 then '�����������'
	  when 500 then '���������'
	  end
	/* �������, �� ������ */
	when (@num between 100 and 999) and (@num % 100 != 0) then
	case
	/* �������, ����� ��������� �� �������� �����, ��� �� ������ 10 */
	  when (@num % 100 between 1 and 19) or (@num % 10 = 0) then (select dbo.words(((@num / 100) * 100),@a)) + ' � ' + (select dbo.words((@num % 100),@a))
	/* �������, �������� */
	  else (select dbo.words(((@num / 100) * 100),@a)) + ' ' + (select dbo.words((@num % 100),@a))
	  end
	/* 1000 */
    when @num = 1000 then '������'
    /* ����� 1000 � 2000 */
    when @num between 1001 and 1999 then
    case
    /* ����� ��������� �� ������ 100, ������ 10 ��� �������� ����� */
       when (@num % 1000 between 1 and 19) or (@num % 1000 < 100 and @num % 10 = 0) or (@num % 100 = 0) then '������' + ' � ' + (select dbo.words((@num % 1000),@a))
    /* ���������� */
	   else '������' + ' ' + (select dbo.words((@num % 1000),@a))
	   end
      /* ����� 2000 � ������-���-���� */
    when @num between 2000 and 999999 then
       case
    /* ������ ������ */
       when @num % 1000 = 0 then (select dbo.words((@num / 1000),0)) + ' ������ '
    /* ����� ��������� �� ������ 100, ������ 10 ��� �������� ����� */
       when (@num % 1000 != 0) and ((@num % 1000 between 1 and 19) or (@num % 1000 < 100 and @num % 10 = 0) or (@num % 100 = 0)) then (select dbo.words((@num / 1000),0)) + ' ������ � ' + (select dbo.words((@num % 1000),@a))
    /* ���������� */
       else (select dbo.words((@num / 1000),0)) + ' ������ ' + (select dbo.words((@num % 1000),@a))
       end
    /* ������ */
   when @num = 1000000 then '���� ������'
   /* ����� ���� � ��� ������� */
   when @num between 1000001 and 1999999 then
     case
   /* ����� ��������� �� ������ ��� �������� */
      when (@num % 1000000 between 1 and 19) or ((@num % 1000000) % 10 = 0 and (@num % 1000000) < 100) or (@num % 100 = 0) then (select dbo.words(((@num / 1000000) * 1000000),@a)) + ' � ' + (select dbo.words((@num % 1000000),@a))
      else (select dbo.words(((@num / 1000000) * 1000000),@a)) + ' ' + (select dbo.words((@num % 1000000),@a))
     end
   /* ��� ������� */
   when @num = 2000000 then '��� �������'
   /* ����� 2 � 3 ������� */
   when @num between 2000001 and 2999999 then (select dbo.words(((@num / 1000000) * 1000000),@a)) + ' ' + (select dbo.words((@num % 1000000),@a))
   /* ����� 3 ������� � �������-���-���� */
   when @num between 3000000 and 999999999 then (select dbo.words((@num / 1000000),@a)) + ' ������� ' + (select dbo.words((@num % 1000000),@a))
      
   END
END