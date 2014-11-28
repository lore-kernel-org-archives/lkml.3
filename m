Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaK1Nyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:54:39 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:64860 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaK1NvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:13 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/17] net2280: Remove restart_dma inline function definition
Date: Fri, 28 Nov 2014 14:50:51 +0100
Message-Id: <1417182662-7405-7-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

restart_dma is not used before it is declaration. Therefore we can
remove this definition.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index 0340462..e8c36db 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -1043,8 +1043,6 @@ dma_done(struct net2280_ep *ep,	struct net2280_request *req, u32 dmacount,
 	done(ep, req, status);
 }
 
-static void restart_dma(struct net2280_ep *ep);
-
 static void scan_dma_completions(struct net2280_ep *ep)
 {
 	/* only look at descriptors that were "naturally" retired,
-- 
2.1.3

