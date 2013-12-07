Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3LGIqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 03:46:55 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:43941 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab3LGIqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 03:46:54 -0500
From: Gary Rookard <garyrookard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Gary Rookard <garyrookard@gmail.com>
Subject: [PATCH 11/11] Staging: bcm: DDRInint: tidy up indent issue.
Date: Sat,  7 Dec 2013 03:46:48 -0500
Message-Id: <1386406008-16040-1-git-send-email-garyrookard@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the eleventh patch of a series.

Signed-off-by: Gary Alan Rookard <garyrookard@gmail.com>
---
On branch staging-next
 drivers/staging/bcm/DDRInit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 96afa15..323570f 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -836,7 +836,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		case DDR_100_MHZ:
 			psDDRSetting = asT3B_DDRSetting100MHz;
 			RegCount = (sizeof(asT3B_DDRSetting100MHz)/
-		sizeof(struct bcm_ddr_setting));
+			sizeof(struct bcm_ddr_setting));
 			break;
 		case DDR_133_MHZ:
 			if (Adapter->bDPLLConfig == PLL_266_MHZ) {  /*266Mhz PLL selected. */
-- 
1.8.4

