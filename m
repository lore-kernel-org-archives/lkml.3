Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbaHaFY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 01:24:58 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57126 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaHaFY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 01:24:57 -0400
From: Anh Le <anhlq2110@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: bcm: fixed a comment coding style issue
Date: Sun, 31 Aug 2014 12:24:50 +0700
Message-Id: <1409462690-8620-1-git-send-email-anhlq2110@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a C99 comment issue in InterfaceMisc.h.

Signed-off-by: Anh Le <anhlq2110@gmail.com>
---
 drivers/staging/bcm/InterfaceMisc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/InterfaceMisc.h b/drivers/staging/bcm/InterfaceMisc.h
index efb6860..0e5e38b 100644
--- a/drivers/staging/bcm/InterfaceMisc.h
+++ b/drivers/staging/bcm/InterfaceMisc.h
@@ -39,4 +39,4 @@ VOID Bcm_kill_all_URBs(struct bcm_interface_adapter *psIntfAdapter);
 
 #define DISABLE_USB_ZERO_LEN_INT 0x0F011878
 
-#endif // __INTERFACE_MISC_H
+#endif /* __INTERFACE_MISC_H */
-- 
1.8.5.5

