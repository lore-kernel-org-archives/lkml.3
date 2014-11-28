Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaK1Nwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:52:36 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:42290 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaK1NvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:24 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/17] net2280: Declare allow_status_338x as inline
Date: Fri, 28 Nov 2014 14:50:59 +0100
Message-Id: <1417182662-7405-15-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is very simple, does not declare any variable and it is
called in the irq path.

The counterpart for net228x is already declared as inline.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/net2280.h b/drivers/usb/gadget/udc/net2280.h
index c7c7981..b31deb0 100644
--- a/drivers/usb/gadget/udc/net2280.h
+++ b/drivers/usb/gadget/udc/net2280.h
@@ -125,7 +125,7 @@ static inline void allow_status(struct net2280_ep *ep)
 	ep->stopped = 1;
 }
 
-static void allow_status_338x(struct net2280_ep *ep)
+static inline void allow_status_338x(struct net2280_ep *ep)
 {
 	/*
 	 * Control Status Phase Handshake was set by the chip when the setup
-- 
2.1.3

