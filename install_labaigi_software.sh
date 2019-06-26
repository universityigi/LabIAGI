PACKAGES="libeigen3-dev
 libsuitesparse-dev \
 ninja-build \
 libncurses5-dev \
 libwebsockets-dev \
 libreadline-dev \
 libreadline6-dev \
 qtdeclarative5-dev \
 qt5-qmake \
 libqglviewer-dev \
 libudev-dev \
 libgtest-dev \
 freeglut3-dev \
 arduino \
 arduino-mk\
 python-catkin-tools\
 git\
 flex\
 libxml2\
 libxml2-dev\
 libxml++2.6-dev"

sudo apt install ${PACKAGES} -y

mkdir ~/sources
mkdir ~/workspaces

# SRRG software
cd  ~/sources
mkdir srrg
cd srrg
git clone https://gitlab.com/srrg-software/srrg2_orazio
git clone https://gitlab.com/srrg-software/srrg_core
git clone https://gitlab.com/srrg-software/srrg_core_ros
git clone https://gitlab.com/srrg-software/srrg_cmake_modules
git clone https://gitlab.com/srrg-software/srrg_joystick_teleop
cd ..
git clone https://bitbucket.org/ggrisetti/thin_navigation
git clone https://bitbucket.org/ggrisetti/thin_drivers

# ros packages

sudo apt install ros-kinetic-move-base -y

# PNP

mkdir ~/sources/external
cd  ~/sources/external
git clone https://github.com/iocchi/PetriNetPlans
cd PetriNetPlans
PNP_PATH=$(pwd)
cd PNP
mkdir build
cd build
cmake ..
make
mkdir ${PNP_PATH}/PNP/lib
cd ${PNP_PATH}/PNP/lib 
ln -s ../build/src/libpnp.so .

echo "export PNP_INCLUDE=$PNP_PATH/PNP/include" >> ~/.bashrc
echo "export PNP_LIB=$PNP_PATH/PNP/lib" >> ~/.bashrc
source ~/.bashrc

cd ${PNP_PATH}/PNPgen
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig

# create workspace labaigi

mkdir -p ~/workspaces/labaigi_ws/src
cd ~/workspaces/labaigi_ws/src

# sym link

ln -s $PNP_PATH/PNPros/ROS_bridge/pnp_ros .
ln -s $PNP_PATH/PNPros/ROS_bridge/pnp_rosplan .
ln -s $PNP_PATH/PNPros/ROS_bridge/pnp_msgs .
ln -s $PNP_PATH/PNPros/example/rp_action .
ln -s $PNP_PATH/PNPros/example/rp_action_msgs .

ln -s ~/sources/srrg/* .
ln -s ~/sources/thin_navigation .
ln -s ~/sources/thin_drivers/thin_hokuyo .

cd ..
catkin build
