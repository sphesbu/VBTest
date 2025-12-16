Public Class staff
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            Dim roles As New List(Of Role) From {
                New Role With {.ID = 1, .Name = "Admin", .Count = 2},
                New Role With {.ID = 2, .Name = "Editor", .Count = 5},
                New Role With {.ID = 3, .Name = "Viewer", .Count = 10}
            }

            ddlStatus.DataSource = roles
            ddlStatus.DataTextField = "DisplayText"
            ddlStatus.DataValueField = "Id"
            ddlStatus.DataBind()


            ' Preselect Editor (Id = 2)
            ddlStatus.SelectedValue = "2"

        End If

    End Sub

    Public Class Role
        Public Property Id As Integer
        Public Property Name As String
        Public Property Count As Integer

        Public ReadOnly Property DisplayText As String
            Get
                Return $"{Name} ({Count})"
            End Get
        End Property
    End Class



End Class