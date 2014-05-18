Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaERP1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:27:19 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63871 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaERP1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:27:17 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 27/28] staging: rtl8188eu: Remove unused function ODM_DynamicPrimaryCCA_DupRTS()
Date: Sun, 18 May 2014 20:49:20 +0530
Message-Id: <1400426361-19596-28-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 7c1043c..a90b2c5 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -377,13 +377,6 @@ void odm_PrimaryCCA_Init(struct odm_dm_struct *dm_odm)
 	PrimaryCCA->PriCCA_flag = 0;
 }
 
-bool ODM_DynamicPrimaryCCA_DupRTS(struct odm_dm_struct *dm_odm)
-{
-	struct dyn_primary_cca *PrimaryCCA = &(dm_odm->DM_PriCCA);
-
-	return	PrimaryCCA->DupRTS_flag;
-}
-
 void odm_DynamicPrimaryCCA(struct odm_dm_struct *dm_odm)
 {
 	return;
-- 
1.7.10.4

