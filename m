Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaHMFp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:45:59 -0400
Received: from thoros.lunarpages.com ([67.210.120.70]:41682 "EHLO
	thoros.lunarpages.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaHMFpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:45:34 -0400
From: "Ragnar B. Johannsson" <ragnar@igo.is>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Ragnar B. Johannsson" <ragnar@igo.is>
Subject: [PATCH 1/3] staging: vt6656: remove unnecessary braces
Date: Sun, 10 Aug 2014 22:23:48 +0000
Message-Id: <1407709430-61260-2-git-send-email-ragnar@igo.is>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407709430-61260-1-git-send-email-ragnar@igo.is>
References: <1407709430-61260-1-git-send-email-ragnar@igo.is>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thoros.lunarpages.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [0 0]
X-AntiAbuse: Sender Address Domain - igo.is
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes unnecessary braces to comply with coding style.

Signed-off-by: Ragnar B. Johannsson <ragnar@igo.is>
---
 drivers/staging/vt6656/usbpipe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index cba6532..88bf518 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -131,11 +131,10 @@ static void vnt_start_interrupt_urb_complete(struct urb *urb)
 	}
 
 	status = usb_submit_urb(priv->interrupt_urb, GFP_ATOMIC);
-	if (status) {
+	if (status)
 		dev_dbg(&priv->usb->dev, "Submit int URB failed %d\n", status);
-	} else {
+	else
 		priv->int_buf.in_use = true;
-	}
 }
 
 int vnt_start_interrupt_urb(struct vnt_private *priv)
-- 
1.9.3

