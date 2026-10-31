# Classroom automation demo

This activity is designed for students to explore how configuration management tools keep a system in a known and consistent state. You will use Ansible, Puppet, and Terraform to manage the same web page and observe how each tool responds when the file changes.

![Diagram of how Ansible, Puppet, and Terraform manage pages served by Python](images/automation-demo.png)

## Learning goals

By the end of this exercise, you should be able to:

- explain what "desired state" means in automation
- see how tools detect drift from the intended configuration
- understand idempotence, where rerunning a tool makes no further change
- compare how Ansible, Puppet, and Terraform manage files differently

## Setup on Debian in WSL 2

Start by opening Debian from Windows PowerShell:

```powershell
wsl -d Debian
```

If Debian is not listed, run:

```powershell
wsl --list --quiet
wsl --install -d Debian
```

Use the name shown in the output and run:

```powershell
wsl -d <your-distro-name>
```

Once you are in the Debian terminal, install the required software:

```bash
sudo apt update
sudo apt install -y ansible puppet-agent python3
```

Now open this project folder in your Debian shell. For example, if your project is stored at `C:\Users\Administrator\Documents\ChatGPT\wsl-demo`, it will appear in WSL at:

```bash
/mnt/c/Users/Administrator/Documents/ChatGPT/wsl-demo
```

## Step 1: Run the Ansible demo

Open terminal 1 in the project folder and deploy the first version of the page:

```bash
sudo ansible-playbook -i localhost, -c local ansible-demo.yml
```

In terminal 2, start the web server:

```bash
python3 -m http.server 8000 --directory /tmp/automation-classroom
```

Open <http://localhost:8000> in your Windows browser. Refresh the page after each step.

If you see the message that the port is already in use, then port 8000 is already occupied. Another copy of the demo server may already be running, so try <http://localhost:8000> first. If needed, start a second server on a different port:

```bash
python3 -m http.server 8001 --directory /tmp/automation-classroom
```

Then open <http://localhost:8001>.

To check what is listening on port 8000, run:

```bash
sudo ss -ltnp '( sport = :8000 )'
```

Run the Ansible command again. The output should show `changed=0`.

This demonstrates idempotence: the page already matches the desired state, so Ansible makes no further change.

## Step 2: Create drift and restore the page

Now manually change the managed file:

```bash
echo 'Someone changed the site!' | sudo tee /tmp/automation-classroom/index.html
```

Refresh the browser, then run Ansible again:

```bash
sudo ansible-playbook -i localhost, -c local ansible-demo.yml
```

The blue page returns. This shows that Ansible corrects drift by restoring the file to its desired state.

## Step 3: Apply the Puppet demo

Next, apply the Puppet manifest:

```bash
sudo puppet apply puppet-demo.pp
```

Refresh the browser to see the orange page.

Run Puppet again to confirm that it makes no further change once the page matches the desired state.

Then make a manual edit again and rerun Puppet:

```bash
echo 'Someone changed the site!' | sudo tee /tmp/automation-classroom/index.html
sudo puppet apply puppet-demo.pp
```

The page is restored. This reinforces the idea that Puppet also enforces a desired state.

## Step 4: Compare Ansible and Puppet

Run Ansible one more time:

```bash
sudo ansible-playbook -i localhost, -c local ansible-demo.yml
```

The page changes back to blue because the two examples define different desired content for the same file.

This is an important learning point: both tools are enforcing their own definition of the correct state, and the file ends up matching whichever automation runs last.

## What to look for

- Desired state: each tool defines what the website should look like.
- Idempotence: running the tool again should not cause a change once the configuration matches.
- Drift correction: a manual change is replaced the next time the automation runs.
- Typical deployment: Ansible is commonly used from a controller that connects to target machines over SSH. Puppet commonly uses an agent on each managed machine. This demo keeps both tools local to avoid extra setup.

This exercise uses Python's built-in web server to display the result. No extra web server configuration or Puppet server is required.

## Optional Terraform extension

This extension uses the same Python web server. Terraform creates a purple page at `/terraform.html`, while Ansible and Puppet continue to manage `/index.html`.

### Install Terraform

Install Terraform in your Debian WSL shell using HashiCorp's Debian package repository:

```bash
sudo apt update
sudo apt install -y gnupg wget lsb-release
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install -y terraform
terraform version
```

### Run the Terraform demo

Run the Ansible playbook once and then give your Debian user permission to add a second file to the demo directory:

```bash
sudo ansible-playbook -i localhost, -c local ansible-demo.yml
sudo chown "$USER" /tmp/automation-classroom
```

Keep the Python server running. From this project's folder in Debian, run:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Type `yes` when Terraform asks for confirmation.

Open <http://localhost:8000/terraform.html> in your browser, or use port 8001 if that is where your Python server is running. The main page also links to the Terraform page.

Run `terraform plan` again to confirm there are no further changes. Then try changing the class name:

```bash
terraform apply -var='class_name=Year 10 IT'
```

Refresh the Terraform page to see the new heading.

You can also replace `/tmp/automation-classroom/terraform.html` manually and rerun the same `terraform apply -var=...` command to show that Terraform restores the file to its configured state.

At the end of the exercise, run:

```bash
terraform destroy
```

This removes only the Terraform-managed page. The Ansible and Puppet-managed page remains.

## Summary

This exercise demonstrates that automation tools do more than just run commands. They define and maintain a desired state, detect drift, and restore the system to the correct configuration.

By comparing Ansible, Puppet, and Terraform, you can start to see how infrastructure automation helps teams manage environments consistently and predictably.
