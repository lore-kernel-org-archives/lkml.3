Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab3LGFCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 00:02:51 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:37540 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3LGFCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 00:02:50 -0500
From: Gary Rookard <garyrookard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Gary Rookard <garyrookard@gmail.com>
Subject: [PATCH 9/9] Staging: bcm: DDRInit: removed space from front of semicolon.
Date: Sat,  7 Dec 2013 00:02:45 -0500
Message-Id: <1386392565-11991-1-git-send-email-garyrookard@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the ninth patch of a series.

Signed-off-by: Gary Alan Rookard <garyrookard@gmail.com>

---
On branch staging-next
 drivers/staging/bcm/DDRInit.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index c808bc5..1b73819 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -3,7 +3,7 @@
 
 
 #define DDR_DUMP_INTERNAL_DEVICE_MEMORY 0xBFC02B00
-#define MIPS_CLOCK_REG 	0x0f000820
+#define MIPS_CLOCK_REG 0x0f000820
 
     /* DDR INIT-133Mhz */
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  /* index for 0x0F007000 */
@@ -1005,20 +1005,20 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 		case DDR_80_MHZ:
 			psDDRSetting = asT3LP_DDRSetting80MHz;
 			RegCount = ARRAY_SIZE(asT3LP_DDRSetting80MHz);
-			RegCount -= T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
+			RegCount -= T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			psDDRSetting += T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			break;
 		case DDR_100_MHZ:
 			psDDRSetting = asT3LP_DDRSetting100MHz;
 			RegCount = ARRAY_SIZE(asT3LP_DDRSetting100MHz);
-			RegCount -= T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
+			RegCount -= T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
 			psDDRSetting += T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
 			break;
 		case DDR_133_MHZ:
 			bOverrideSelfRefresh = TRUE;
 			psDDRSetting = asT3LP_DDRSetting133MHz;
 			RegCount = ARRAY_SIZE(asT3LP_DDRSetting133MHz);
-			RegCount -= T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
+			RegCount -= T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
 			psDDRSetting += T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
 			break;
 		default:
@@ -1034,20 +1034,20 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 		case DDR_80_MHZ:
 			psDDRSetting = asT3LPB_DDRSetting80MHz;
 			RegCount = ARRAY_SIZE(asT3LPB_DDRSetting80MHz);
-			RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
+			RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			break;
 		case DDR_100_MHZ:
 			psDDRSetting = asT3LPB_DDRSetting100MHz;
 			RegCount = ARRAY_SIZE(asT3LPB_DDRSetting100MHz);
-			RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
+			RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
 			psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
 			break;
 		case DDR_133_MHZ:
 			bOverrideSelfRefresh = TRUE;
 			psDDRSetting = asT3LPB_DDRSetting133MHz;
 			RegCount = ARRAY_SIZE(asT3LPB_DDRSetting133MHz);
-			RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
+			RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
 			psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
 			break;
 		case DDR_160_MHZ:
@@ -1066,20 +1066,20 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 		case DDR_80_MHZ:
 			psDDRSetting = asT3_DDRSetting80MHz;
 			RegCount = ARRAY_SIZE(asT3_DDRSetting80MHz);
-			RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
+			RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			break;
 		case DDR_100_MHZ:
 			psDDRSetting = asT3_DDRSetting100MHz;
 			RegCount = ARRAY_SIZE(asT3_DDRSetting100MHz);
-			RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
+			RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
 			psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
 			break;
 		case DDR_133_MHZ:
 			psDDRSetting = asT3_DDRSetting133MHz;
 			RegCount = ARRAY_SIZE(asT3_DDRSetting133MHz);
-			RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
-			psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
+			RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
+			psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
 			break;
 		default:
 			return -EINVAL;
@@ -1090,20 +1090,20 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 		case DDR_80_MHZ:
 			psDDRSetting = asT3B_DDRSetting80MHz;
 			RegCount = ARRAY_SIZE(asT3B_DDRSetting80MHz);
-			RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
+			RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			psDDRSetting += T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			break;
 		case DDR_100_MHZ:
 			psDDRSetting = asT3B_DDRSetting100MHz;
 			RegCount = ARRAY_SIZE(asT3B_DDRSetting100MHz);
-			RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
+			RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
 			psDDRSetting += T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
 			break;
 		case DDR_133_MHZ:
 			bOverrideSelfRefresh = TRUE;
 			psDDRSetting = asT3B_DDRSetting133MHz;
 			RegCount = ARRAY_SIZE(asT3B_DDRSetting133MHz);
-			RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
+			RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
 			psDDRSetting += T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
 			break;
 		}
@@ -1130,7 +1130,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	ul_ddr_setting_load_addr += sizeof(ULONG);
 	RegCount *= (sizeof(struct bcm_ddr_setting)/sizeof(ULONG));
 	while (RegCount && !retval) {
-		value = psDDRSetting->ulRegAddress ;
+		value = psDDRSetting->ulRegAddress;
 		retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 		ul_ddr_setting_load_addr += sizeof(ULONG);
 		if (!retval) {
-- 
1.8.4

