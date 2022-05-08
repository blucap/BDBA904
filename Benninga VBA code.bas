'8/5/2006 Thanks to Maja Sliwinski and Beni Czaczkes
Function getformula(r As Range) As String
   Application.Volatile
   If r.HasArray Then
   getformula = ChrW(8592) & " " & " {" & r.FormulaArray & "}"
   Else
   getformula = ChrW(8592) & " " & r.FormulaArray
   End If
End Function

'NXNPV solves some problems in the XNPV function
'Written by Benjamin Czaczkes, summer 2007

Function NXNPV(Rate As Double, Values As Range, Dates As Range)
Dim Dsize As Integer
Dim Vsize As Integer
Dsize = Dates.Rows.Count
Vsize = Values.Rows.Count
If Dsize <> Vsize Then
    NXNPV = CVErr(xlErrNum)
    Exit Function
End If
Dim aValues
Dim aDates
Dim tempsum As Double
Dim r As Double
Dim dd As Long
Dim i As Integer
aValues = Values
aDates = Dates
r = 1 + Rate
tempsum = 0
dd = aDates(1, 1)
For i = 1 To Dsize
    tempsum = tempsum + aValues(i, 1) / r ^ ((aDates(i, 1) - dd) / 365)
Next i
NXNPV = tempsum
End Function
Private Function annpv(Rate As Double, aValues, aDates)
Dim Dsize As Integer
Dsize = UBound(aDates)
Dim tempsum As Double
Dim r As Double
Dim dd As Long
Dim i As Integer
r = 1 + Rate
tempsum = 0
dd = aDates(1, 1)
For i = 1 To Dsize
    tempsum = tempsum + aValues(i, 1) / r ^ ((aDates(i, 1) - dd) / 365)
Next i
annpv = tempsum
End Function

'NXIRR solves some problems in the XIRR function
'It uses the ANNPV function above
'Written by Benjamin Czaczkes, summer 2007

Function NXIRR(Values As Range, Dates As Range, Optional Guess As Double = 0.1)
    Const epsilon As Double = 0.0001
    Dim D As Double
    Dim V As Double
    Dim oldV As Double
    Dim r As Double
    Dim Change As Boolean
    Dim i As Integer
    Dim StopNow As Boolean
    Dim Dsize As Integer
    Dim Vsize As Integer
    Dsize = Dates.Rows.Count
    Vsize = Values.Rows.Count
    If Dsize <> Vsize Then
        NXIRR = CVErr(xlErrNum)
        Exit Function
    End If
    Dim aValues
    Dim aDates
    aValues = Values
    aDates = Dates
    r = Guess
    D = 0.01
    oldV = annpv(r, aValues, aDates)
    StopNow = Abs(oldV) < epsilon
    i = 1
    Do Until StopNow
        r = r + D
        V = annpv(r, aValues, aDates)
        Change = (V > oldV And V > 0) Or (V < oldV And V < 0)
        If Change Then
        D = -D * 0.5
        End If
        i = i + 1
        StopNow = (i > 100) Or Abs(V) < epsilon
        oldV = V
    Loop
    NXIRR = r
End Function