Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaHSI5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:57:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55177 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaHSI5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:57:33 -0400
X-AuditID: cbfee61a-f79e46d00000134f-a7-53f3117cc95b
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v3 04/12] usb: dwc2/gadget: Fix comment text
Date: Tue, 19 Aug 2014 10:54:10 +0200
Message-id: <1408438458-3317-5-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
References: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jQd0awc/BBrfXK1nMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wWjx5uZbV4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DKWDLzAVPBFbaKzxNzGxjPs3YxcnJICJhITN17lAnCFpO4
	cG89WxcjF4eQwHRGiSNL1rFAOO1MEo0rb7CAVLEJ6Ehs+T6BEcQWEZCXuL7xJlgRs8AhRolX
	d44BjeLgEBZwlvh8JwKkhkVAVWLLurdgvbwCLhKbz7yH2iwncfLYZDCbU8BV4u2+WewgthBI
	TesZtgmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAfXM6kdjCsbLA4xCnAwKvHw
	Knz5GCzEmlhWXJkLdAwHs5IIr+OLT8FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcKCaQn
	lqRmp6YWpBbBZJk4OKUaGOPtOno5bX12bpPxvL/9XXcq66pok5tbZMP2x7Baut8P0tjwbmJU
	SyNT41c7ffPtG6T4k1lrOZ/6W6xb+OTS3+Bc368fC9admNai0Cqj9Vcqal2ffs6ajwXzHsdc
	qqmTSzeJZz6yQFRwruME0U89GktW8G1RmKZ8bmtBgfAjQ4NAvVspq44IKLEUZyQaajEXFScC
	AIaZ/fEqAgAA
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
index 2d09ed1..8131ccd 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2934,7 +2934,7 @@ static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
 	struct s3c_hsotg *hsotg = to_hsotg(gadget);
 	unsigned long flags = 0;
 
-	dev_dbg(hsotg->dev, "%s: is_in: %d\n", __func__, is_on);
+	dev_dbg(hsotg->dev, "%s: is_on: %d\n", __func__, is_on);
 
 	spin_lock_irqsave(&hsotg->lock, flags);
 	if (is_on) {
-- 
1.9.1

