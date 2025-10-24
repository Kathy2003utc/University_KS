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
        <div class="card shadow-lg">
            <div class="card-header bg-primary text-white text-center">
                <h3 class="mb-0">Gestión de Facultades</h3>
            </div>

            <div class="card-body">
                <div class="row g-3">
                    <!-- Nombre -->
                    <div class="col-md-6">
                        <label for="txtName" class="form-label fw-semibold">Nombre</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Nombre de la facultad" />
                    </div>

                    <!-- Acrónimo -->
                    <div class="col-md-6">
                        <label for="txtAcronym" class="form-label fw-semibold">Acrónimo</label>
                        <asp:TextBox ID="txtAcronym" runat="server" CssClass="form-control" placeholder="Ej. FISEI" />
                    </div>

                    <!-- Decano -->
                    <div class="col-md-6">
                        <label for="txtDean" class="form-label fw-semibold">Decano</label>
                        <asp:TextBox ID="txtDean" runat="server" CssClass="form-control" placeholder="Nombre del decano" />
                    </div>

                    <!-- Logo -->
                    <div class="col-md-6">
                        <label for="txtLogo" class="form-label fw-semibold">Logo (URL)</label>
                        <asp:TextBox ID="txtLogo" runat="server" CssClass="form-control" placeholder="Ruta o enlace del logo" />
                    </div>

                    <!-- Teléfono -->
                    <div class="col-md-6">
                        <label for="txtPhone" class="form-label fw-semibold">Teléfono</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Ej. 0999999999" />
                    </div>

                    <!-- Correo -->
                    <div class="col-md-6">
                        <label for="txtEmail" class="form-label fw-semibold">Correo</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="ejemplo@universidad.edu.ec" />
                    </div>

                    <!-- Año de Fundación -->
                    <div class="col-md-6">
                        <label for="txtYearFoundation" class="form-label fw-semibold">Año de Fundación</label>
                        <asp:TextBox ID="txtYearFoundation" runat="server" CssClass="form-control" placeholder="Ej. 1990" />
                    </div>
                </div>

                <!-- Botones -->
                <div class="text-center mt-4">
                    <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-success me-2 px-4" Text="Agregar" OnClick="btnAdd_Click" />
                    <asp:Button ID="btnUpdate" runat="server" CssClass="btn btn-warning px-4" Text="Actualizar" OnClick="btnUpdate_Click" />
                </div>

                <hr class="my-4" />

                <!-- Tabla -->
                <asp:GridView ID="gvFaculty" runat="server" CssClass="table table-striped table-hover text-center align-middle"
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
                                <asp:Button ID="btnEdit" runat="server" Text="Editar"
                                    CssClass="btn btn-sm btn-primary me-1"
                                    CommandName="ActualizarFila"
                                    CommandArgument='<%# Eval("faculty_id") %>'
                                    CausesValidation="false" />
                                <asp:Button ID="btnDelete" runat="server" Text="Eliminar"
                                    CssClass="btn btn-sm btn-danger"
                                    CommandName="EliminarFila"
                                    CommandArgument='<%# Eval("faculty_id") %>'
                                    CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            $(document).ready(function () {

                // Inicialmente bloqueamos el botón Actualizar
                $("#<%= btnUpdate.ClientID %>").prop("disabled", true);

                // Validación jQuery
                $("#<%= form2.ClientID %>").validate({
                    rules: {
                        txtName: { required: true },
                        txtAcronym: { required: true },
                        txtDean: { required: true },
                        txtPhone: { required: true, digits: true, minlength: 10, maxlength: 10 },
                        txtEmail: { required: true, email: true },
                        txtYearFoundation: {
                            required: true,
                            digits: true,
                            min: new Date().getFullYear() - 50,
                            max: new Date().getFullYear()
                        },
                        txtLogo: { required: true, url: true }
                    },
                    messages: {
                        txtName: "Ingrese el nombre de la facultad",
                        txtAcronym: "Ingrese el acrónimo",
                        txtDean: "Ingrese el nombre del decano",
                        txtPhone: {
                            required: "Ingrese el teléfono",
                            digits: "Solo números",
                            minlength: "El teléfono debe tener 10 dígitos",
                            maxlength: "El teléfono debe tener 10 dígitos"
                        },
                        txtEmail: {
                            required: "Ingrese un correo electrónico",
                            email: "Ingrese un correo válido"
                        },
                        txtYearFoundation: {
                            required: "Ingrese el año de fundación",
                            digits: "Solo números",
                            min: "No puede ser mayor a 50 años atrás",
                            max: "No puede ser un año futuro"
                        },
                        txtLogo: {
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
