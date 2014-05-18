Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaERPVv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:21:51 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33490 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaERPVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:21:49 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/28] staging: rtl8188eu: Remove unused function rtl8188e_PHY_ConfigRFWithParaFile()
Date: Sun, 18 May 2014 20:49:00 +0530
Message-Id: <1400426361-19596-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 8079fc6..b50df3e 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -631,27 +631,6 @@ int PHY_RFConfig8188E(struct adapter *Adapter)
 	return rtStatus;
 }
 
-
-/*-----------------------------------------------------------------------------
- * Function:    PHY_ConfigRFWithParaFile()
- *
- * Overview:    This function read RF parameters from general file format, and do RF 3-wire
- *
- * Input:	struct adapter *Adapter
- *			ps8					pFileName
- *			enum rf_radio_path eRFPath
- *
- * Output:      NONE
- *
- * Return:      RT_STATUS_SUCCESS: configuration file exist
- *
- * Note:		Delay may be required for RF configuration
- *---------------------------------------------------------------------------*/
-int rtl8188e_PHY_ConfigRFWithParaFile(struct adapter *Adapter, u8 *pFileName, enum rf_radio_path eRFPath)
-{
-	return _SUCCESS;
-}
-
 void
 rtl8192c_PHY_GetHWRegOriginalValue(
 		struct adapter *Adapter
-- 
1.7.10.4

