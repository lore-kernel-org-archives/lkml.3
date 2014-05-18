Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaERP1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:27:34 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47327 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaERP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:27:33 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 28/28] staging: rtl8188eu:Remove function with empty defination odm_DynamicPrimaryCCA()
Date: Sun, 18 May 2014 20:49:21 +0530
Message-Id: <1400426361-19596-29-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c              |    1 -
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c     |    5 -----
 drivers/staging/rtl8188eu/include/odm_RTL8188E.h |    2 --
 3 files changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 425c50a4..a39eba9 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -214,7 +214,6 @@ void ODM_DMWatchdog(struct odm_dm_struct *pDM_Odm)
 
 	odm_RefreshRateAdaptiveMask(pDM_Odm);
 
-	odm_DynamicPrimaryCCA(pDM_Odm);
 	if ((pDM_Odm->AntDivType ==  CG_TRX_HW_ANTDIV)	||
 	    (pDM_Odm->AntDivType == CGCS_RX_HW_ANTDIV)	||
 	    (pDM_Odm->AntDivType == CG_TRX_SMART_ANTDIV))
diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index a90b2c5..a24d954 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -376,8 +376,3 @@ void odm_PrimaryCCA_Init(struct odm_dm_struct *dm_odm)
 	PrimaryCCA->Monitor_flag = 0;
 	PrimaryCCA->PriCCA_flag = 0;
 }
-
-void odm_DynamicPrimaryCCA(struct odm_dm_struct *dm_odm)
-{
-	return;
-}
diff --git a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
index f96ad5a..02ac78d 100644
--- a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
+++ b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
@@ -51,6 +51,4 @@ void odm_PrimaryCCA_Init(struct odm_dm_struct *pDM_Odm);
 
 bool ODM_DynamicPrimaryCCA_DupRTS(struct odm_dm_struct *pDM_Odm);
 
-void odm_DynamicPrimaryCCA(struct odm_dm_struct *pDM_Odm);
-
 #endif
-- 
1.7.10.4

