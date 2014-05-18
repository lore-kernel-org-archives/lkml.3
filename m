Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaERPZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:25:53 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38200 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaERPZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:25:51 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 22/28] staging: rtl8188eu: Remove unused funtion odm_DynamicTxPowerNIC()
Date: Sun, 18 May 2014 20:49:15 +0530
Message-Id: <1400426361-19596-23-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index cc73188..8dd5f7e 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -1131,15 +1131,6 @@ void odm_DynamicTxPower(struct odm_dm_struct *pDM_Odm)
 	/*  2012/01/12 MH According to Luke's suggestion, only high power will support the feature. */
 	if (!pDM_Odm->ExtPA)
 		return;
-
-	/*  2011/09/29 MH In HW integration first stage, we provide 4 different handle to operate */
-	/*  at the same time. In the stage2/3, we need to prive universal interface and merge all */
-	/*  HW dynamic mechanism. */
-	odm_DynamicTxPowerNIC(pDM_Odm);
-}
-
-void odm_DynamicTxPowerNIC(struct odm_dm_struct *pDM_Odm)
-{
 }
 
 /* 3============================================================ */
-- 
1.7.10.4

