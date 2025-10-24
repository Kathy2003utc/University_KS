<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Faculty.aspx.cs" Inherits="University.Faculty" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">

        <!-- Card principal más ancho -->
        <div class="card shadow-lg mx-auto w-100" style="max-width: 1400px;">
            <div class="card-header text-center">
                Gestión de Facultades
            </div>
            <div class="card-body">

                <!-- Formulario centrado en dos columnas -->
                <div class="row g-3 justify-content-center">
                    <div class="col-md-6 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Nombre</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control text-center" />
                    </div>
                    <div class="col-md-6 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Acrónimo</label>
                        <asp:TextBox ID="txtAcronym" runat="server" CssClass="form-control text-center" />
                    </div>
                    <div class="col-md-6 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Decano</label>
                        <asp:TextBox ID="txtDean" runat="server" CssClass="form-control text-center" />
                    </div>
                    <div class="col-md-6 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Logo (URL)</label>
                        <asp:TextBox ID="txtLogo" runat="server" CssClass="form-control text-center" />
                    </div>
                    <div class="col-md-6 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Teléfono</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control text-center" />
                    </div>
                    <div class="col-md-6 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Correo</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control text-center" />
                    </div>
                    <div class="col-md-6 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Año de Fundación</label>
                        <asp:TextBox ID="txtYearFoundation" runat="server" CssClass="form-control text-center" />
                    </div>
                </div>

                <!-- Botones centrados -->
                <div class="text-center mt-4">
                    <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-success btn-custom me-2" Text="Agregar" OnClick="btnAdd_Click" />
                    <asp:Button ID="btnUpdate" runat="server" CssClass="btn btn-warning btn-custom" Text="Actualizar" OnClick="btnUpdate_Click" Enabled="false" />
                </div>

                <hr class="my-4" />

                <!-- GridView compacto y visible completo -->
                <div class="table-responsive">
                    <asp:GridView ID="gvFaculty" runat="server"
                        CssClass="table table-striped table-hover table-sm text-center align-middle w-100"
                        AutoGenerateColumns="False" DataKeyNames="faculty_id" OnRowCommand="gvFaculty_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="faculty_id" HeaderText="ID" ReadOnly="True" />
                            <asp:BoundField DataField="name_fac" HeaderText="Nombre" />
                            <asp:BoundField DataField="acronym_fac" HeaderText="Acrónimo" />
                            <asp:BoundField DataField="dean_name_fac" HeaderText="Decano" />
                            <asp:BoundField DataField="phone_fac" HeaderText="Teléfono" />
                            <asp:BoundField DataField="email_fac" HeaderText="Correo" />
                            <asp:BoundField DataField="year_foundation_fac" HeaderText="Año Fundación" />
                            <asp:BoundField DataField="logo_fac" HeaderText="Ruta del Logo" />

                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>
                                    <div class="d-flex justify-content-center gap-1">
                                        <asp:LinkButton ID="btnEdit" runat="server" Text="Editar"
                                            CommandName="Editar" CommandArgument='<%# Eval("faculty_id") %>' CssClass="btn btn-sm btn-primary" />
                                        <asp:LinkButton ID="btnDelete" runat="server" Text="Eliminar"
                                            CommandName="Eliminar" CommandArgument='<%# Eval("faculty_id") %>' CssClass="btn btn-sm btn-danger" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

            </div>
        </div>

    </div>

    <style>
        /* Card y encabezado */
        .card { border-radius: 1rem; }
        .card-header {
            background: linear-gradient(90deg, #4e73df, #224abe);
            color: #fff; font-weight: 600; font-size: 1.25rem;
        }

        /* Formulario */
        .form-label { font-weight: 500; }
        .btn-custom { border-radius: 50px; padding: 0.5rem 1.5rem; font-weight: 500; }

        /* Tabla */
        .table thead { background-color: #4e73df; color: #fff; }
        .table-hover tbody tr:hover { background-color: #dbe5ff; }
        .table-sm th, .table-sm td { padding: 0.25rem 0.3rem; font-size: 0.75rem; }
        .table .btn-sm { padding: 0.2rem 0.4rem; font-size: 0.7rem; }
        .table-responsive { overflow-x: auto; }

        /* Validación */
        .is-invalid { border-color: #dc3545 !important; }
        .text-danger { font-size: 0.875rem; }
    </style>

    <!-- jQuery Validation -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/additional-methods.min.js"></script>

    <script>
        $(document).ready(function () {
            $("#<%= Page.Form.ClientID %>").validate({
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

</asp:Content>
