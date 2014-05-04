Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaEDTwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 15:52:09 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:32439 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbaEDTwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 15:52:08 -0400
From: =?UTF-8?q?Cl=C3=A9ment=20Calmels?= <clement.calmels@free.fr>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: correct coding style issue
Date: Sun,  4 May 2014 21:52:09 +0200
Message-Id: <1399233129-13436-1-git-send-email-clement.calmels@free.fr>
X-Mailer: git-send-email 2.0.0.rc0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove C99 comment and rewrite lines over 80 characters.
Warnings and error found by checkpatch.pl script.

Signed-off-by: Clément Calmels <clement.calmels@free.fr>
---
 drivers/staging/vt6655/tmacro.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/tmacro.h b/drivers/staging/vt6655/tmacro.h
index 59c6e72..264c6ed 100644
--- a/drivers/staging/vt6655/tmacro.h
+++ b/drivers/staging/vt6655/tmacro.h
@@ -44,17 +44,22 @@
 #define LOWORD(d)           ((unsigned short)(d))
 #endif
 #if !defined(HIWORD)
-#define HIWORD(d)           ((unsigned short)((((unsigned long)(d)) >> 16) & 0xFFFF))
+#define HIWORD(d)							\
+	((unsigned short)((((unsigned long)(d)) >> 16) & 0xFFFF))
 #endif
 
 #define LODWORD(q)          ((q).u.dwLowDword)
 #define HIDWORD(q)          ((q).u.dwHighDword)
 
 #if !defined(MAKEWORD)
-#define MAKEWORD(lb, hb)    ((unsigned short)(((unsigned char)(lb)) | (((unsigned short)((unsigned char)(hb))) << 8)))
+#define MAKEWORD(lb, hb)\
+	((unsigned short)(((unsigned char)(lb))				\
+			  | (((unsigned short)((unsigned char)(hb))) << 8)))
 #endif
 #if !defined(MAKEDWORD)
-#define MAKEDWORD(lw, hw)   ((unsigned long)(((unsigned short)(lw)) | (((unsigned long)((unsigned short)(hw))) << 16)))
+#define MAKEDWORD(lw, hw)\
+	((unsigned long)(((unsigned short)(lw))				\
+			 | (((unsigned long)((unsigned short)(hw))) << 16)))
 #endif
 
-#endif // __TMACRO_H__
+#endif /* __TMACRO_H__ */
-- 
2.0.0.rc0

