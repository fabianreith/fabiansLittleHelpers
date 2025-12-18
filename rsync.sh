# Example rsync from remote server to local
# Replace placeholders with your actual values
rsync -avh --update --exclude=*.torch -e 'ssh -i ~/.ssh/id_server' <username>@<server.example.com>:/path/to/remote/data .
