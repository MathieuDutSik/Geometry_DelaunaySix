GetDimension5:=function()
  local FileSave, ListDelaunay, ListInv, FuncInsertDelaunay, rnk, eFile, ListEXT, EXT, ListSets, eSet, eDelaunay, ListOriginEXT, RecSave;
  #
  # We search the five-dimensional ones as 
  # facets of lower dimensional
  #
  FileSave:="Delaunay_Dimension5";
  if IsExistingFile(FileSave)=false then
    ListDelaunay:=[];
    ListOriginEXT:=[];
    ListInv:=[];
    FuncInsertDelaunay:=function(eDelaunay, EXT)
      local nbDelaunay, iDelaunay, test, eInv;
      nbDelaunay:=Length(ListDelaunay);
      eInv:=LinPolytope_Invariant(eDelaunay);
      for iDelaunay in [1..nbDelaunay]
      do
        if ListInv[iDelaunay]=eInv then
          test:=LinPolytopeIntegral_Isomorphism(ListDelaunay[iDelaunay], eDelaunay);
          if test<>false then
            return;
          fi;
        fi;
      od;
      Add(ListDelaunay, eDelaunay);
      Add(ListOriginEXT, EXT);
      Add(ListInv, eInv);
      Print("Now |ListDelaunay|=", Length(ListDelaunay), "\n");
    end;
    for rnk in [1..20]
    do
      Print("rnk=", rnk, "\n");
      eFile:=Concatenation("RESULT_REF/ListCorank", String(rnk));
      ListEXT:=ReadAsFunction(eFile)();
      Print("|ListEXT|=", Length(ListEXT), "\n");
      for EXT in ListEXT
      do
        ListSets:=DualDescriptionSets(EXT);
        for eSet in ListSets
        do
          eDelaunay:=ColumnReduction(EXT{eSet}).EXT;
          FuncInsertDelaunay(eDelaunay, EXT);
        od;
      od;
    od;
    RecSave:=rec(ListDelaunay:=ListDelaunay, ListOriginEXT:=ListOriginEXT);
    SaveDataToFile(FileSave, RecSave);
  else
    RecSave:=ReadAsFunction(FileSave)();
  fi;
  return RecSave;
end;


GetSimplicialFacesPolytope:=function()
  local L_ListSets, ListSeek, rnk, eFile, ListEXT, EXT, ListSets, ListLen, FileSave;
  #
  # We search the ones with only simplicial facets.
  #
  L_ListSets:=[];
  FileSave:="Delaunay_WithSimplicialFaces";
  if IsExistingFile(FileSave)=false then
    ListSeek:=[];
    for rnk in [1..20]
    do
      Print("rnk=", rnk, "\n");
      eFile:=Concatenation("RESULT_REF/ListCorank", String(rnk));
      ListEXT:=ReadAsFunction(eFile)();
      Print("|ListEXT|=", Length(ListEXT), "\n");
      for EXT in ListEXT
      do
        ListSets:=DualDescriptionSets(EXT);
        ListLen:=List(ListSets,Length);
        if Set(ListLen)=[6] then
          Add(ListSeek, EXT);
        fi;
      od;
    od;
    SaveDataToFile(FileSave, ListSeek);
  else
    ListSeek:=ReadAsFunction(FileSave)();
  fi;
end;


CheckDelaunayness:=function()
  local eFile, ListEXT, EXT, rnk, eRec, ListCorrectRec, NewRec;
  ListCorrectRec:=[];
  for rnk in [1..20]
  do
    Print("rnk=", rnk, "\n");
    eFile:=Concatenation("RESULT_REF/ListCorank", String(rnk));
    ListEXT:=ReadAsFunction(eFile)();
    Print("|ListEXT|=", Length(ListEXT), "\n");
    for EXT in ListEXT
    do
      eRec:=TestRealizabilityDelaunay(EXT);
      if eRec.reply=false then
        Error("Well our published results are false");
      fi;
      NewRec:=rec(EXT:=EXT, TheFunc:=eRec.TheFunc);
      Add(ListCorrectRec, NewRec);
    od;
  od;
end;


#CheckDelaunayness();
RecSave:=GetDimension5();

ListLen:=List(RecSave.ListDelaunay, Length);
ePerm:=SortingPerm(ListLen);
ListDelaunayReord:=Permuted(RecSave.ListDelaunay, ePerm);
ListOriginEXT_Reord:=Permuted(RecSave.ListOriginEXT, ePerm);



