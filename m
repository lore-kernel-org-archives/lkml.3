Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbaIIIpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:45:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51220 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaIIIpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:45:16 -0400
X-AuditID: cbfee61a-f79e46d00000134f-0d-540ebe1acd71
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 2/6] usb: dwc2/gadget: Fix comment text
Date: Tue, 09 Sep 2014 10:44:53 +0200
Message-id: <1410252297-13738-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
References: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jQV3pfXwhBsc3MFnMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZ4tHDrawWDw7vZHdg99g/dw27R9+WVYweW/Z/ZvQ4fmM7k8fnTXIB
	rFFcNimpOZllqUX6dglcGQ+2PWMquMJWsevjb5YGxvOsXYycHBICJhK3rh5hh7DFJC7cW8/W
	xcjFISQwnVFi0/q5bCAJIYF2Jomd08RBbDYBHYkt3ycwgtgiAvIS1zfeZAGxmQUOMErMXRoF
	YgsLmEscvbUGbCiLgKrE9+M7wGxeAVeJtmVToJbJSZw8NhnsCE4BN4k/x76wQ+xylfg3ZxrL
	BEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCQ+qZ1A7GlQ0WhxgFOBiVeHgzgvlC
	hFgTy4orcw8xSnAwK4nwXtkNFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1
	tSC1CCbLxMEp1cC4RHLFhO9z3Q1d1Rde69ywK2iOS9udoMNyWsdkjvh9qEuy//v7a/PdNRFG
	Mh1RAt6zt0wyqSxkYPZ0SyhdGyN+Wu6X2ZGTDkv6GiflLT5suLR+2p2pevvOCkRFZvdaJ7z7
	P21RbOZ/5ydLp/87fDlK57Dcri0+mR9nGSqE9wtx7nj+92yUlWaSEktxRqKhFnNRcSIANRUi
	GyUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

Adjust the debug text to the name of the printed variable.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 9cbe136..186a3a8 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2935,7 +2935,7 @@ static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
 	struct s3c_hsotg *hsotg = to_hsotg(gadget);
 	unsigned long flags = 0;
 
-	dev_dbg(hsotg->dev, "%s: is_in: %d\n", __func__, is_on);
+	dev_dbg(hsotg->dev, "%s: is_on: %d\n", __func__, is_on);
 
 	spin_lock_irqsave(&hsotg->lock, flags);
 	if (is_on) {
-- 
1.9.1

