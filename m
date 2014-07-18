Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623AbaGRLkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:40:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42909 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761480AbaGRLkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:40:03 -0400
X-AuditID: cbfee61b-f79f86d00000144c-13-53c907929523
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 04/12] usb: dwc2/gadget: Fix comment text
Date: Fri, 18 Jul 2014 13:39:29 +0200
Message-id: <1405683577-11226-5-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
References: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jAd1J7CeDDaYd4rSY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CV8XJ6I2vBFbaK360LGRsYz7N2MXJySAiYSKx5sYcFwhaT
	uHBvPVsXIxeHkMAiRon+1RNZIZx2JokLHw8ygVSxCehIbPk+gRHEFhEQkFj/4hI7SBGzwAlG
	iY7/F9hAEsICNhKd7VOYuxg5OFgEVCWmtwuChHkFXCUOTHwNtVlO4uSxyWA2p4CbRNuj/ywg
	5UJANdO+8k9g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzi4nknvYFzVYHGIUYCD
	UYmH1+Lm8WAh1sSy4srcQ4wSHMxKIrzZ94FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcK
	CaQnlqRmp6YWpBbBZJk4OKUaGGf7y077OlOjziHBZ9Pncyp738VYBTUacPyYzrz9ggTDYYtf
	OVodi84r20UrbTyWk2Fjq7Ly1Kk7n9aozoiTrj93NWfnpaNxa96y89y5ZrThyiUrC0GGV5J+
	z3YlzDK49eDmcunD38O6vBt/1cd/+mm232nej6nPVqXXXOUVVc7dV7En32xO8HklluKMREMt
	5qLiRADXfueXKgIAAA==
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

