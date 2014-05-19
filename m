Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbaESTNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:13:33 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:50675 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbaESTLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:11:44 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/5] usb: gadget: net2280: Use S_I macros
Date: Mon, 19 May 2014 21:11:30 +0200
Message-Id: <1400526693-29776-3-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400526693-29776-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400526693-29776-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of octal notation, to be consistent around the file.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/net2280.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index c3205ec..5b2ab68 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -111,7 +111,7 @@ module_param(use_msi, bool, S_IRUGO);
 static ushort fifo_mode = 0;
 
 /* "modprobe net2280 fifo_mode=1" etc */
-module_param (fifo_mode, ushort, 0644);
+module_param(fifo_mode, ushort, S_IRUGO | S_IWUSR);
 
 /* enable_suspend -- When enabled, the driver will respond to
  * USB suspend requests by powering down the NET2280.  Otherwise,
@@ -125,7 +125,7 @@ module_param (enable_suspend, bool, S_IRUGO);
 
 /* force full-speed operation */
 static bool full_speed;
-module_param(full_speed, bool, 0444);
+module_param(full_speed, bool, S_IRUGO);
 MODULE_PARM_DESC(full_speed, "force full-speed mode -- for testing only!");
 
 #define	DIR_STRING(bAddress) (((bAddress) & USB_DIR_IN) ? "in" : "out")
-- 
2.0.0.rc2

