Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaHJOpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:45:53 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64266 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaHJOpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:45:51 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/22] staging: rtl8188eu: Remove unused function odm_ConfigMAC_8188E()
Date: Sun, 10 Aug 2014 20:14:19 +0530
Message-Id: <1407681875-2611-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c     |    8 --------
 drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h |    2 --
 2 files changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c b/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
index 9c6ad5b..634d111 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
@@ -20,14 +20,6 @@
 
 #include "odm_precomp.h"
 
-void odm_ConfigMAC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u8 Data)
-{
-	struct adapter *adapt = pDM_Odm->Adapter;
-
-	usb_write8(adapt, Addr, Data);
-	ODM_RT_TRACE(pDM_Odm, ODM_COMP_INIT, ODM_DBG_TRACE, ("===> ODM_ConfigMACWithHeaderFile: [MAC_REG] %08X %08X\n", Addr, Data));
-}
-
 void odm_ConfigBB_AGC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u32 Bitmask, u32 Data)
 {
 	struct adapter *adapter = pDM_Odm->Adapter;
diff --git a/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h b/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
index b0d94e1..dd49a86 100644
--- a/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
+++ b/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
@@ -20,8 +20,6 @@
 #ifndef __INC_ODM_REGCONFIG_H_8188E
 #define __INC_ODM_REGCONFIG_H_8188E
 
-void odm_ConfigMAC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u8 Data);
-
 void odm_ConfigBB_AGC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr,
 			    u32 Bitmask, u32 Data);
 
-- 
1.7.10.4

