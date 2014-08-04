Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaHDATl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:19:41 -0400
Received: from s87.loopia.se ([194.9.94.112]:29989 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbaHDATj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:19:39 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: sameo@linux.intel.com, lee.jones@linaro.org, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 07/19] mfd: omap-usb-host: fix %d confusingly prefixed with 0x in format string
Date: Sun,  3 Aug 2014 17:19:27 -0700
Message-Id: <1407111567-14778-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/mfd/omap-usb-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 33a9234..83dab2f 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -647,7 +647,7 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		default:
 			omap->nports = OMAP3_HS_USB_PORTS;
 			dev_dbg(dev,
-			 "USB HOST Rev:0x%d not recognized, assuming %d ports\n",
+			 "USB HOST Rev:0x%x not recognized, assuming %d ports\n",
 			 omap->usbhs_rev, omap->nports);
 			break;
 		}
-- 
2.0.0.526.g5318336

