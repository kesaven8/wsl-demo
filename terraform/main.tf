terraform {
  required_version = ">= 1.1.5"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.9"
    }
  }
}

variable "class_name" {
  description = "Class name shown on the Terraform page"
  type        = string
  default     = "DevOps Class"
}

resource "local_file" "classroom_page" {
  filename        = "/tmp/automation-classroom/terraform.html"
  file_permission = "0644"

  content = <<-HTML
    <!doctype html>
    <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Terraform Classroom Page</title>
      <style>
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; display: grid; place-items: center;
          background: #f0eaff; color: #2f244b; font: 18px system-ui, sans-serif; }
        main { width: min(90vw, 640px); padding: 42px; border-radius: 24px;
          background: white; box-shadow: 0 20px 60px #34216122; }
        .eyebrow { color: #7146ca; font-size: 14px; font-weight: 800;
          letter-spacing: .15em; text-transform: uppercase; }
        h1 { margin: 12px 0; font-size: clamp(32px, 6vw, 50px); line-height: 1.05; }
        p { line-height: 1.5; }
        strong { color: #7146ca; }
        footer { padding-top: 22px; border-top: 1px solid #e9e3f5; color: #746b85; }
        a { color: #7146ca; }
      </style>
    </head>
    <body>
      <main>
        <div class="eyebrow">Automation lab</div>
        <h1>Hello, ${var.class_name}!</h1>
        <p>This page is managed by <strong>Terraform</strong>.</p>
        <footer>Change the class name, run Terraform again, and refresh the browser.</footer>
        <p><a href="/">Back to the main dashboard</a></p>
      </main>
    </body>
    </html>
  HTML
}

