Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaERP1C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:27:02 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56105 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaERP1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:27:01 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 26/28] staging: rtl8188eu: Remove unused function DM_DIG_LowerBound_88E()
Date: Sun, 18 May 2014 20:49:19 +0530
Message-Id: <1400426361-19596-27-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 323eb93..7c1043c 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -20,18 +20,6 @@
 
 #include "odm_precomp.h"
 
-void ODM_DIG_LowerBound_88E(struct odm_dm_struct *dm_odm)
-{
-	struct rtw_dig *pDM_DigTable = &dm_odm->DM_DigTable;
-
-	if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV) {
-		pDM_DigTable->rx_gain_range_min = (u8) pDM_DigTable->AntDiv_RSSI_max;
-		ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD,
-			     ("ODM_DIG_LowerBound_88E(): pDM_DigTable->AntDiv_RSSI_max=%d\n", pDM_DigTable->AntDiv_RSSI_max));
-	}
-	/* If only one Entry connected */
-}
-
 static void odm_RX_HWAntDivInit(struct odm_dm_struct *dm_odm)
 {
 	struct adapter *adapter = dm_odm->Adapter;
-- 
1.7.10.4

