Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbaK1Qjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:39:41 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64566 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaK1Qjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:39:40 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] staging:drivers:staging:rtl8188eu:hal:rtl8188e_hal_init.c: Added a blank line after declaration
Date: Fri, 28 Nov 2014 22:09:09 +0530
Message-Id: <1417192749-5371-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a checkpatch.pl warning

WARNING:Missing blank line after declaration

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 68db5c9..7d460ea 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -182,6 +182,7 @@ static void rtl8188e_SetHalODMVar(struct adapter *Adapter, enum hal_odm_variable
 	case HAL_ODM_STA_INFO:
 		{
 			struct sta_info *psta = pValue1;
+
 			if (bSet) {
 				DBG_88E("### Set STA_(%d) info\n", psta->mac_id);
 				ODM_CmnInfoPtrArrayHook(podmpriv, ODM_CMNINFO_STA_STATUS, psta->mac_id, psta);
-- 
1.9.1

