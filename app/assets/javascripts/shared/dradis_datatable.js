class DradisDatatable {
  constructor(selector) {
    this.$table = $(selector);
    this.dataTable = null;
    this.init();
  }

  init() {
    var dataTable = this.$table.DataTable({
      autoWidth: false,
      dom: "<'row'<'col-lg-6'><'col-lg-6'f>>" +
      "<'row'<'col-lg-12'tr>>" +
      "<'dataTables_footer_content'lip>",
      initComplete: function (settings) {
        settings.oInstance.wrap("<div class='table-wrapper'></div>");
      },
      pageLength: 25
    });

    // Assign the instantiated DataTable as a DradisDatatable property
    this.dataTable = dataTable;
    this.behaviors();
  }

  behaviors() {
    var that = this;

    document.addEventListener('turbolinks:before-cache', function() {
      that.dataTable.destroy();
    });
  }
}
