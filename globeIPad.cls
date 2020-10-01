Sub WriteGlobeFileIpad()

Dim FilePath As String
Dim CellData As String
Dim LastCol As Integer
Dim LastRow As Long
Dim i As Integer, j As Integer, c As Integer
Dim myarray As Variant
Dim q As String


Dim sh1 As Worksheet

Set sh1 = ActiveWorkbook.Sheets("List")
myarray = Array("ProjectNumber", "Reference", "jobName", "PracticeArea", "OfficeCode", "BuiltorUnbuilt", "projectInformation", "projectAddress", "projectCoordinates", "InApp", "Legacy", "Services", "ImagePath1", "ImagePath2", "ImagePath3", "ImagePath4", "ImagePath5", "projectAddress2")

LastCol = 18
'sh1.UsedRange.SpecialCells(x1CellTypeLastCell).Column
With ActiveSheet
    LastRow = .Cells(.Rows.Count, "A").End(xlUp).Row
End With
'sh1.UsedRange.SpecialCells(x1CellTypeLastCell).Row

q = Chr(34)
CellData = ""
c = 1
'MsgBox (Application.DefaultFilePath)

FilePath = Application.DefaultFilePath & "\GlobeiPad.cs"

'Open FilePath For Output As #2

Dim fsT As Object
Set fsT = CreateObject("ADODB.Stream")
fsT.Type = 2 'Specify stream type - we want To save text/string data.
fsT.Charset = "utf-8" 'Specify charset For the source text data.
fsT.Open 'Open the stream And write binary data To the object

For i = 2 To LastRow
    CellData = CellData & "Globe n" & c & " = new Globe();" & vbCrLf
    For j = 1 To LastCol
                
        If (Trim(sh1.Cells(i, j).Value) <> "") Then
            If (j = 18) Then
                CellData = CellData & "n" & c & "." & myarray(j - 1) & " = " & q & (Trim(sh1.Cells(i, j).Value)) & q & ";" & vbCrLf
            ElseIf (j > 12) Then
                CellData = CellData & "n" & c & "." & myarray(j - 1) & " = " & q & ("ProjectImages/") & LCase(Trim(sh1.Cells(i, j).Value)) & "_ipad.jpg" & q & ";" & vbCrLf
            ElseIf (j = 12) Then
                CellData = CellData & ""
            ElseIf (j = 11) Then
                CellData = CellData & "n" & c & "." & myarray(j - 1) & " = " & (LCase(Trim(sh1.Cells(i, j).Value))) & ";" & vbCrLf
            ElseIf (j = 10) Then
                CellData = CellData & ""
            ElseIf (j = 9) Then
                Dim CoordArray() As String
                CoordArray = Split(Trim(sh1.Cells(i, j).Value), ",")
                CellData = CellData & "n" & c & "." & "projectLatitude" & " = " & CoordArray(0) & ";" & vbCrLf & "n" & c & "." & "projectLongitude" & " = " & CoordArray(1) & ";" & vbCrLf
           ElseIf (j = 8) Then
               Dim AddArray() As String
               Dim AddStr As String
               Dim a As Integer
               AddStr = ""
               AddArray = Split(sh1.Cells(i, j).Value, vbLf)
               For a = 0 To (UBound(AddArray))
                   If a = 0 Then
                       AddStr = AddStr & AddArray(0)
                   Else
                       AddStr = AddStr & "\n" & AddArray(a)
                   End If
               Next a
               CellData = CellData & "n" & c & "." & myarray(j - 1) & " = " & q & AddStr & q & ";" & vbCrLf

            ElseIf (j = 7) Then
                Dim DescArray() As String
                Dim ConcDesc As String
                Dim d As Integer
                ConcDesc = ""
                DescArray = Split(sh1.Cells(i, j).Value, vbLf)
                For d = 0 To (UBound(DescArray))
                    If d = 0 Then
                        ConcDesc = ConcDesc & DescArray(0)
                    Else
                        ConcDesc = ConcDesc & "\n\n" & DescArray(d)
                    End If
                Next d
                CellData = CellData & "n" & c & "." & myarray(j - 1) & " = " & q & ConcDesc & q & ";" & vbCrLf
            ElseIf (j = 6) Then
                CellData = CellData & ""
            ElseIf (j = 5) Then
                CellData = CellData & ""
            ElseIf (j = 3) Then
                CellData = CellData & "n" & c & "." & myarray(j - 1) & " = " & q & "\n" & Trim(sh1.Cells(i, j).Value) & q & ";" & vbCrLf
            ElseIf (j = 2) Then
                CellData = CellData & ""
            ElseIf (j = 1) Then
                CellData = CellData & ""
            Else
                CellData = CellData & "n" & c & "." & myarray(j - 1) & " = " & q & Trim(sh1.Cells(i, j).Value) & q & ";" & vbCrLf
            End If
        End If
        
    Next j
    
CellData = CellData & "pjData.Add (" & "n" & c & ");" & vbCrLf
    If sh1.Cells(i, 10).Value = False Then
        CellData = ""
    ElseIf sh1.Cells(i, 8).Value = "" Then
        CellData = ""
    ElseIf sh1.Cells(i, 11).Value <> True Then
        If sh1.Cells(i, 6).Value = "" Then
            CellData = ""
        ElseIf sh1.Cells(i, 13).Value = "" Then
            CellData = ""
        End If
    End If
    If CellData <> "" Then
    fsT.WriteText CellData
        'Print #2, CellData
    c = c + 1
    CellData = ""
    End If
    
Next i

fsT.SaveToFile FilePath, 2 'Save binary data To disk
'Close #2

MsgBox ("Done. File is in: " & Application.DefaultFilePath)

End Sub