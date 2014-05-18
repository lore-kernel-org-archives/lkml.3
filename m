Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaERPX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:23:59 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44331 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbaERPX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:23:57 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 15/28] staging: rtl8188eu: Remove unused function rtl8188e_RF_ChangeTxPath()
Date: Sun, 18 May 2014 20:49:08 +0530
Message-Id: <1400426361-19596-16-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index 2f1348f..52103da 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -47,29 +47,6 @@
 #include <rtl8188e_hal.h>
 
 /*-----------------------------------------------------------------------------
- * Function:	RF_ChangeTxPath
- *
- * Overview:	For RL6052, we must change some RF settign for 1T or 2T.
- *
- * Input:		u16 DataRate		0x80-8f, 0x90-9f
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 09/25/2008	MHC		Create Version 0.
- *						Firmwaer support the utility later.
- *
- *---------------------------------------------------------------------------*/
-void rtl8188e_RF_ChangeTxPath(struct adapter *Adapter, u16 DataRate)
-{
-/*  We do not support gain table change inACUT now !!!! Delete later !!! */
-}	/* RF_ChangeTxPath */
-
-
-/*-----------------------------------------------------------------------------
  * Function:    PHY_RF6052SetBandwidth()
  *
  * Overview:    This function is called by SetBWModeCallback8190Pci() only
-- 
1.7.10.4

