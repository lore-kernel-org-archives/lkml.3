Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaLCQMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:12:40 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62751 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaLCQMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:12:35 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        Jes.Sorensen@redhat.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] staging: rtl8723au: hal: Removed spaces before semicolon
Date: Wed,  3 Dec 2014 21:42:09 +0530
Message-Id: <1417623129-2868-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the checkpatch.pl warning:

WARNING: space prohibited before semicolon

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/rtl8723au/hal/odm_HWConfig.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/odm_HWConfig.c b/drivers/staging/rtl8723au/hal/odm_HWConfig.c
index 29d844d..a516b6e 100644
--- a/drivers/staging/rtl8723au/hal/odm_HWConfig.c
+++ b/drivers/staging/rtl8723au/hal/odm_HWConfig.c
@@ -113,7 +113,7 @@ static void odm_RxPhyStatus92CSeries_Parsing(struct dm_odm_t *pDM_Odm,
 
 		cck_highpwr = pDM_Odm->bCckHighPower;
 
-		cck_agc_rpt =  pPhyStaRpt->cck_agc_rpt_ofdm_cfosho_a ;
+		cck_agc_rpt =  pPhyStaRpt->cck_agc_rpt_ofdm_cfosho_a;
 
 		/* The RSSI formula should be modified according to the gain table */
 		if (!cck_highpwr) {
@@ -138,16 +138,16 @@ static void odm_RxPhyStatus92CSeries_Parsing(struct dm_odm_t *pDM_Odm,
 			report = (cck_agc_rpt & 0x60)>>5;
 			switch (report) {
 			case 0x3:
-				rx_pwr_all = -46 - ((cck_agc_rpt & 0x1f)<<1) ;
+				rx_pwr_all = -46 - ((cck_agc_rpt & 0x1f)<<1);
 				break;
 			case 0x2:
 				rx_pwr_all = -26 - ((cck_agc_rpt & 0x1f)<<1);
 				break;
 			case 0x1:
-				rx_pwr_all = -12 - ((cck_agc_rpt & 0x1f)<<1) ;
+				rx_pwr_all = -12 - ((cck_agc_rpt & 0x1f)<<1);
 				break;
 			case 0x0:
-				rx_pwr_all = 16 - ((cck_agc_rpt & 0x1f)<<1) ;
+				rx_pwr_all = 16 - ((cck_agc_rpt & 0x1f)<<1);
 				break;
 			}
 		}
-- 
1.9.1

