Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbbASKiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:38:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47781 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbbASKiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:38:11 -0500
Date: Mon, 19 Jan 2015 12:38:06 +0200
From: Mohamed Lotfy Hammad <mohamed.lotfy.hammad@gmail.com>
To: devel@driverdev.osuosl.org
Cc: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        guido@vanguardiasur.com.ar, silvagustavosilva@gmail.com,
        gclement@baobob.org, joe@perches.com, linux-kernel@vger.kernel.org
Subject: [PATCH] fix space prohibited before that ','
Message-ID: <20150119103805.GA24731@lotfy1893-Ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error:
fix space prohibited before that ','

Signed-off-by: Mohamed Lotfy Hammad <mohamed.lotfy.hammad@gmail.com>
---
 drivers/staging/vt6655/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 63c9c7e..3653a2b 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -789,7 +789,7 @@ bool MACbPSWakeup(void __iomem *dwIoBase)
 
 	// Check if SyncFlushOK
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(dwIoBase + MAC_REG_PSCTL , &byOrgValue);
+		VNSvInPortB(dwIoBase + MAC_REG_PSCTL, &byOrgValue);
 		if (byOrgValue & PSCTL_WAKEDONE)
 			break;
 	}
-- 
2.1.0

