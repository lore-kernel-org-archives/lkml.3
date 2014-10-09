Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbaJIVHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:07:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59114 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbaJIVHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:07:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Felipe Balbi <balbi@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 023/163] usb: gadget: fusb300_udc.h: Fix typo in include guard
Date: Thu,  9 Oct 2014 14:00:48 -0700
Message-Id: <1412888588-26755-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit f0798d6a04867ad8db8b41ddea45627d2c8cffe3 upstream.

Clearly this was meant to be an include guard, but a trailing
underscore was missing. It has been this way since the file was
introduced in 0fe6f1d1 ("usb: udc: add Faraday fusb300 driver").

Fixes: 0fe6f1d1 ("usb: udc: add Faraday fusb300 driver")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/gadget/fusb300_udc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/fusb300_udc.h b/drivers/usb/gadget/fusb300_udc.h
index ae811d8..ad39f89 100644
--- a/drivers/usb/gadget/fusb300_udc.h
+++ b/drivers/usb/gadget/fusb300_udc.h
@@ -12,7 +12,7 @@
 
 
 #ifndef __FUSB300_UDC_H__
-#define __FUSB300_UDC_H_
+#define __FUSB300_UDC_H__
 
 #include <linux/kernel.h>
 
-- 
1.9.1

