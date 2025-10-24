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
                    <!-- Campos -->
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

                <!-- Botones -->
                <div class="text-center mt-4">
                    <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-success me-2 px-4" Text="Agregar" OnClick="btnAdd_Click" />
                    <asp:Button ID="btnUpdate" runat="server" CssClass="btn btn-warning px-4" Text="Actualizar" OnClick="btnUpdate_Click" Enabled="false" />
                </div>

                <hr class="my-4" />

                <!-- Grid -->
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
    </form>
</body>
</html>
