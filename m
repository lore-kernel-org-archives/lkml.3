Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3EUXqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:46:13 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45373 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3EUXqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:46:12 -0400
From: Severin Gsponer <svgsponer@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Severin Gsponer <svgsponer@gmail.com>
Subject: [PATCH] Staging: bcm: fix checkpatch errors and warnings in Version.h
Date: Wed, 22 May 2013 01:46:02 +0200
Message-Id: <1369179962-4319-1-git-send-email-svgsponer@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch change the comment style to C89 and removes a unnecessary line.

Signed-off-by: Severin Gsponer <svgsponer@gmail.com>
---
 drivers/staging/bcm/Version.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/bcm/Version.h b/drivers/staging/bcm/Version.h
index a07b956..f1cb9de 100644
--- a/drivers/staging/bcm/Version.h
+++ b/drivers/staging/bcm/Version.h
@@ -1,4 +1,3 @@
-
 /*Copyright (c) 2005 Beceem Communications Inc.
 
 Module Name:
@@ -17,7 +16,6 @@ Abstract:
 #define VER_FILETYPE                VFT_DRV
 #define VER_FILESUBTYPE             VFT2_DRV_NETWORK
 
-
 #define VER_FILEVERSION             5.2.45
 #define VER_FILEVERSION_STR         "5.2.45"
 
@@ -28,8 +26,4 @@ Abstract:
 #define VER_PRODUCTVERSION_STR      VER_FILEVERSION_STR
 
 
-
-
-//#include "common.ver"
-
-#endif 	//VERSION_H
+#endif /* VERSION_H */
-- 
1.7.10.4

