Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaERP0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:26:15 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34544 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaERP0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:26:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 23/28] staging: rtl8188eu: Remove unused function odm_SwAntDivChkAntSwitchCallback()
Date: Sun, 18 May 2014 20:49:16 +0530
Message-Id: <1400426361-19596-24-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 8dd5f7e..4442181 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -1269,22 +1269,6 @@ void odm_TXPowerTrackingCheckCE(struct odm_dm_struct *pDM_Odm)
 	}
 }
 
-/* antenna mapping info */
-/*  1: right-side antenna */
-/*  2/0: left-side antenna */
-/* PDM_SWAT_Table->CCK_Ant1_Cnt /OFDM_Ant1_Cnt:  for right-side antenna:   Ant:1    RxDefaultAnt1 */
-/* PDM_SWAT_Table->CCK_Ant2_Cnt /OFDM_Ant2_Cnt:  for left-side antenna:     Ant:0    RxDefaultAnt2 */
-/*  We select left antenna as default antenna in initial process, modify it as needed */
-/*  */
-
-/* 3============================================================ */
-/* 3 SW Antenna Diversity */
-/* 3============================================================ */
-
-void odm_SwAntDivChkAntSwitchCallback(void *FunctionContext)
-{
-}
-
 /* 3============================================================ */
 /* 3 SW Antenna Diversity */
 /* 3============================================================ */
-- 
1.7.10.4

