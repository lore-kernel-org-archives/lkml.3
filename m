Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaEZQGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:06:38 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40738 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaEZQGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:06:36 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/24] staging: rtl8188eu: Remove function with empty defination dm_CheckStatistics()
Date: Mon, 26 May 2014 21:35:22 +0530
Message-Id: <1401120339-23667-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c b/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
index cf88bf2..4e9f797 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
@@ -31,10 +31,6 @@
 
 #include <rtl8188e_hal.h>
 
-static void dm_CheckStatistics(struct adapter *Adapter)
-{
-}
-
 /*  Initialize GPIO setting registers */
 static void dm_InitGPIOSetting(struct adapter *Adapter)
 {
@@ -173,12 +169,6 @@ void rtl8188e_HalDmWatchDog(struct adapter *Adapter)
 	if (Adapter->wdinfo.p2p_ps_mode)
 		fw_ps_awake = false;
 
-	if (hw_init_completed && ((!fw_cur_in_ps) && fw_ps_awake)) {
-		/*  Calculate Tx/Rx statistics. */
-		dm_CheckStatistics(Adapter);
-
-	}
-
 	/* ODM */
 	if (hw_init_completed) {
 		struct mlme_priv *pmlmepriv = &Adapter->mlmepriv;
-- 
1.7.10.4

