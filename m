Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbaJVJtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:49:49 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:33180 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaJVJs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:48:58 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH/TRIVIAL 5/5] usb: gadget: zero: Spelling s/infrastucture/infrastructure/
Date: Wed, 22 Oct 2014 11:49:03 +0200
Message-Id: <1413971343-27554-5-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413971343-27554-1-git-send-email-geert+renesas@glider.be>
References: <1413971343-27554-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/legacy/zero.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/legacy/zero.c b/drivers/usb/gadget/legacy/zero.c
index ebf09f439f3aaf13..ff97ac93ac03d0ad 100644
--- a/drivers/usb/gadget/legacy/zero.c
+++ b/drivers/usb/gadget/legacy/zero.c
@@ -28,7 +28,7 @@
  *
  * Why is *this* driver using two configurations, rather than setting up
  * two interfaces with different functions?  To help verify that multiple
- * configuration infrastucture is working correctly; also, so that it can
+ * configuration infrastructure is working correctly; also, so that it can
  * work with low capability USB controllers without four bulk endpoints.
  */
 
-- 
1.9.1

