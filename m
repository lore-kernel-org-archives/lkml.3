Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaERPZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:25:33 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55848 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaERPZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:25:31 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 21/28] staging: rtl8188eu: Remove unused function odm_RefreshRateAdaptiveMaskAPADSL()
Date: Sun, 18 May 2014 20:49:14 +0530
Message-Id: <1400426361-19596-22-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 01946cc..cc73188 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -1061,10 +1061,6 @@ void odm_RefreshRateAdaptiveMaskCE(struct odm_dm_struct *pDM_Odm)
 	}
 }
 
-void odm_RefreshRateAdaptiveMaskAPADSL(struct odm_dm_struct *pDM_Odm)
-{
-}
-
 /*  Return Value: bool */
 /*  - true: RATRState is changed. */
 bool ODM_RAStateCheck(struct odm_dm_struct *pDM_Odm, s32 RSSI, bool bForceUpdate, u8 *pRATRState)
-- 
1.7.10.4

