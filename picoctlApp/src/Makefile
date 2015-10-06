TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = picoctl
# picoctl.dbd will be created and installed
DBD += picoctl.dbd

# picoctl.dbd will be made up from these files:
picoctl_DBD += base.dbd

# Include dbd files from all support applications:
picoctl_DBD += asyn.dbd
picoctl_DBD += drvAsynSerialPort.dbd
picoctl_DBD += drvAsynIPPort.dbd
picoctl_DBD += motorRecord.dbd
picoctl_DBD += devNewFocus.dbd
picoctl_DBD += motorSupport.dbd
picoctl_DBD += asSupport.dbd
picoctl_DBD += transformRecord.dbd
picoctl_DBD += system.dbd

# Add all the support libraries needed by this IOC
picoctl_LIBS += NewFocus motor autosave calc sscan asyn

# picoctl_registerRecordDeviceDriver.cpp derives from picoctl.dbd
picoctl_SRCS += picoctl_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
picoctl_SRCS_DEFAULT += picoctlMain.cpp
picoctl_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#picoctl_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
picoctl_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

