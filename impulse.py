print("Введите a,b,c,d в строку через пробел ")

a,b,c,d = map(int , input().split() )
# funct = lambda a,b,c,d : ( ( a - b ) * ( 1 + 3 * c ) + 4 * d ) / 2

print(f"q = {( ( a - b ) * ( 1 + 3 * c ) + 4 * d ) / 2}")