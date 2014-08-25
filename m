Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaHYIb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:31:26 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:45073 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbaHYIbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:31:24 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>, <stable@vger.kernel.org>
Subject: [PATCH v3] drivers: usb: gadget: fusb300_udc.h: Fix typo in include guard
Date: Mon, 25 Aug 2014 10:30:25 +0200
Message-Id: <1408955425-6169-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140822155809.GA27616@saruman.home>
References: <20140822155809.GA27616@saruman.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clearly this was meant to be an include guard, but a trailing
underscore was missing. It has been this way since the file was
introduced in 0fe6f1d1 ("usb: udc: add Faraday fusb300 driver").

Fixes: 0fe6f1d1 ("usb: udc: add Faraday fusb300 driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---

Notes:
    v2: Add proper commit message.
    
    v3: Add "Fixes:" and "Cc: stable" tags as requested by Felipe Balbi.

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
2.0.4

