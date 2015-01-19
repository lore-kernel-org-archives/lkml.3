Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbbASKQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:16:39 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51443 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbbASKQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:16:37 -0500
Date: Mon, 19 Jan 2015 12:16:30 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        guido@vanguardiasur.com.ar, silvagustavosilva@gmail.com,
        fred.chou.nd@gmail.com, gclement@baobob.org, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: vt6655: fix space prohibited before that ','
Message-ID: <20150119101630.GA8264@mohammed-Inspiron-3537>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error:
fix space prohibited before that ','

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
v2: added Signed-off line 

 drivers/staging/vt6655/mac.c |    2 +-
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
1.7.9.5

