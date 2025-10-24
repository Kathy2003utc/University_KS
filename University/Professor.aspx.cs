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
    public partial class Professor : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MySqlConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCareer();     // Cargar las carreras en el DropDownList
                LoadProfessor();  // Cargar los profesores en el GridView
                btnUpdate.Enabled = false; // Inicialmente solo agregar
            }
        }

        // Cargar carreras en el DropDownList
        void LoadCareer()
        {
            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand("SELECT career_id, name FROM career ORDER BY name", con);
                con.Open();
                MySqlDataReader reader = cmd.ExecuteReader();
                ddlCareer.DataSource = reader;
                ddlCareer.DataValueField = "career_id";
                ddlCareer.DataTextField = "name";
                ddlCareer.DataBind();
                ddlCareer.Items.Insert(0, new ListItem("--Seleccione una carrera--", "0"));
                con.Close();
            }
        }

        // Cargar lista de profesores
        void LoadProfessor()
        {
            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand("sp_list_professor", con);
                cmd.CommandType = CommandType.StoredProcedure;
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvProfessor.DataSource = dt;
                gvProfessor.DataBind();
            }
        }

        // Agregar profesor
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            if (ddlCareer.SelectedValue == "0") { return; }

            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand("sp_insert_professor", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("p_career_id", Convert.ToInt32(ddlCareer.SelectedValue));
                cmd.Parameters.AddWithValue("p_first_name", txtFirstName.Text);
                cmd.Parameters.AddWithValue("p_last_name", txtLastName.Text);
                cmd.Parameters.AddWithValue("p_email", txtEmail.Text);
                cmd.Parameters.AddWithValue("p_phone", txtPhone.Text);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            ClearForm();
            LoadProfessor();
        }

        // Actualizar profesor
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (ViewState["professor_id"] == null) return;
            if (ddlCareer.SelectedValue == "0") { return; }

            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand("sp_update_professor", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("p_id", Convert.ToInt32(ViewState["professor_id"]));
                cmd.Parameters.AddWithValue("p_career_id", Convert.ToInt32(ddlCareer.SelectedValue));
                cmd.Parameters.AddWithValue("p_first_name", txtFirstName.Text);
                cmd.Parameters.AddWithValue("p_last_name", txtLastName.Text);
                cmd.Parameters.AddWithValue("p_email", txtEmail.Text);
                cmd.Parameters.AddWithValue("p_phone", txtPhone.Text);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            ClearForm();
            LoadProfessor();
        }

        // Eventos del GridView (Editar / Eliminar)
        protected void gvProfessor_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Editar")
            {
                using (MySqlConnection con = new MySqlConnection(connectionString))
                {
                    MySqlCommand cmd = new MySqlCommand("SELECT * FROM professor WHERE professor_id=@id", con);
                    cmd.Parameters.AddWithValue("@id", id);

                    con.Open();
                    MySqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        ViewState["professor_id"] = id;
                        txtFirstName.Text = reader["first_name"].ToString();
                        txtLastName.Text = reader["last_name"].ToString();
                        txtEmail.Text = reader["email"].ToString();
                        txtPhone.Text = reader["phone"].ToString();
                        ddlCareer.SelectedValue = reader["career_id"].ToString();

                        btnAdd.Enabled = false;
                        btnUpdate.Enabled = true;
                    }
                    con.Close();
                }
            }
            else if (e.CommandName == "Eliminar")
            {
                try
                {
                    using (MySqlConnection con = new MySqlConnection(connectionString))
                    {
                        // Aquí puedes agregar validación de integridad si se crean relaciones futuras
                        MySqlCommand cmd = new MySqlCommand("sp_delete_professor", con);
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("p_id", id);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();

                        ClearForm();
                        LoadProfessor();
                    }
                }
                catch (MySqlException ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert",
                        $"alert('Error al eliminar: {ex.Message}');", true);
                }
            }
        }

        // Limpiar formulario
        private void ClearForm()
        {
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
            ddlCareer.SelectedValue = "0";
            ViewState["professor_id"] = null;

            btnAdd.Enabled = true;
            btnUpdate.Enabled = false;
        }
    }
}