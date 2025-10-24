<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Faculty.aspx.cs" Inherits="University.Faculty" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Gestión de Facultades</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/additional-methods.min.js"></script>
</head>
<body class="bg-light">
    <form id="form2" runat="server" class="container mt-5">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div class="card shadow-lg">
            <div class="card-header bg-primary text-white text-center">
                <h3 class="mb-0">Gestión de Facultades</h3>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Nombre</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Acrónimo</label>
                        <asp:TextBox ID="txtAcronym" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Decano</label>
                        <asp:TextBox ID="txtDean" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Logo (URL)</label>
                        <asp:TextBox ID="txtLogo" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Teléfono</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Correo</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Año de Fundación</label>
                        <asp:TextBox ID="txtYearFoundation" runat="server" CssClass="form-control" />
                    </div>
                </div>

                <div class="text-center mt-4">
                    <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-success me-2 px-4" Text="Agregar" OnClick="btnAdd_Click" />
                    <asp:Button ID="btnUpdate" runat="server" CssClass="btn btn-warning px-4" Text="Actualizar" OnClick="btnUpdate_Click" Enabled="false" />
                </div>

                <hr class="my-4" />

                <asp:GridView ID="gvFaculty" runat="server" CssClass="table table-striped table-hover text-center"
                    AutoGenerateColumns="False" DataKeyNames="faculty_id" OnRowCommand="gvFaculty_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="faculty_id" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="name_fac" HeaderText="Nombre" />
                        <asp:BoundField DataField="acronym_fac" HeaderText="Acrónimo" />
                        <asp:BoundField DataField="dean_name_fac" HeaderText="Decano" />
                        <asp:BoundField DataField="phone_fac" HeaderText="Teléfono" />
                        <asp:BoundField DataField="email_fac" HeaderText="Correo" />
                        <asp:BoundField DataField="year_foundation_fac" HeaderText="Año Fundación" />
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" Text="Editar"
                                    CommandName="Editar" CommandArgument='<%# Eval("faculty_id") %>' CssClass="btn btn-sm btn-primary me-1" />
                                <asp:LinkButton ID="btnDelete" runat="server" Text="Eliminar"
                                    CommandName="Eliminar" CommandArgument='<%# Eval("faculty_id") %>' CssClass="btn btn-sm btn-danger" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <script>
            $(document).ready(function () {
                var validator = $("#<%= form2.ClientID %>").validate({
                    rules: {
                        '<%= txtName.UniqueID %>': { required: true },
                        '<%= txtAcronym.UniqueID %>': { required: true },
                        '<%= txtDean.UniqueID %>': { required: true },
                        '<%= txtPhone.UniqueID %>': { required: true, digits: true, minlength: 10, maxlength: 10 },
                        '<%= txtEmail.UniqueID %>': { required: true, email: true },
                        '<%= txtYearFoundation.UniqueID %>': {
                            required: true,
                            digits: true,
                            min: new Date().getFullYear() - 100,
                            max: new Date().getFullYear()
                        },
                        '<%= txtLogo.UniqueID %>': { required: true, url: true }
                    },
                    messages: {
                        '<%= txtName.UniqueID %>': "Ingrese el nombre de la facultad",
                        '<%= txtAcronym.UniqueID %>': "Ingrese el acrónimo",
                        '<%= txtDean.UniqueID %>': "Ingrese el nombre del decano",
                        '<%= txtPhone.UniqueID %>': {
                            required: "Ingrese el teléfono",
                            digits: "Solo números",
                            minlength: "El teléfono debe tener 10 dígitos",
                            maxlength: "El teléfono debe tener 10 dígitos"
                        },
                        '<%= txtEmail.UniqueID %>': {
                            required: "Ingrese un correo electrónico",
                            email: "Ingrese un correo válido"
                        },
                        '<%= txtYearFoundation.UniqueID %>': {
                            required: "Ingrese el año de fundación",
                            digits: "Solo números",
                            min: "No puede ser mayor a 100 años atrás",
                            max: "No puede ser un año futuro"
                        },
                        '<%= txtLogo.UniqueID %>': {
                            required: "Ingrese la URL del logo",
                            url: "Ingrese una URL válida (http/https)"
                        }
                    },
                    errorClass: "text-danger",
                    errorPlacement: function (error, element) {
                        error.insertAfter(element);
                    },
                    highlight: function (element) {
                        $(element).addClass("is-invalid");
                    },
                    unhighlight: function (element) {
                        $(element).removeClass("is-invalid");
                    }
                });
            });
        </script>

    </form>
</body>
</html>
