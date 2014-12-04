Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbaLDNur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:50:47 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35824 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaLDNup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:50:45 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        es.Sorensen@redhat.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] staging: rtl8723au: hal: Removed space before semicolon
Date: Thu,  4 Dec 2014 19:20:30 +0530
Message-Id: <1417701030-5167-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the checkpatch.pl warning:

WARNING: spaces prohibited before semicolon

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/rtl8723au/hal/odm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
index cabe33a..216930a 100644
--- a/drivers/staging/rtl8723au/hal/odm.c
+++ b/drivers/staging/rtl8723au/hal/odm.c
@@ -983,10 +983,10 @@ void odm_1R_CCA23a(struct dm_odm_t *pDM_Odm)
 void ODM_RF_Saving23a(struct dm_odm_t *pDM_Odm, u8 bForceInNormal)
 {
 	struct dynamic_pwr_sav *pDM_PSTable = &pDM_Odm->DM_PSTable;
-	u8 Rssi_Up_bound = 30 ;
+	u8 Rssi_Up_bound = 30;
 	u8 Rssi_Low_bound = 25;
 	if (pDM_Odm->PatchID == 40) { /* RT_CID_819x_FUNAI_TV */
-		Rssi_Up_bound = 50 ;
+		Rssi_Up_bound = 50;
 		Rssi_Low_bound = 45;
 	}
 	if (pDM_PSTable->initialize == 0) {
-- 
1.9.1

