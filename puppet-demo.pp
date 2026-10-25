file { '/tmp/automation-classroom':
  ensure => directory,
  mode   => '0755',
}

$page = @("HTML"/L)
  <!doctype html>
  <html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Classroom Service Dashboard</title>
    <style>
      * { box-sizing: border-box; }
      body { margin: 0; min-height: 100vh; display: grid; place-items: center;
        background: #fff3e8; color: #46301f; font: 18px system-ui, sans-serif; }
      main { width: min(90vw, 640px); padding: 42px; border-radius: 24px;
        background: white; box-shadow: 0 20px 60px #673a1822; }
      .eyebrow { color: #bf5d1e; font-size: 14px; font-weight: 800;
        letter-spacing: .15em; text-transform: uppercase; }
      h1 { margin: 12px 0; font-size: clamp(32px, 6vw, 50px); line-height: 1.05; }
      p { line-height: 1.5; }
      .status { display: inline-flex; align-items: center; gap: 10px;
        margin: 18px 0 26px; padding: 11px 17px; border-radius: 999px;
        background: #e7f8ed; color: #146333; font-weight: 750; }
      .dot { width: 10px; height: 10px; border-radius: 50%; background: #24ad58; }
      footer { padding-top: 22px; border-top: 1px solid #f1e7de; color: #806d5d; }
      strong { color: #bf5d1e; }
    </style>
  </head>
  <body>
    <main>
      <div class="eyebrow">Automation lab</div>
      <h1>Classroom service is ready.</h1>
      <div class="status"><span class="dot"></span>Healthy</div>
      <p>This page was deployed by <strong>Puppet</strong>.</p>
      <footer>Change this file manually, run Puppet again, and watch it return.</footer>
      <p><a href="/terraform.html">Open the Terraform page</a></p>
    </main>
  </body>
  </html>
  | HTML

file { '/tmp/automation-classroom/index.html':
  ensure  => file,
  mode    => '0644',
  content => $page,
  require => File['/tmp/automation-classroom'],
}
