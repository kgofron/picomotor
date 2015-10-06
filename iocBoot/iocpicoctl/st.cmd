#!../../bin/linux-x86_64/picoctl

## You may have to change x16actl to something else i.e. picoctl
## everywhere it appears in this file

< envPaths

epicsEnvSet("ENGINEER",  "kgofron x5283")
epicsEnvSet("LOCATION",  "740 IXS RG:B1")
epicsEnvSet("P",         "XF:10IDB-OP")
epicsEnvSet("NP_PORT",   "serial1")
epicsEnvSet("MC",   "MC:33")
epicsEnvSet("CT",   "XF:10IDB-CT")
epicsEnvSet("IOC_PREFIX", "$(CT){IOC-$(MC)}")
epicsEnvSet("MC_PREFIX", "$(CT){$(MC)}")

epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST", "10.10.0.255")

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/picoctl.dbd"
picoctl_registerRecordDeviceDriver pdbbase

# Setup IP port for 8752 
#drvAsynIPPortConfigure("$(NP_PORT)", "pico:23")
drvAsynIPPortConfigure("$(NP_PORT)", "10.10.2.93:23")
asynOctetSetInputEos("$(NP_PORT)",0,">")
asynOctetSetOutputEos("$(NP_PORT)",0,"\r")
asynOctetConnect("$(NP_PORT)", "$(NP_PORT)")

#dbLoadRecords("${EPICS_BASE}/db/asynRecord.db", "P=$(MC_PREFIX),R=pico1:port,PORT=serial1,ADDR=,OMAX=40,IMAX=40")
dbLoadRecords("${EPICS_BASE}/db/asynRecord.db", "P=$(MC_PREFIX),R="Asyn",PORT="$(NP_PORT)",ADDR=,OMAX=40,IMAX=40")

# asyn debug traces
asynSetTraceMask("$(NP_PORT)",-1,0x9)
asynSetTraceIOMask("$(NP_PORT)",-1,0x2)

# New Focus Picomotor Network Controller (model 87xx) (setup parameters:  
#     (1) maximum number of controllers in system 
#     (2) maximum number of drivers per controller (1 - 3)  
#     (3) motor task polling rate (min=1Hz,max=60Hz)  
#var drvPMNC87xxdebug 3
PMNC87xxSetup(1,3,10)

# New Focus Picomotor Network Controller (model 87xx) configuration parameters:  
#     (1) controller# being configured, 
#     (2) asyn port name (string)
PMNC87xxConfig(0, "$(NP_PORT)",0)

## Load record instances
dbLoadTemplate("db/motorNewFocus.substitutions")

## autosave/restore machinery
save_restoreSet_Debug(0)
save_restoreSet_IncompleteSetsOk(1)
save_restoreSet_DatedBackupFiles(1)
#save_restoreSet_status_prefix("ixshrm:")

set_savefile_path("${TOP}/as","/save")
set_requestfile_path("${TOP}/as","/req")

set_pass0_restoreFile("motorNewFocus_positions.sav")
set_pass0_restoreFile("motorNewFocus_settings.sav")
set_pass1_restoreFile("motorNewFocus_settings.sav")
#asInitHooksRegister()

cd ${TOP}/iocBoot/${IOC}
iocInit

## more autosave/restore machinery
#create_monitor_set("motorNewFocus_positions.req", 5 , "P=ixshrm:,M=")
#create_monitor_set("motorNewFocus_settings.req", 15 , "P=ixshrm:,M=")
create_monitor_set("motorNewFocus_positions.req", 5 , "")
create_monitor_set("motorNewFocus_settings.req", 15 , "")

cd ${TOP}
dbl > ./records.dbl
system "cp ./records.dbl /cf-update/$HOSTNAME.$IOCNAME.dbl"
