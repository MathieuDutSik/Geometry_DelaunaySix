TotalList:=[];
Append(TotalList, SIMPLEX_GetEnumerationResults(6));
for i in [1..20]
do
  eRead:=ReadAsFunction(Concatenation("ListCorank", String(i)))();
  Append(TotalList, eRead);
od;
Print("|TotalList|=", Length(TotalList), "\n");
SaveDataToFile("ListDelaunay6", TotalList);