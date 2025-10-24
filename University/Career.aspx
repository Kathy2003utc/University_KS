<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Career.aspx.cs" Inherits="University.Career" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">
        <div class="card shadow-lg mx-auto" style="max-width: 600px;">
            <div class="card-header text-center">
                Gestión de Carreras
            </div>

            <div class="card-body">
                <!-- Formulario centrado -->
                <div class="row g-3 justify-content-center">
                    <div class="col-12 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Facultad</label>
                        <asp:DropDownList ID="ddlFaculty" runat="server" CssClass="form-select w-75"></asp:DropDownList>
                    </div>

                    <div class="col-12 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Nombre de la Carrera</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control w-75" />
                    </div>

                    <div class="col-12 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Duración (años)</label>
                        <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control w-75" />
                    </div>

                    <div class="col-12 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Modalidad</label>
                        <asp:TextBox ID="txtModality" runat="server" CssClass="form-control w-75" />
                    </div>

                    <div class="col-12 d-flex flex-column align-items-center">
                        <label class="form-label text-center">Título que Otorga</label>
                        <asp:TextBox ID="txtDegree" runat="server" CssClass="form-control w-75" />
                    </div>
                </div>

                <!-- Botones centrados -->
                <div class="text-center mt-4">
                    <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-success btn-custom me-2" Text="Agregar" OnClick="btnAdd_Click" />
                    <asp:Button ID="btnUpdate" runat="server" CssClass="btn btn-warning btn-custom" Text="Actualizar" OnClick="btnUpdate_Click" Enabled="false" />
                </div>

                <hr class="my-4" />

                <!-- GridView -->
                <asp:GridView ID="gvCareer" runat="server" CssClass="table table-striped table-hover text-center align-middle"
                    AutoGenerateColumns="False" DataKeyNames="career_id" OnRowCommand="gvCareer_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="career_id" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="faculty_name" HeaderText="Facultad" />
                        <asp:BoundField DataField="name" HeaderText="Carrera" />
                        <asp:BoundField DataField="duration" HeaderText="Duración" />
                        <asp:BoundField DataField="modality" HeaderText="Modalidad" />
                        <asp:BoundField DataField="degree_title" HeaderText="Título que Otorga" />

                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" Text="Editar"
                                    CommandName="Editar" CommandArgument='<%# Eval("career_id") %>' CssClass="btn btn-sm btn-primary me-1" />
                                <br /><br />
                                <asp:LinkButton ID="btnDelete" runat="server" Text="Eliminar"
                                    CommandName="Eliminar" CommandArgument='<%# Eval("career_id") %>' CssClass="btn btn-sm btn-danger" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- Estilos -->
    <style>
        .card {
            border-radius: 1rem;
        }

        .card-header {
            background: linear-gradient(90deg, #1cc88a, #0c9f69);
            color: #fff;
            font-weight: 600;
            font-size: 1.25rem;
        }

        .form-label {
            font-weight: 500;
        }

        .btn-custom {
            border-radius: 50px;
            padding: 0.5rem 1.5rem;
            font-weight: 500;
        }

        .table thead {
            background-color: #1cc88a;
            color: #fff;
        }

        .table-hover tbody tr:hover {
            background-color: #dff9e4;
        }

        .is-invalid {
            border-color: #dc3545 !important;
        }

        .text-danger {
            font-size: 0.875rem;
        }
    </style>

    <!-- jQuery Validation -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>

    <script>
        $(document).ready(function () {
            $("#<%= Page.Form.ClientID %>").validate({
                rules: {
                    '<%= txtName.UniqueID %>': { required: true },
                    '<%= txtDuration.UniqueID %>': { required: true, digits: true, min: 1, max: 5 },
                    '<%= txtModality.UniqueID %>': { required: true },
                    '<%= txtDegree.UniqueID %>': { required: true }
                },
                messages: {
                    '<%= txtName.UniqueID %>': "Ingrese el nombre de la carrera",
                    '<%= txtDuration.UniqueID %>': {
                        required: "Ingrese la duración",
                        digits: "Solo números",
                        min: "Debe ser mayor a 0",
                        max: "No puede ser mayor a 5 años"
                    },
                    '<%= txtModality.UniqueID %>': "Ingrese la modalidad",
                    '<%= txtDegree.UniqueID %>': "Ingrese el título que otorga"
                },
                errorClass: "text-danger",
                errorPlacement: function (error, element) { error.insertAfter(element); },
                highlight: function (element) { $(element).addClass("is-invalid"); },
                unhighlight: function (element) { $(element).removeClass("is-invalid"); }
            });
        });
    </script>

</asp:Content>
