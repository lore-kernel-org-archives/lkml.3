Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbaGXMue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:50:34 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37395 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778AbaGXMud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:50:33 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:bcm:DDRinit.c:coding style:line over 80 char
Date: Thu, 24 Jul 2014 18:19:46 +0530
Message-Id: <1406206186-4661-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/bcm/DDRInit.c | 59 ++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 4564f40..4226c93 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -7,7 +7,8 @@
 
 /* DDR INIT-133Mhz */
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {
+	/* DPLL Clock Setting */
 	{0x0F000800, 0x00007212},
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00000F95},
@@ -65,7 +66,8 @@ static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {  /* DPLL Clock Setting
 };
 /* 80Mhz */
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 10  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = {
+      /* DPLL Clock Setting */
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07f1ffff},
 	{0x0f000860, 0x00000000},
@@ -117,7 +119,8 @@ static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = {  /* DPLL Clock Setting
 };
 /* 100Mhz */
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 13  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {
+      /* DPLL Clock Setting */
 	{0x0F000800, 0x00007008},
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F13E3F},
@@ -189,7 +192,8 @@ static struct bcm_ddr_setting asDPLL_266MHZ[] = {
 };
 
 #define T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 11  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {
+      /* DPLL Clock Setting */
 	{0x0f000810, 0x00000F95},
 	{0x0f000810, 0x00000F95},
 	{0x0f000810, 0x00000F95},
@@ -247,7 +251,8 @@ static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {  /* DPLL Clock Settin
 	};
 
 #define T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 9  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {
+      /* DPLL Clock Setting */
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000840, 0x0FFF1F00},
@@ -301,7 +306,8 @@ static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {  /* DPLL Clock Setting
 
 /* 100Mhz */
 #define T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 9  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {
+      /* DPLL Clock Setting */
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F1369B},
 	{0x0f000840, 0x0FFF0800},
@@ -356,7 +362,8 @@ static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {  /* DPLL Clock Settin
 
 
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 9  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {
+      /* DPLL Clock Setting */
 	{0x0f000820, 0x03F1365B},
 	{0x0f000810, 0x00002F95},
 	{0x0f000880, 0x000003DD},
@@ -416,7 +423,8 @@ static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {  /* DPLL Clock Setti
 };
 
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 11  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {
+      /* DPLL Clock Setting */
 	{0x0f000810, 0x00002F95},
 	{0x0f000820, 0x03F1369B},
 	{0x0f000840, 0x0fff0000},
@@ -476,7 +484,8 @@ static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {  /* DPLL Clock Setti
 };
 
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 9  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[] = {
+      /* DPLL Clock Setting */
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00002F95},
 	{0x0f000860, 0x00000000},
@@ -536,7 +545,8 @@ static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[] = {  /* DPLL Clock Settin
 /* T3 LP-B (UMA-B) */
 
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_160MHZ 7  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {
+      /* DPLL Clock Setting */
 	{0x0f000820, 0x03F137DB},
 	{0x0f000810, 0x01842795},
 	{0x0f000860, 0x00000000},
@@ -544,7 +554,8 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {  /* DPLL Clock Sett
 	{0x0f000840, 0x0FFF0400},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
-	{0x0f003050, 0x00000021},  /* this is flash/eeprom clock divisor which set the flash clock to 20 MHz */
+	{0x0f003050, 0x00000021},  /* this is flash/eeprom clock divisor which
+				    * set the flash clock to 20 MHz */
 	{0x0F00a084, 0x1Cffffff},  /* Now dump from her in internal memory */
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
@@ -593,7 +604,8 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {  /* DPLL Clock Sett
 
 
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 7  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {
+      /* DPLL Clock Setting */
 	{0x0f000820, 0x03F1365B},
 	{0x0f000810, 0x00002F95},
 	{0x0f000880, 0x000003DD},
@@ -602,7 +614,8 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {  /* DPLL Clock Sett
 	{0x0f000860, 0x00000000},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
-	{0x0f003050, 0x00000021},  /* flash/eeprom clock divisor which set the flash clock to 20 MHz */
+	{0x0f003050, 0x00000021},  /* flash/eeprom clock divisor which
+				    * set the flash clock to 20 MHz */
 	{0x0F00a084, 0x1Cffffff},  /* dump from here in internal memory */
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
@@ -654,7 +667,8 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {  /* DPLL Clock Sett
 };
 
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 8  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {
+      /* DPLL Clock Setting */
 	{0x0f000810, 0x00002F95},
 	{0x0f000820, 0x03F1369B},
 	{0x0f000840, 0x0fff0000},
@@ -664,7 +678,8 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {  /* DPLL Clock Sett
 	{0x0f000840, 0x0FFF0000},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
-	{0x0f003050, 0x00000021},  /* flash/eeprom clock divisor which set the flash clock to 20 MHz */
+	{0x0f003050, 0x00000021},  /* flash/eeprom clock divisor which
+				    * set the flash clock to 20 MHz */
 	{0x0F00a084, 0x1Cffffff},  /* dump from here in internal memory */
 	{0x0F00a080, 0x1C000000},
 	/* Memcontroller Default values */
@@ -715,7 +730,8 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {  /* DPLL Clock Sett
 };
 
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 7  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[] = {  /* DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[] = {
+      /* DPLL Clock Setting */
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00002F95},
 	{0x0f000860, 0x00000000},
@@ -723,7 +739,8 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[] = {  /* DPLL Clock Setti
 	{0x0f000840, 0x0FFF1F00},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
-	{0x0f003050, 0x00000021},  /* flash/eeprom clock divisor which set the flash clock to 20 MHz */
+	{0x0f003050, 0x00000021},  /* flash/eeprom clock divisor
+				    * which set the flash clock to 20 MHz */
 	{0x0F00a084, 0x1Cffffff},  /* dump from here in internal memory */
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
@@ -914,7 +931,8 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			break;
 		case DDR_133_MHZ:
 
-			if (Adapter->bDPLLConfig == PLL_266_MHZ) {  /* 266Mhz PLL selected. */
+			/* 266Mhz PLL selected. */
+			if (Adapter->bDPLLConfig == PLL_266_MHZ) {
 				memcpy(asT3B_DDRSetting133MHz, asDPLL_266MHZ,
 				       sizeof(asDPLL_266MHZ));
 				psDDRSetting = asT3B_DDRSetting133MHz;
@@ -1018,8 +1036,9 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		/* DC/DC standby change...
 		 * This is to be done only for Hybrid PMU mode.
 		 * with the current h/w there is no way to detect this.
-		 * and since we dont have internal PMU lets do it under UMA-B chip id.
-		 * we will change this when we will have internal PMU.
+		 * and since we dont have internal PMU lets do it under
+		 * UMA-B chip id. we will change this when we will have
+		 * internal PMU.
 		 */
 		if (Adapter->PmuMode == HYBRID_MODE_7C) {
 			retval = rdmalt(Adapter, (UINT)0x0f000c00,
-- 
1.8.1.2

