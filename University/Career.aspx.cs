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
    public partial class Career : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MySqlConnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFaculty();
                LoadCareer();
                btnUpdate.Enabled = false;
            }
        }

        // Cargar facultades en el DropDownList
        void LoadFaculty()
        {
            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand("SELECT faculty_id, name_fac FROM faculty", con);
                con.Open();
                ddlFaculty.DataSource = cmd.ExecuteReader();
                ddlFaculty.DataTextField = "name_fac";
                ddlFaculty.DataValueField = "faculty_id";
                ddlFaculty.DataBind();
                con.Close();
            }
            ddlFaculty.Items.Insert(0, new ListItem("-- Seleccione una facultad --", ""));
        }

        // Listar carreras
        void LoadCareer()
        {
            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand("sp_list_career", con);
                cmd.CommandType = CommandType.StoredProcedure;
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvCareer.DataSource = dt;
                gvCareer.DataBind();
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            if (string.IsNullOrEmpty(ddlFaculty.SelectedValue)) return;

            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand("sp_insert_career", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("p_faculty_id", Convert.ToInt32(ddlFaculty.SelectedValue));
                cmd.Parameters.AddWithValue("p_name", txtName.Text);
                cmd.Parameters.AddWithValue("p_duration", Convert.ToInt32(txtDuration.Text));
                cmd.Parameters.AddWithValue("p_modality", txtModality.Text);
                cmd.Parameters.AddWithValue("p_degree_title", txtDegree.Text);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            ClearForm();
            LoadCareer();
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (ViewState["career_id"] == null) return;

            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand("sp_update_career", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("p_id", Convert.ToInt32(ViewState["career_id"]));
                cmd.Parameters.AddWithValue("p_faculty_id", Convert.ToInt32(ddlFaculty.SelectedValue));
                cmd.Parameters.AddWithValue("p_name", txtName.Text);
                cmd.Parameters.AddWithValue("p_duration", Convert.ToInt32(txtDuration.Text));
                cmd.Parameters.AddWithValue("p_modality", txtModality.Text);
                cmd.Parameters.AddWithValue("p_degree_title", txtDegree.Text);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            ClearForm();
            LoadCareer();
        }

        protected void gvCareer_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Editar")
            {
                using (MySqlConnection con = new MySqlConnection(connectionString))
                {
                    MySqlCommand cmd = new MySqlCommand("SELECT * FROM career WHERE career_id=@id", con);
                    cmd.Parameters.AddWithValue("@id", id);
                    con.Open();
                    MySqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        ViewState["career_id"] = id;
                        ddlFaculty.SelectedValue = reader["faculty_id"].ToString();
                        txtName.Text = reader["name"].ToString();
                        txtDuration.Text = reader["duration"].ToString();
                        txtModality.Text = reader["modality"].ToString();
                        txtDegree.Text = reader["degree_title"].ToString();

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
                        // Verificar si la carrera tiene profesores asociados
                        MySqlCommand checkCmd = new MySqlCommand("SELECT COUNT(*) FROM professor WHERE career_id=@id", con);
                        checkCmd.Parameters.AddWithValue("@id", id);

                        con.Open();
                        int count = Convert.ToInt32(checkCmd.ExecuteScalar());

                        if (count > 0)
                        {
                            // No se puede eliminar
                            ClientScript.RegisterStartupScript(this.GetType(), "alert",
                                "alert('No se puede eliminar esta carrera porque tiene profesores asociados.');", true);
                        }
                        else
                        {
                            MySqlCommand cmd = new MySqlCommand("sp_delete_career", con);
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("p_id", id);
                            cmd.ExecuteNonQuery();

                            ClearForm();
                            LoadCareer();
                        }

                        con.Close();
                    }
                }
                catch (MySqlException ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert",
                        $"alert('Error al eliminar: {ex.Message}');", true);
                }
            }
        }

        private void ClearForm()
        {
            ddlFaculty.SelectedIndex = 0;
            txtName.Text = "";
            txtDuration.Text = "";
            txtModality.Text = "";
            txtDegree.Text = "";
            ViewState["career_id"] = null;

            btnAdd.Enabled = true;
            btnUpdate.Enabled = false;
        }
    }
}