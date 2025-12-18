# Example rsync from local to remote server
# Replace placeholders with your actual values
rsync -avh --update --exclude=*.torch -e 'ssh -i ~/.ssh/id_server' local_folder <username>@<server.example.com>:/path/to/remote/destination/
