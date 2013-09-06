clear
// History:
// 29.04 added print function 'fprintx', убрана непосредственная печать из функций

// Блок определения констант
epsilon=0.0001;
bol_chk=0; // Булева переменная, исп. в проверках разности и epsilon
h=0.01;
h_max_l=0; // Найденное значение h слева, при котором выполняется условие останова
h_max_r=0; // Найденное значение h справа, при котором выполняется условие останова
h_max_c=0; // Найденное значение h по центру, при котором выполняется условие останова
x=0;
f=0;
t = tlist(["funclist","arg","func"],[],[]);
i=1;

for x=0:+0.1:2,
    f=exp(x+3)*cos(2*x^5)/(x^4+atan(3+25*x)^2);
    t.arg(i)=x;
    t.func(i)=f;
    i=i+1;
end


//function %funclist_p(mytlist)
//mprintf("%f %f\n", mytlist(2), mytlist(3));
//endfunction

//t(2)=justify(t(2),'r')
//disp(t)
disp("h=0")
mprintf("| %f | %f   |\n",t(2),t(3));
disp("----------------------------------------------")

// Исходная функция
function y=f(x)
    y=exp(x+3)*cos(2*x^5)/((x^4)+(atan(2+25*x)^2));
endfunction

// Печать значения нужной функции при найденном значении h для всех значений x

function fprintx(fname,h,typef)
    select typef,
    case 'left' then
        fn=fl(h);
        name='Значения левой производной';
    case 'right' then
        fn=fr(h);
        name='Значения правой производной';
    case 'central' then
        fn=fc(h);
        name='Значения центральной производной',
    else 
        disp('Не задано направление производной');   
            return,
    end
    mprintf("| %f | %f   |\n",fname.arg,fname.func);
endfunction
// Описание функции вычисления левой производной
function fl_eval=fl(h)
    fl_eval=0;
    x=0;
    i=1;
//    deriv_l=tlist(["left_der","arg","func"],[],[])
    fl_eval=tlist(["left_der","arg","func"],[],[])
    for x=0:+0.001:2,
        fl_eval.arg(i)=x;
        fl_eval.func(i)=-(f(x-h)-f(x))/h;
        i=i+1;
    end
//    disp("Значения левой производной:");
//    disp(" - - - - - - - - - - - -");
//    mprintf("| %f | %f   |\n",fl_eval.arg,fl_eval.func);
//    disp(" - - - - - - - - - - - -");
endfunction

// Описание функции вычисления правой производной
function fr_eval=fr(h)
    fr_eval=0;
    x=0;
    i=1;
//    deriv_r=tlist(["right_der","arg","func"],[],[])
    fr_eval=tlist(["right_der","arg","func"],[],[])
    for x=0:+0.001:2,
        fr_eval.arg(i)=x;
        fr_eval.func(i)=(f(x+h)-f(x))/h;
        i=i+1;
    end
//    disp("Значения правой производной:");
//    disp(" - - - - - - - - - - - -");
//    mprintf("| %f | %f   |\n",fr_eval.arg,fr_eval.func);
//    disp(" - - - - - - - - - - - -");
endfunction

// Описание функции вычисления центральной производной
function fc_eval=fc(h)
    fc_eval=0;
    x=0;
    i=1;
//    deriv_c=tlist(["center_der","arg","func"],[],[])
    fc_eval=tlist(["center_der","arg","func"],[],[])
    for x=0:+0.001:2,
        fc_eval.arg(i)=x;
        fc_eval.func(i)=(f(x+h)-f(x-h))/(2*h);
        i=i+1;
    end
//    disp("Значения центральной производной:");
//    disp(" - - - - - - - - - - - -");
//    mprintf("| %f | %f   |\n",fc_eval.arg,fc_eval.func);
//    disp(" - - - - - - - - - - - -");
endfunction

w=fl(h)
w=fr(h)
w=fc(h)

// Поиск h для центральной производной
h=0.01;
chk1=fc(h);
wc=1;
while and(1),
    bol_chk=0;
//    mprintf('При h=%f\n',h);
    chk1=fc(h);
    h=h/2;
//    mprintf('При h=%f\n',h);
    chk2=fc(h);
//    mprintf('Номер прохода=%i\n',wc)
// Вывод разности в проходе
    for i=1:21,
        // disp(chk2.func(i)-chk1.func(i),": ",i);
//        mprintf('Iteration=%i , Difference=%f\n',i,chk2.func(i)-chk1.func(i));
        if abs(chk2.func(i)-chk1.func(i))<=epsilon then
            bol_chk=bol_chk+1;
        end
    end
    if bol_chk==21 then
        disp("Центральная производная");
        mprintf('Значение аргумента: %.1f значение функции: %.9e\n',chk2.arg,chk2.func);
        mprintf('Достигнуто попадание при любом x на значении h=%.9e\n',h);
        mprintf('На проходе=%i\n',wc);
        h_max_c=h;
        break;
    end
    wc=wc+1;
end

// Поиск h для левой производной
h=0.01;
chk1=fl(h);
wl=1;
while and(1),
    bol_chk=0;
//    mprintf('При h=%f\n',h);
    chk1=fl(h);
    h=h/2;
//    mprintf('При h=%f\n',h);
    chk2=fl(h);
//    mprintf('Номер прохода=%i\n',wl)
// Вывод разности в проходе
    for i=1:21,
        // disp(chk2.func(i)-chk1.func(i),": ",i);
//        mprintf('Iteration=%i , Difference=%f\n',i,chk2.func(i)-chk1.func(i));
        if abs(chk2.func(i)-chk1.func(i))<=epsilon then
            bol_chk=bol_chk+1;
        end
    end
    if bol_chk==21 then
        disp("Левая производная");
        mprintf('Значение аргумента: %.1f значение функции: %.9e\n',chk2.arg,chk2.func);
        mprintf('Достигнуто попадание при любом x на значении h=%.9e\n',h);
        mprintf('На проходе=%i\n',wl);
        h_max_l=h;
        break;
    end
    wl=wl+1;
end

// Поиск h для правой производной
h=0.01;
chk1=0;
chk2=0;
i=1;
chk1=fr(h);
wr=1;
while and(1),
    bol_chk=0;
//    mprintf('При h=%f\n',h);
    chk1=fr(h);
    h=h/2;
//    mprintf('При h=%f\n',h);
    chk2=fr(h);
//    mprintf('Номер прохода=%i\n',wr)
// Вывод разности в проходе
//    mprintf('Проход=%i:\n',wr);
    for i=1:21,
        // disp(chk2.func(i)-chk1.func(i),": ",i);
//        mprintf('Iteration=%i , Difference=%f\n',i,chk2.func(i)-chk1.func(i));
//        mprintf('    Difference=%.11e\n',chk2.func(i)-chk1.func(i));
        if abs(chk2.func(i)-chk1.func(i))<=epsilon then
            bol_chk=bol_chk+1;
        end
    end
    if bol_chk==21 then
        disp("Правая производная");
        mprintf('Значение аргумента: %.1f значение функции: %.9e\n',chk2.arg,chk2.func); 
        mprintf('Достигнуто попадание при любом x на значении h=%.9e\n\n',h);
        mprintf('На проходе=%i\n',wr);
        h_max_r=h;
        break;
    end
    wr=wr+1;
end

// Контрольные значения
// Задать интересующие h(степень указывает на итерацию шага)
h=0.01/2^02;
cntl_l=fl(h);
cntl_c=fc(h);
cntl_r=fr(h);
mprintf('\n\n');
mprintf('Контрольное значение для h=%.9e :\n',h);
mprintf('   Left   ,   center   ,   right\n');
mprintf('%.9f , %.9f , %.9f \n',cntl_l.func,cntl_c.func,cntl_r.func);
mprintf('\n\n');


mprintf('Окончательный результат для\n');
mprintf('h_левая=%.9e , h_правая=%.9e , h_центр=%.9e\n',h_max_l,h_max_r,h_max_c);
mprintf('Левый проход=%i, правый проход=%i, центр. проход=%i\n',wl,wr,wc);

plot(cntl_l.arg,cntl_l.func,'r',cntl_c.arg,cntl_c.func,'g',cntl_r.arg,cntl_r.func,'b')
//plot2d(x^4);
//plot2d(exp(x+3));
