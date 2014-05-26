Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaEZQG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:06:26 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38164 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaEZQGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:06:23 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/24] staging: rtl8188eu: Remove unused function ODM_MacStatusQuery()
Date: Mon, 26 May 2014 21:35:20 +0530
Message-Id: <1401120339-23667-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm_HWConfig.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_HWConfig.c b/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
index a755df3..0145a11 100644
--- a/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
+++ b/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
@@ -436,14 +436,6 @@ void ODM_PhyStatusQuery(struct odm_dm_struct *dm_odm,
 	ODM_PhyStatusQuery_92CSeries(dm_odm, pPhyInfo, pPhyStatus, pPktinfo);
 }
 
-/*  For future use. */
-void ODM_MacStatusQuery(struct odm_dm_struct *dm_odm, u8 *mac_stat,
-			u8 macid, bool pkt_match_bssid,
-			bool pkttoself, bool pkt_beacon)
-{
-	/*  2011/10/19 Driver team will handle in the future. */
-}
-
 enum HAL_STATUS ODM_ConfigRFWithHeaderFile(struct odm_dm_struct *dm_odm,
 					   enum rf_radio_path content,
 					   enum rf_radio_path rfpath)
-- 
1.7.10.4

