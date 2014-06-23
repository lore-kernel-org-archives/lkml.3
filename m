Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaFWHxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:53:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50720 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaFWHxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:53:09 -0400
X-AuditID: cbfee61a-f79e46d00000134f-6d-53a7dcddeba6
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 04/11] usb: dwc2/gadget: Fix comment text
Date: Mon, 23 Jun 2014 09:51:23 +0200
Message-id: <1403509890-14103-5-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd17d5YHG8w5zGox62U7i8XB+/UW
	zYvXs1lc3jWHzWLRslZmi7VH7rJbbJ8yncniweGd7A4cHvvnrmH36NuyitFjy/7PjB7Hb2xn
	8vi8SS6ANYrLJiU1J7MstUjfLoEr4+X0RtaCK2wVv1sXMjYwnmftYuTkkBAwkXj/ZwcLhC0m
	ceHeerYuRi4OIYHpjBId//6wQjjtTBKfts1lBqliE9CR2PJ9AiOILSIgILH+xSV2kCJmgRNA
	Hf8vsIEkhAUsJd5eXQA2lkVAVWLt/TNgNq+Aq8STjovsEOvkJE4emwx2BqeAm8T6mwvB4kJA
	NYtOT2OfwMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwgD2T2sG4ssHiEKMAB6MS
	D6+G2/JgIdbEsuLK3EOMEhzMSiK8jQ1AId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTS
	E0tSs1NTC1KLYLJMHJxSDYwr1VsbXj3YskZCtFlUR8vg6mq+S5a73jNocvP9flnP2rpyeu6i
	zglZe2ZYHr6s1KXoySpXv7Hhkdumnh+dF7tzKytc96pFLC3a9o81JXl+eviy2RZ3Ly8rX/VE
	bfbG0MztWTY19+TeJDotVhST77AwW7LTdJZw4+LCuZqa/deKS0qsZ01bfEuJpTgj0VCLuag4
	EQARLW1kLAIAAA==
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

