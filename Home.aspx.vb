Public Class GoogleMap
    Implements System.Web.IHttpHandler

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"

        Dim address As String = context.Request.QueryString("address")


        Dim lat As Double = 0
        Dim lng As Double = 0

        getMap(address, lat, lng)

        Dim json As String = "{""lat"": " & lat & ", ""lng"": " & lng & "}"
        context.Response.Write(json)
    End Sub
    Private Sub getMap(address As String, ByRef lat As Double, ByRef lng As Double)

        lat = -29.8587
        lng = 31.0218
    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class
