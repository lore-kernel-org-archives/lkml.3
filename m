Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaGDJ1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:27:12 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:60542 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaGDJ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:27:10 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] usb: gadget: net2280: Fix typo on #ifdef
Date: Fri,  4 Jul 2014 11:27:03 +0200
Message-Id: <1404466023-2782-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e56e69cc0ff4 ("usb: gadget: net2280: Use pr_* function")
includes a editing mistake on one of the #ifdef.

This patch fixes it.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index ce8bc86..248dccb 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -1562,7 +1562,7 @@ static const struct usb_gadget_ops net2280_ops = {
 
 /*-------------------------------------------------------------------------*/
 
-#ifdef	CONFIG_USB_GADGET_PDEBUG_FILES
+#ifdef	CONFIG_USB_GADGET_DEBUG_FILES
 
 /* FIXME move these into procfs, and use seq_file.
  * Sysfs _still_ doesn't behave for arbitrarily sized files,
-- 
2.0.0

