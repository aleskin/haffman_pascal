uses crt;
type
   simar=array [1..256] of char;
   kolar=array [1..256] of longint;
   newtype=0..2;
   newtype2=0..65;
   ar=array [1..256,1..65] of newtype;
   bitar=array[1..8] of newtype;
   bitarlong=array[1..186] of newtype;
var number,i,maxbit,kolbit,j,k,n,code,nbit:integer;
    line,prcentold,percent,ck:byte;
    sim:simar;
    raz:array [1..4] of integer;
    size1,sizegreed,sizenew:longint;
    filnam,filgreed:string;
    kol:kolar;
    bitn:array [1..65] of newtype;
    bit:array [1..256] of newtype2;
    bitos:bitar;
    bitw:bitarlong;
    c,letter:char;
    newcode:ar;
    greed,ff:file of byte;
 label f1;
 procedure show(percent,line:byte);
var stolb:real;
    st,st1:integer;
begin
gotoxy(5,line);
textbackground(black);
textcolor(white);
write(percent);
gotoxy(8,line);
write('% ');
stolb:=((percent/100)*60);
st:=round(stolb);
textcolor(yellow);
for st1:=1 to st do begin
gotoxy(10+st1,line);
write('Û');
end;
textcolor(white);
textbackground(black);
end;
 procedure readtabl(filename:string);
var f:file of byte;
    c:char;
    cb:byte;
    b:boolean;
    begin
   assign(f,filename);
   reset(f);
   n:=0;
   b:=false;
   sizegreed:=0;
   j:=0;
   size1:=filesize(f);
   Read(f,cb);
   c:=chr(cb);
   inc(sizegreed);
   inc(n);
   sim[n]:=c;
   kol[n]:=1;
   while not(eof(f)) do begin
    Read(f,cb);
    percent:=round(sizegreed/size1*20);
    if percent>prcentold then begin
     show(percent,10);
     prcentold:=percent;
    end;
    c:=chr(cb);
    inc(sizegreed);
    b:=false;
    for i:=1 to n do 
     if c=sim[i] then begin
      kol[i]:=1+kol[i];
      b:=true;
      break;
     end;
    if not(b) then begin
      inc(n);
      sim[n]:=c;
      kol[n]:=1;
    end;
   end;
   close(f);
end;
procedure uporad(letter:char; code,n:integer; kol:kolar; sim:simar;var newcode:ar);
var max,numax,ii:longint;
    maxsi:char;
  begin
while n>1 do begin
 for i:=1 to n-1 do begin
 max:=kol[i];
 numax:=i;
 maxsi:=sim[i];
 for j:=i+1 to n do if (max<kol[j]) then
  begin
  max:=kol[j];
  numax:=j;
  maxsi:=sim[j];
  end;
 kol[numax]:=kol[i];
 sim[numax]:=sim[i];
 kol[i]:=max;
 sim[i]:=maxsi;
 end;
kol[n-1]:=kol[n-1]+kol[n];
if letter=sim[n-1] then begin
 inc(bit[code]);
 newcode[code,66-bit[code]]:=1;
end;
if letter=sim[n] then begin
 sim[n]:=sim[n-1];
 sim[n-1]:=letter;
 inc(bit[code]);
 newcode[code,66-bit[code]]:=0;
end;
n:=n-1;
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
begin
clrscr;
write('Please enter file name: ');
readln(filnam);
filgreed:=filnam;
gotoxy(7,3);
write('Reading ...');
readtabl(filnam);
percent:=1;
line:=10;
gotoxy(7,5);
write('Processing...');
show(percent,line);
for i:=1 to 256 do for j:= 1 to 65 do newcode[i,j]:=2;
number:=n;
for code:=1 to number do begin
  letter:=sim[code];
    bit[code]:=0;
    n:=number;
    percent:=20+round(code/number*50);
    if percent>prcentold then begin
     show(percent,10);
     prcentold:=percent;
    end;
    uporad(letter,code,n,kol,sim,newcode);
end;
n:=number;
maxbit:=1;
for j:=1 to n do if maxbit<bit[j] then maxbit:=bit[j];
if maxbit>63 then begin
GOTOXY(1,7);
writeln('I can not archivate This File, because it is so big');
goto f1;
end;
for i:=1 to n do begin
  for j:=1 to bit[i] do bitn[bit[i]+1-j]:=newcode[i,66-j];
  for j:=bit[i]+1 to 65 do bitn[j]:=2;
  for j:=1 to 65 do newcode[i,j]:=bitn[j];
end;
i:=length(filnam);
filnam[i]:='f';
filnam[i-1]:='a';
filnam[i-2]:='h';
assign(ff,filnam);
rewrite(ff);
raz[1]:=trunc(sizegreed/8388608);
raz[2]:=trunc((sizegreed-raz[1]*8388608)/32768);
raz[3]:=trunc((sizegreed-raz[1]*8388608-raz[2]*32768)/128);
raz[4]:=trunc(sizegreed-raz[1]*8388608-raz[2]*32768-raz[3]*128);
i:=length(filnam);
for j:=1 to 3 do begin
ck:=ord(filgreed[i-3+j]);
write(ff,ck);
end;
for j:=1 to 4 do begin
c:=chr(raz[j]);
inc(sizenew);
ck:=ord(c);
write(ff,ck);
end;
if (maxbit=1) then kolbit:=1;
if (maxbit>1)and(maxbit<4) then kolbit:=2;
if (maxbit>=4)and(maxbit<=7) then kolbit:=3;
if (maxbit>=8)and(maxbit<=15) then kolbit:=4;
if (maxbit>=16)and(maxbit<=31) then kolbit:=5;
if (maxbit>=32)and(maxbit<=63) then kolbit:=6;
c:=chr(n);
inc(sizenew);
if n<256 then ck:=n else ck:=0;
write(ff,ck);
c:=chr(kolbit);
getbit(c,bitos);
for i:=1 to 186 do bitw[i]:=2;
for j:=1 to 3 do bitw[j]:=bitos[j+5];
nbit:=4;
for i:=1 to n do begin
  c:=sim[i];
  getbit(c,bitos);
  for j:=1 to 8 do bitw[nbit+j-1]:=bitos[j];
  nbit:=nbit+8;
  c:=chr(bit[i]);
  getbit(c,bitos);
  for j:=1 to kolbit do bitw[nbit+j-1]:=bitos[8-kolbit+j];
  nbit:=nbit+kolbit;
  for j:=1 to bit[i] do bitw[nbit+j-1]:=newcode[i,j];
  nbit:=nbit+bit[i];
  while nbit>8 do begin
   for j:=1 to 8 do bitos[j]:=bitw[j];
   ck:=dobyte(bitos);
   write(ff,ck);
   inc(sizenew);
   for j:=9 to 186 do bitw[j-8]:=bitw[j];
   nbit:=nbit-8;
  end;
end;
assign(greed,filgreed);
reset(greed);
size1:=0;
   while not(eof(greed)) do begin
    Read(greed,ck);
    inc(size1);
    percent:=70+round(size1/sizegreed*30);
    if percent>prcentold then begin
     show(percent,10);
     prcentold:=percent;
    end;
    c:=chr(ck);
    for j:=1 to 256 do 
     if sim[j]=c then begin
      code:=j;
      break;
     end;
    for j:=1 to bit[code] do bitw[nbit+j-1]:=newcode[code,j];
     nbit:=nbit+bit[code];
      while nbit>8 do begin
   for j:=1 to 8 do bitos[j]:=bitw[j];
   ck:=dobyte(bitos);
   write(ff,ck);
   inc(sizenew);
   for j:=9 to 186 do bitw[j-8]:=bitw[j];
   nbit:=nbit-8;
  end;
end;
close(greed);
for j:=1 to 8 do if bitw[j]<>2 then bitos[j]:=bitw[j] else bitos[j]:=1;
   ck:=dobyte(bitos);
   inc(sizenew);
   write(ff,ck);
close(ff);
gotoxy(1,13);
Writeln('Procces well done');
Writeln('Old File size is: ',sizegreed,' bytes');
Writeln('Arh File size is: ',sizenew,' bytes');
f1:
writeln;
write('Press any key....');
repeat until keypressed;
end.