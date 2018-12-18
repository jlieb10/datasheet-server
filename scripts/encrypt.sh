# saturates ENCRYPT env variables
source .env 
export ENCRYPT

# confirm that user wants to use encryption feature
if [ "$ENCRYPT" = false ]; then
	echo "============================================================================================"
	echo "ENCRYPT flag set to false, skipping this step."
	echo "============================================================================================"
	return 0
fi

echo ""
echo "If you do not have access to push to the forensic-architecture repository,"
echo "please update your git remote configuration"
echo ""
echo "Encrypting .env file for Travis..."

# confirm travis is installed
if [ ! hash travis 2>/dev/null ]; then
	echo "============================================================================================"
	echo "ERROR: Travis CLI is not installed on your local. Please install from:"
	echo "\thttps://github.com/travis-ci/travis.rb"
	echo "After installing, make sure that you login with:"
	echo "\ttravis login --pro"
	echo "============================================================================================"
	return 0
fi

# confirm there is a .env file to encrypt
if [ ! -f .env ]; then
	echo "============================================================================================"
	echo "ERROR: You must create a .env file and add your credentials. See .env.example for an example"
	echo "============================================================================================"
	return 0
fi

# regex to match and delete 'before_install' and everything after it
# necessary to delete these lines to get Travis to build for multiple accounts
echo ""
echo "Creating new .travis.yml configuration"

sed -i.old '/^before_install.*/,$ d' .travis.yml

travis encrypt-file .env --add --force --org
git add .env.enc
git add .travis.yml
echo ""
echo ".env.enc created and added to commit"