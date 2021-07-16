uses crt;
type
   simar=array [1..256] of char;
   kolar=array [1..256] of longint;
   newtype=0..2;
   newtype2=0..65;
   ar=array [1..256,1..65] of newtype;
   bitar=array[1..8] of newtype;
   bitarlong=array[1..186] of newtype;
var maxbit,n,number,i,j,k,code,kolbit,nbit:integer;
    sim:simar;
    filnam:string;
    filgreed:array [1..13] of char;
    bit:array [1..256] of newtype2;
    bitos:bitar;
    raz:array [1..4] of integer;
    bitw:bitarlong;
    letter:char;
    newcode:ar;
    c:char;
    r:real;
    prcentold,prcentold1,percent,line,ck:byte;
    toread,overload,mistake,flag:boolean;
    greed,ff:file of byte;
    sizearh,over,sizegreed,timer,size1:longint;
label l1;
procedure getbit (ch:char;var bitos:bitar);
var  i,j,d:integer;
begin
for i:=1 to 8 do bitos[i]:=0;
d:=ord(ch);
j:=128;
for i:=1 to 8 do begin
if d>=j then begin
bitos[i]:=1;
d:=d-j;
end;
j:=(j div 2);
end;
end;
function dobyte(bn:bitar):integer;
var i,dvan,dob:integer;
begin
dvan:=1;
dob:=0;
for i:=1 to 8 do begin
dob:=bn[9-i]*dvan+dob;
dvan:=2*dvan;
end;
dobyte:=dob;
end;
procedure tbc;
begin
over:=over+1;
 if over=timer then overload:=true;
end;
procedure show(percent,line:byte);
var stolb:real;
    st1,st:integer;
begin
gotoxy(5,line);
textbackground(black);
textcolor(white);
write(percent);
gotoxy(8,line);
write('% ');
stolb:=((percent / 100)*60);
st:=round(stolb);
textcolor(yellow);
for st1:=1 to st do begin
gotoxy(10+st1,line);
write('Û');
end;
textcolor(white);
textbackground(black);
end;
begin
clrscr;
overload:=false;
mistake:=false;
line:=7;
write('Please enter file name: ');
readln(filnam);
i:=length(filnam);
if (filnam[i-2]+filnam[i-1]+filnam[i]<>'haf') then  begin
 mistake:=true;
 goto l1;
end;
assign(ff,filnam);
reset(ff);
sizearh:=filesize(ff);
sizegreed:=0;
for j:=1 to i-3 do filgreed[j]:=filnam[j];
for j:=1 to 3 do begin
 read(ff,ck);dec(sizearh);
 filgreed[i-3+j]:=chr(ck);
end;
for i:=1 to 4 do begin
 read(ff,ck);dec(sizearh);
 raz[i]:=ck;
end;
sizegreed:=raz[1]*8388608+raz[2]*32768+raz[3]*128+raz[4];
size1:=sizegreed;
timer:=4*size1+(size1 div 2);
read(ff,ck);dec(sizearh);
n:=ck;
if n=0 then n:=256;
for i:=1 to 256 do for j:= 1 to 65 do newcode[i,j]:=2;
for i:=1 to 186 do bitw[i]:=2;
nbit:=0;
tbc;
read(ff,ck);dec(sizearh);
c:=chr(ck);
getbit(c,bitos);
for i:=1 to 8 do bitw[i]:=bitos[i];
nbit:=5;
gotoxy(1,5);
write('Processing');
gotoxy(1,9);
write('Time to finished ');
for i:=1 to 5 do bitos[i]:=0;
for i:=1 to 3 do bitos[i+5]:=bitw[i];
kolbit:=dobyte(bitos);
for i:=4 to 186 do bitw[i-3]:=bitw[i];
for i:=1 to n do begin
 tbc;
 if overload then goto l1;
 percent:=round(i/n*20);
 if percent>prcentold then begin
     show(percent,7);
     prcentold:=percent;
    end;
 percent:=round((over)/(timer)*100);
  if percent>prcentold1 then begin
     show(percent,11);
     prcentold1:=percent;
    end;
 while nbit<=(kolbit*8+1) do begin
  read(ff,ck);dec(sizearh);
  c:=chr(ck);
  getbit(c,bitos);
  for j:=1 to 8 do bitw[nbit+j]:=bitos[j];
  nbit:=nbit+8;
 end;
 for j:=1 to 8 do bitos[j]:=bitw[j];
 k:=dobyte(bitos);
 c:=chr(k);
 tbc;
 if overload then goto l1;
 sim[i]:=c;
 for j:=9 to 186 do bitw[j-8]:=bitw[j];
 nbit:=nbit-8;
 while nbit<=(kolbit*8+1) do begin
  read(ff,ck);dec(sizearh);
  c:=chr(ck);
  getbit(c,bitos);
  for j:=1 to 8 do bitw[nbit+j]:=bitos[j];
  tbc;
  if overload then goto l1;
  nbit:=nbit+8;
 end;
 for j:= 1 to 8-kolbit do bitos[j]:=0;
 for j:= 9-kolbit to 8 do bitos[j]:=bitw[j-8+kolbit];
 tbc;
 if overload then goto l1;
 nbit:=nbit-kolbit;
 for j:=kolbit+1 to 186 do bitw[j-kolbit]:=bitw[j];
 bit[i]:=dobyte(bitos);
 while  nbit<=(kolbit*8+1) do begin
  read(ff,ck);dec(sizearh);
  c:=chr(ck);
  getbit(c,bitos);
  tbc;
  if overload then goto l1;
  for j:=1 to 8 do bitw[nbit+j]:=bitos[j];
  nbit:=nbit+8;
 end;
 for j:=1 to bit[i] do newcode[i,j]:=bitw[j];
 for j:=bit[i]+1 to 186 do bitw[j-bit[i]]:=bitw[j];
 nbit:=nbit-bit[i];
end;
maxbit:=1;
for j:=1 to n do if maxbit<bit[j] then maxbit:=bit[j];
assign(greed,filgreed);
rewrite(greed);
flag:=true;
while (sizearh>0)do begin
 if (bitw[170]=2)and(sizearh>0) then begin
  read(ff,ck);dec(sizearh);
  c:=chr(ck);
  getbit(c,bitos);
  for j:=1 to 8 do bitw[nbit+j]:=bitos[j];
  nbit:=nbit+8;
 end;
 tbc;
 if overload then goto l1;
 for i:=1 to n do begin
  flag:=true;
  for j:=1 to bit[i] do 
   if newcode[i,j]<>bitw[j] then begin
    flag:=false;
    break;
   end;

  if flag then begin
   for j:=bit[i]+1 to 186 do bitw[j-bit[i]]:=bitw[j];
   nbit:=nbit-bit[i];
   c:=sim[i];
   tbc;
   if overload then goto l1;
   ck:=ord(c);
   write(greed,ck);
   dec(sizegreed);
   tbc;
   if overload then goto l1;
   percent:=20+round((size1-sizegreed)/size1*80);
   if percent>prcentold then begin
    show(percent,7);
    prcentold:=percent;
   end;
   percent:=round((over)/(timer)*100);
   if percent>prcentold1 then begin
    show(percent,11);
    prcentold1:=percent;
   end;
   break;
  end;
 end;
end;
while sizegreed>0 do begin
 tbc;
 if overload then goto l1;
  percent:=round((over)/(timer)*100);
  if percent>prcentold1 then begin
     show(percent,11);
     prcentold1:=percent;
    end;
 for i:=1 to n do begin
  flag:=true;
  for j:=1 to bit[i] do if newcode[i,j]<>bitw[j] then begin
   flag:=false;
   break;
  end;
  if flag then begin
   for j:=bit[i]+1 to 186 do bitw[j-bit[i]]:=bitw[j];
   nbit:=nbit-bit[i];
   c:=sim[i];
   tbc;
   if overload then goto l1;
   ck:=ord(c);
   write(greed,ck);
   dec(sizegreed);
   percent:=20+round((size1-sizegreed)/size1*80);
   if percent>prcentold then begin
    show(percent,7);
    prcentold:=percent;
   end;
   percent:=round((over)/(timer)*100);
   if percent>prcentold1 then begin
    show(percent,11);
    prcentold1:=percent;
   end;
   break
  end;
 end;
end;
l1:
writeln;
while percent<100 do begin
inc(percent);
show(percent,11);
end;
gotoxy(1,13);
if mistake then writeln('Wrong archiv');
if overload then writeln ('Overload, uncorect archive');
if (not(mistake))and(not(overload)) then writeln ('Complite');
writeln('Press any key to be continion');
repeat until keypressed;
close(greed);
close(ff);
end.