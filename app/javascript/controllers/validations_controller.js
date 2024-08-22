import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form"];

  validateJob(event) {
    console.log("validateJob triggered");
    console.log("Button clicked:", event.submitter.name);

    const submitter = event.submitter.name;
    const form = this.formTarget;

    if (submitter === "publish") {
      $(form).validate({
        ignore: [],
        rules: {
          "job[title]": {
            required: true,
          },
          "job[description]": {
            required: true,
          },
          "job[employment_type_id]": {
            required: true,
          },
          "job[industry_id]": {
            required: true,
          },
        },
        messages: {
          "job[title]": "Please enter a job title",
          "job[description]": "Please enter a job description",
          "job[employment_type_id]": "Please select an employment type",
          "job[industry_id]": "Please select an industry",
        },
        submitHandler: function (form) {
          form.submit();
        },
      });

      if (!$(form).valid()) {
        event.preventDefault();
        console.log("Validation failed");
      } else {
        console.log("Validation succeeded");
      }
    }
  }
}
