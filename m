Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbaGPKXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:23:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18010 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbaGPKXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:23:00 -0400
X-AuditID: cbfee61b-f79f86d00000144c-42-53c65282d9a7
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 04/12] usb: dwc2/gadget: Fix comment text
Date: Wed, 16 Jul 2014 12:22:22 +0200
Message-id: <1405506150-16185-5-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd2moGPBBhM+aVjMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wW26dMZ7J4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DKeDm9kbXgClvF79aFjA2M51m7GDk5JARMJJ5N/cIMYYtJ
	XLi3nq2LkYtDSGA6o0TL0XMsEE47k8SqedvAOtgEdCS2fJ/ACGKLCAhIrH9xiR2kiFngBKNE
	x/8LbCAJYQEbiZkXDgIlODhYBFQlDt/gAwnzCrhKrNuxkRFim5zEyWOTwWZyCrhJrHndzA5i
	CwHVHF+3jGkCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHh9Ux6B+OqBotDjAIc
	jEo8vBtCjgYLsSaWFVfmHmKU4GBWEuF18D8WLMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1
	oJBAemJJanZqakFqEUyWiYNTqoExMihB7bCr+PM4a/e56g8zMudbv/Axu/khclXNo4UTX4sf
	27emqu/1tksLq123/Oc6yX/60YeLsoH2L/Z/3jV/w4xapsoLfK9Pbku5knPw95X6OucFlspH
	u0QsuXYJTAp6nPuy+JlFLKvf/LDCZpaZRUzhrp5bt5jGMZwQCM3usvzPKbopeckOJZbijERD
	Leai4kQALHucJysCAAA=
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
index fc27b4c..35b4890 100644
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

