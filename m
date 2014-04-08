Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbaDHQLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:11:31 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46331 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbaDHQL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:11:29 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging:Line6:usbdefs.h parenthesis for Marcos
Date: Tue,  8 Apr 2014 17:11:26 +0100
Message-Id: <1396973486-30547-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: Macros with complex values should be enclosed in parenthesis

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/line6/usbdefs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
index 2d1cc47..48958b5 100644
--- a/drivers/staging/line6/usbdefs.h
+++ b/drivers/staging/line6/usbdefs.h
@@ -40,7 +40,7 @@
 #define LINE6_DEVID_TONEPORT_UX2  0x4142
 #define LINE6_DEVID_VARIAX        0x534d
 
-#define LINE6_BIT(x) LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x
+#define LINE6_BIT(x) (LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x)
 
 enum {
 	LINE6_INDEX_BASSPODXT,
-- 
1.8.3.2

