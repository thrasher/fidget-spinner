PI = 3.14159;
N_LINKS = 20;

function rad(n=2) = 1 / (4 * sin(180 / n));

echo(PI);
echo("<b>rad 20 = </b>", rad(20));
echo(rad(20));

cylinder(r=rad(N_LINKS), h=.5);

