Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaLAPxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:53:54 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52083 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaLAPxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:53:52 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        es.Sorensen@redhat.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] staging: rtl8723au: hal: Removed spaces before starting of a line
Date: Mon,  1 Dec 2014 21:23:17 +0530
Message-Id: <1417449197-3227-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the checkpatch.pl warning:

WARNING: please, no spaces at the start of a line

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c b/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
index 88e0126..959e89e 100644
--- a/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
+++ b/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
@@ -20,7 +20,7 @@ odm_ConfigRFReg_8723A(
 	struct dm_odm_t *pDM_Odm,
 	u32					Addr,
 	u32					Data,
-  enum RF_RADIO_PATH     RF_PATH,
+enum RF_RADIO_PATH     RF_PATH,
 	u32				    RegAddr
 	)
 {
@@ -60,7 +60,7 @@ odm_ConfigBB_AGC_8723A(
 	u32		Addr,
 	u32		Bitmask,
 	u32		Data
-  )
+)
 {
 	ODM_SetBBReg(pDM_Odm, Addr, Bitmask, Data);
 	/*  Add 1us delay between BB/RF register setting. */
@@ -77,7 +77,7 @@ odm_ConfigBB_PHY_8723A(
 	u32		Addr,
 	u32		Bitmask,
 	u32		Data
-  )
+)
 {
 	if (Addr == 0xfe)
 		msleep(50);
-- 
1.9.1

