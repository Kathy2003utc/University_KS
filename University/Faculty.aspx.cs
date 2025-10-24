using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace University
{
    public partial class Faculty : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MySqlConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFaculty();
                btnUpdate.Enabled = false; // Inicialmente solo agregar
            }

        }

        // Cargar lista de facultades
        void LoadFaculty()
        {
            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand("sp_list_faculty", con);
                cmd.CommandType = CommandType.StoredProcedure;

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvFaculty.DataSource = dt;
                gvFaculty.DataBind();
            }
        }

        // Agregar una nueva facultad
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand("sp_insert_faculty", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("p_name_fac", txtName.Text);
                cmd.Parameters.AddWithValue("p_acronym_fac", txtAcronym.Text);
                cmd.Parameters.AddWithValue("p_dean_name_fac", txtDean.Text);
                cmd.Parameters.AddWithValue("p_phone_fac", txtPhone.Text);
                cmd.Parameters.AddWithValue("p_email_fac", txtEmail.Text);
                cmd.Parameters.AddWithValue("p_logo_fac", txtLogo.Text);
                cmd.Parameters.AddWithValue("p_year_foundation_fac", Convert.ToInt32(txtYearFoundation.Text));

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            ClearForm();
            LoadFaculty();
        }

        // Actualizar una facultad existente
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            if (ViewState["faculty_id"] == null) return;

            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand("sp_update_faculty", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("p_id_fac", Convert.ToInt32(ViewState["faculty_id"]));
                cmd.Parameters.AddWithValue("p_name_fac", txtName.Text);
                cmd.Parameters.AddWithValue("p_acronym_fac", txtAcronym.Text);
                cmd.Parameters.AddWithValue("p_dean_name_fac", txtDean.Text);
                cmd.Parameters.AddWithValue("p_phone_fac", txtPhone.Text);
                cmd.Parameters.AddWithValue("p_email_fac", txtEmail.Text);
                cmd.Parameters.AddWithValue("p_logo_fac", txtLogo.Text);
                cmd.Parameters.AddWithValue("p_year_foundation_fac", Convert.ToInt32(txtYearFoundation.Text));

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            ClearForm();
            LoadFaculty();
        }

        // Comandos del GridView (Actualizar/Eliminar)
        protected void gvFaculty_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ActualizarFila")
            {
                using (MySqlConnection con = new MySqlConnection(connectionString))
                {
                    MySqlCommand cmd = new MySqlCommand("SELECT * FROM faculty WHERE faculty_id=@id", con);
                    cmd.Parameters.AddWithValue("@id", id);

                    con.Open();
                    MySqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        ViewState["faculty_id"] = id;
                        txtName.Text = reader["name_fac"].ToString();
                        txtAcronym.Text = reader["acronym_fac"].ToString();
                        txtDean.Text = reader["dean_name_fac"].ToString();
                        txtPhone.Text = reader["phone_fac"].ToString();
                        txtEmail.Text = reader["email_fac"].ToString();
                        txtLogo.Text = reader["logo_fac"].ToString();
                        txtYearFoundation.Text = reader["year_foundation_fac"].ToString();

                        // Habilitar botón Actualizar y deshabilitar Agregar
                        btnAdd.Enabled = false;
                        btnUpdate.Enabled = true;

                        // Ejecutar script en cliente para reflejar el cambio
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "enableUpdate", "$('#" + btnUpdate.ClientID + "').prop('disabled', false); $('#" + btnAdd.ClientID + "').prop('disabled', true);", true);
                    }
                    con.Close();
                }
            }

            else if (e.CommandName == "EliminarFila")
            {
                using (MySqlConnection con = new MySqlConnection(connectionString))
                {
                    MySqlCommand cmd = new MySqlCommand("sp_delete_faculty", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("p_id_fac", id);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }

                ClearForm();
                LoadFaculty();
            }
        }

        // Limpiar campos del formulario
        private void ClearForm()
        {
            txtName.Text = "";
            txtAcronym.Text = "";
            txtDean.Text = "";
            txtPhone.Text = "";
            txtEmail.Text = "";
            txtLogo.Text = "";
            txtYearFoundation.Text = "";
            ViewState["faculty_id"] = null;

            // Restaurar estado de botones
            btnAdd.Enabled = true;
            btnUpdate.Enabled = false;
        }

    }
}