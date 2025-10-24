<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Professor.aspx.cs" Inherits="University.Professor" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">
        <div class="card shadow-lg mx-auto" style="max-width: 600px;">
            <div class="card-header text-center">
                Gestión de Profesores
            </div>

            <div class="card-body">
                <!-- Formulario centrado -->
                <div class="row g-3 justify-content-center">
                    <div class="col-12 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Carrera</label>
                        <asp:DropDownList ID="ddlCareer" runat="server" CssClass="form-select w-75"></asp:DropDownList>
                    </div>

                    <div class="col-12 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Nombre</label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control w-75" />
                    </div>

                    <div class="col-12 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Apellido</label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control w-75" />
                    </div>

                    <div class="col-12 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Correo</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control w-75" />
                    </div>

                    <div class="col-12 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Teléfono</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control w-75" />
                    </div>
                </div>

                <!-- Botones centrados -->
                <div class="text-center mt-4">
                    <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-success btn-custom me-2" Text="Agregar" OnClick="btnAdd_Click" />
                    <asp:Button ID="btnUpdate" runat="server" CssClass="btn btn-warning btn-custom" Text="Actualizar" OnClick="btnUpdate_Click" Enabled="false" />
                </div>

                <hr class="my-4" />

                <!-- GridView -->
                <asp:GridView ID="gvProfessor" runat="server" CssClass="table table-striped table-hover text-center align-middle"
                    AutoGenerateColumns="False" DataKeyNames="professor_id" OnRowCommand="gvProfessor_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="professor_id" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="career_name" HeaderText="Carrera" />
                        <asp:BoundField DataField="first_name" HeaderText="Nombre" />
                        <asp:BoundField DataField="last_name" HeaderText="Apellido" />
                        <asp:BoundField DataField="email" HeaderText="Correo" />
                        <asp:BoundField DataField="phone" HeaderText="Teléfono" />

                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" Text="Editar"
                                    CommandName="Editar" CommandArgument='<%# Eval("professor_id") %>' CssClass="btn btn-sm btn-primary me-1" />
                                <br /><br />
                                <asp:LinkButton ID="btnDelete" runat="server" Text="Eliminar"
                                    CommandName="Eliminar" CommandArgument='<%# Eval("professor_id") %>' CssClass="btn btn-sm btn-danger" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- Estilos -->
    <style>
        .card { border-radius: 1rem; }
        .card-header {
            background: linear-gradient(90deg, #1cc88a, #0c9f69);
            color: #fff; font-weight: 600; font-size: 1.25rem;
        }
        .form-label { font-weight: 500; }
        .btn-custom { border-radius: 50px; padding: 0.5rem 1.5rem; font-weight: 500; }
        .table thead { background-color: #1cc88a; color: #fff; }
        .table-hover tbody tr:hover { background-color: #dff9e4; }
        .is-invalid { border-color: #dc3545 !important; }
        .text-danger { font-size: 0.875rem; }
    </style>

    <!-- jQuery Validation -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>
    <script>
        $(document).ready(function () {
            $("#<%= Page.Form.ClientID %>").validate({
                rules: {
                    '<%= txtFirstName.UniqueID %>': { required: true },
                    '<%= txtLastName.UniqueID %>': { required: true },
                    '<%= txtEmail.UniqueID %>': { required: true, email: true },
                    '<%= txtPhone.UniqueID %>': { required: true, digits: true, minlength: 10, maxlength: 10 },
                    '<%= ddlCareer.UniqueID %>': { required: true }
                },
                messages: {
                    '<%= txtFirstName.UniqueID %>': "Ingrese el nombre",
                    '<%= txtLastName.UniqueID %>': "Ingrese el apellido",
                    '<%= txtEmail.UniqueID %>': { required: "Ingrese el correo", email: "Correo inválido" },
                    '<%= txtPhone.UniqueID %>': { required: "Ingrese el teléfono", digits: "Solo números", minlength: "Debe tener 10 dígitos", maxlength: "Debe tener 10 dígitos" },
                    '<%= ddlCareer.UniqueID %>': "Seleccione una carrera"
                },
                errorClass: "text-danger",
                errorPlacement: function (error, element) { error.insertAfter(element); },
                highlight: function (element) { $(element).addClass("is-invalid"); },
                unhighlight: function (element) { $(element).removeClass("is-invalid"); }
            });
        });
    </script>

</asp:Content>
