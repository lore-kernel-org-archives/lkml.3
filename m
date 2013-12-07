Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3LGEs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 23:48:26 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:59184 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab3LGEsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 23:48:25 -0500
From: Gary Rookard <garyrookard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Gary Rookard <garyrookard@gmail.com>
Subject: [PATCH 4/9] Staging: bcm: DDRInit: added spaces around operators.
Date: Fri,  6 Dec 2013 23:48:18 -0500
Message-Id: <1386391698-11641-1-git-send-email-garyrookard@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fourth patch of a series.

Signed-off-by: Gary Alan Rookard <garyrookard@gmail.com>
---
On branch-staging-next
 drivers/staging/bcm/DDRInit.c | 86 +++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index ed4dfe9..cb4dd53 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -7,7 +7,7 @@
 
     //DDR INIT-133Mhz
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  //index for 0x0F007000
-static struct bcm_ddr_setting asT3_DDRSetting133MHz[]= {//      # DPLL Clock Setting
+static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {//      # DPLL Clock Setting
 	{0x0F000800, 0x00007212},
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00000F95},
@@ -65,7 +65,7 @@ static struct bcm_ddr_setting asT3_DDRSetting133MHz[]= {//      # DPLL Clock Set
                                         };
 //80Mhz
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 10  //index for 0x0F007000
-static struct bcm_ddr_setting asT3_DDRSetting80MHz[]= {//   # DPLL Clock Setting
+static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = {//   # DPLL Clock Setting
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07f1ffff},
 	{0x0f000860, 0x00000000},
@@ -117,7 +117,7 @@ static struct bcm_ddr_setting asT3_DDRSetting80MHz[]= {//   # DPLL Clock Setting
                                 };
 //100Mhz
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 13  //index for 0x0F007000
-static struct bcm_ddr_setting asT3_DDRSetting100MHz[]= {//  # DPLL Clock Setting
+static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {//  # DPLL Clock Setting
 	{0x0F000800, 0x00007008},
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F13E3F},
@@ -356,7 +356,7 @@ static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {//      # DPLL Clock S
 
 
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 9  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[]= {//	# DPLL Clock Setting
+static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {//	# DPLL Clock Setting
 	{0x0f000820, 0x03F1365B},
 	{0x0f000810, 0x00002F95},
 	{0x0f000880, 0x000003DD},
@@ -416,7 +416,7 @@ static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[]= {//	# DPLL Clock Settin
 };
 
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 11  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[]= {//	# DPLL Clock Setting
+static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {//	# DPLL Clock Setting
 	{0x0f000810, 0x00002F95},
 	{0x0f000820, 0x03F1369B},
 	{0x0f000840, 0x0fff0000},
@@ -476,7 +476,7 @@ static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[]= {//	# DPLL Clock Settin
 };
 
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 9  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[]= {//	# DPLL Clock Setting
+static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[] = {//	# DPLL Clock Setting
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00002F95},
 	{0x0f000860, 0x00000000},
@@ -536,7 +536,7 @@ static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[]= {//	# DPLL Clock Setting
 ///T3 LP-B (UMA-B)
 
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_160MHZ 7  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[]= {//	# DPLL Clock Setting
+static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {//	# DPLL Clock Setting
 
 	{0x0f000820, 0x03F137DB},
 	{0x0f000810, 0x01842795},
@@ -594,7 +594,7 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[]= {//	# DPLL Clock Setti
 
 
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 7  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[]= {//	# DPLL Clock Setting
+static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {//	# DPLL Clock Setting
 	{0x0f000820, 0x03F1365B},
 	{0x0f000810, 0x00002F95},
 	{0x0f000880, 0x000003DD},
@@ -655,7 +655,7 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[]= {//	# DPLL Clock Setti
 };
 
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 8  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[]= {//	# DPLL Clock Setting
+static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {//	# DPLL Clock Setting
 	{0x0f000810, 0x00002F95},
 	{0x0f000820, 0x03F1369B},
 	{0x0f000840, 0x0fff0000},
@@ -716,7 +716,7 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[]= {//	# DPLL Clock Setti
 };
 
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 7  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[]= {//	# DPLL Clock Setting
+static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[] = {//	# DPLL Clock Setting
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00002F95},
 	{0x0f000860, 0x00000000},
@@ -774,8 +774,8 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[]= {//	# DPLL Clock Settin
 
 int ddr_init(struct bcm_mini_adapter *Adapter)
 {
-	struct bcm_ddr_setting *psDDRSetting=NULL;
-	ULONG RegCount=0;
+	struct bcm_ddr_setting *psDDRSetting = NULL;
+	ULONG RegCount = 0;
 	UINT value = 0;
 	UINT  uiResetValue = 0;
 	UINT uiClockSetting = 0;
@@ -787,18 +787,18 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 	    switch (Adapter->DDRSetting)
 	    {
 	        case DDR_80_MHZ:
-				psDDRSetting=asT3LP_DDRSetting80MHz;
-			    RegCount=(sizeof(asT3LP_DDRSetting80MHz)/
+				psDDRSetting = asT3LP_DDRSetting80MHz;
+			    RegCount = (sizeof(asT3LP_DDRSetting80MHz)/
 			  	sizeof(struct bcm_ddr_setting));
 			    break;
 		    case DDR_100_MHZ:
-				psDDRSetting=asT3LP_DDRSetting100MHz;
-			    RegCount=(sizeof(asT3LP_DDRSetting100MHz)/
+				psDDRSetting = asT3LP_DDRSetting100MHz;
+			    RegCount = (sizeof(asT3LP_DDRSetting100MHz)/
 			  	sizeof(struct bcm_ddr_setting));
 			    break;
 		    case DDR_133_MHZ:
-				psDDRSetting=asT3LP_DDRSetting133MHz;
-			    RegCount=(sizeof(asT3LP_DDRSetting133MHz)/
+				psDDRSetting = asT3LP_DDRSetting133MHz;
+			    RegCount = (sizeof(asT3LP_DDRSetting133MHz)/
 		 	  		sizeof(struct bcm_ddr_setting));
 				if(Adapter->bMipsConfig == MIPS_200_MHZ)
 				{
@@ -818,7 +818,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 	case BCS220_2:
 	case BCS220_2BC:
 	case BCS250_BC:
-	case BCS220_3 :
+	case BCS220_3:
 		/* Set bit 2 and bit 6 to 1 for BBIC 2mA drive
 		 * (please check current value and additionally set these bits)
 		 */
@@ -826,7 +826,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			(Adapter->chip_id !=  BCS220_2BC) &&
 			(Adapter->chip_id != BCS220_3) )
 		{
-				retval= rdmalt(Adapter, (UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
+				retval = rdmalt(Adapter, (UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
 				if(retval < 0) {
 					BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 					return retval;
@@ -845,17 +845,17 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 
 			case DDR_80_MHZ:
 				psDDRSetting = asT3LPB_DDRSetting80MHz;
-		        RegCount=(sizeof(asT3B_DDRSetting80MHz)/
+		        RegCount = (sizeof(asT3B_DDRSetting80MHz)/
 		                  sizeof(struct bcm_ddr_setting));
 			break;
             case DDR_100_MHZ:
-				psDDRSetting=asT3LPB_DDRSetting100MHz;
-		        RegCount=(sizeof(asT3B_DDRSetting100MHz)/
+				psDDRSetting = asT3LPB_DDRSetting100MHz;
+		        RegCount = (sizeof(asT3B_DDRSetting100MHz)/
 		                 sizeof(struct bcm_ddr_setting));
 			break;
             case DDR_133_MHZ:
 				psDDRSetting = asT3LPB_DDRSetting133MHz;
-				RegCount=(sizeof(asT3B_DDRSetting133MHz)/
+				RegCount = (sizeof(asT3B_DDRSetting133MHz)/
 						 sizeof(struct bcm_ddr_setting));
 
 				if(Adapter->bMipsConfig == MIPS_200_MHZ)
@@ -915,12 +915,12 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 	    {
 	        case DDR_80_MHZ:
 				psDDRSetting = asT3B_DDRSetting80MHz;
-		        RegCount=(sizeof(asT3B_DDRSetting80MHz)/
+		        RegCount = (sizeof(asT3B_DDRSetting80MHz)/
 		                  sizeof(struct bcm_ddr_setting));
 		    break;
             case DDR_100_MHZ:
-				psDDRSetting=asT3B_DDRSetting100MHz;
-		        RegCount=(sizeof(asT3B_DDRSetting100MHz)/
+				psDDRSetting = asT3B_DDRSetting100MHz;
+		        RegCount = (sizeof(asT3B_DDRSetting100MHz)/
 		                 sizeof(struct bcm_ddr_setting));
 			break;
             case DDR_133_MHZ:
@@ -930,13 +930,13 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 					memcpy(asT3B_DDRSetting133MHz, asDPLL_266MHZ,
 									 sizeof(asDPLL_266MHZ));
 					psDDRSetting = asT3B_DDRSetting133MHz;
-					RegCount=(sizeof(asT3B_DDRSetting133MHz)/
+					RegCount = (sizeof(asT3B_DDRSetting133MHz)/
 									sizeof(struct bcm_ddr_setting));
 				}
 				else
 				{
 					psDDRSetting = asT3B_DDRSetting133MHz;
-					RegCount=(sizeof(asT3B_DDRSetting133MHz)/
+					RegCount = (sizeof(asT3B_DDRSetting133MHz)/
 									sizeof(struct bcm_ddr_setting));
 					if(Adapter->bMipsConfig == MIPS_200_MHZ)
 					{
@@ -958,7 +958,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		return -EINVAL;
 	}
 
-	value=0;
+	value = 0;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "Register Count is =%lu\n", RegCount);
 	while(RegCount && !retval)
 	{
@@ -984,8 +984,8 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 	{
 
 		mdelay(3);
-		if( (Adapter->chip_id != BCS220_2)&&
-			(Adapter->chip_id != BCS220_2BC)&&
+		if( (Adapter->chip_id != BCS220_2) &&
+			(Adapter->chip_id != BCS220_2BC) &&
 			(Adapter->chip_id != BCS220_3))
 		{
 			/* drive MDDR to half in case of UMA-B:	*/
@@ -1101,8 +1101,8 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 
 int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 {
-	struct bcm_ddr_setting *psDDRSetting=NULL;
-	ULONG RegCount=0;
+	struct bcm_ddr_setting *psDDRSetting = NULL;
+	ULONG RegCount = 0;
 	unsigned long ul_ddr_setting_load_addr = DDR_DUMP_INTERNAL_DEVICE_MEMORY;
 	UINT  value = 0;
 	int retval = STATUS_SUCCESS;
@@ -1141,12 +1141,12 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	case BCS220_2:
 	case BCS220_2BC:
 	case BCS250_BC:
-	case BCS220_3 :
+	case BCS220_3:
 	    switch (Adapter->DDRSetting)
 	    {
 	        case DDR_80_MHZ:
 				psDDRSetting = asT3LPB_DDRSetting80MHz;
-                RegCount=ARRAY_SIZE(asT3LPB_DDRSetting80MHz);
+                RegCount = ARRAY_SIZE(asT3LPB_DDRSetting80MHz);
 				RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
                 psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			break;
@@ -1182,19 +1182,19 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	        case DDR_80_MHZ:
 				psDDRSetting = asT3_DDRSetting80MHz;
                 RegCount = ARRAY_SIZE(asT3_DDRSetting80MHz);
-				RegCount-=T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
+				RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
                 psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			break;
 		    case DDR_100_MHZ:
 				psDDRSetting = asT3_DDRSetting100MHz;
 			    RegCount = ARRAY_SIZE(asT3_DDRSetting100MHz);
-				RegCount-=T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
+				RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
                 psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
 			    break;
 		     case DDR_133_MHZ:
 				psDDRSetting = asT3_DDRSetting133MHz;
 			    RegCount = ARRAY_SIZE(asT3_DDRSetting133MHz);
-				RegCount-=T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
+				RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
 		        psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
 				break;
 			default:
@@ -1231,7 +1231,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 		return -EINVAL;
 	}
 	//total number of Register that has to be dumped
-	value =RegCount  ;
+	value = RegCount  ;
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 	if(retval)
 	{
@@ -1241,7 +1241,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	}
 	ul_ddr_setting_load_addr += sizeof(ULONG);
 	/*signature */
-	value =(0x1d1e0dd0);
+	value = (0x1d1e0dd0);
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 	if(retval)
 	{
@@ -1250,7 +1250,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	}
 
 	ul_ddr_setting_load_addr += sizeof(ULONG);
-	RegCount*=(sizeof(struct bcm_ddr_setting)/sizeof(ULONG));
+	RegCount *= (sizeof(struct bcm_ddr_setting)/sizeof(ULONG));
 
 	while(RegCount && !retval)
 	{
@@ -1261,7 +1261,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 		{
 			if(bOverrideSelfRefresh && (psDDRSetting->ulRegAddress == 0x0F007018))
 			{
-				value = (psDDRSetting->ulRegValue |(1<<8));
+				value = (psDDRSetting->ulRegValue | (1<<8));
 				if(STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr,
 						&value, sizeof(value))){
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
-- 
1.8.4

