Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbaHVM7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:59:44 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:54945 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbaHVM7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:59:42 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: usb: gadget: fusb300_udc.h: Fix typo in include guard
Date: Fri, 22 Aug 2014 14:59:32 +0200
Message-Id: <1408712372-14686-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/usb/gadget/udc/fusb300_udc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/fusb300_udc.h b/drivers/usb/gadget/udc/fusb300_udc.h
index ae811d8..ad39f89 100644
--- a/drivers/usb/gadget/udc/fusb300_udc.h
+++ b/drivers/usb/gadget/udc/fusb300_udc.h
@@ -12,7 +12,7 @@
 
 
 #ifndef __FUSB300_UDC_H__
-#define __FUSB300_UDC_H_
+#define __FUSB300_UDC_H__
 
 #include <linux/kernel.h>
 
-- 
1.9.2

