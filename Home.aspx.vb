Public Class Home
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim roles As New List(Of ListItem) From {
                New ListItem("Admin", "1"),
                New ListItem("Editor", "2"),
                New ListItem("Viewer", "3")
            }

            ddlStatus.DataSource = roles
            ddlStatus.DataTextField = "Text"
            ddlStatus.DataValueField = "Value"
            ddlStatus.DataBind()

            ' Preselect Editor (ID = 2)
            ddlStatus.SelectedValue = "2"
        End If

    End Sub

End Class