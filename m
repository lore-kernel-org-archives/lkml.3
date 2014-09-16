Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaIPSyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:54:32 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:56270 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbaIPSyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:54:31 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] include/linux/screen_info.h: Remove unused ORIG_* macros
Date: Tue, 16 Sep 2014 20:54:24 +0200
Message-Id: <1410893664-6784-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ORIG_* macros definitions to access struct screen_info members and
all of their users were removed 7 years ago by commit 3ea335100014785f
("Remove magic macros for screen_info structure members"), but (only)
the definitions reappeared a few days later in commit ee8e7cfe9d330d6f
("Make asm-x86/bootparam.h includable from userspace.").

Remove them for good. Amen.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/screen_info.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index 005bf3e38db555a8..f0f8bad54be9e509 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -5,12 +5,4 @@
 
 extern struct screen_info screen_info;
 
-#define ORIG_X			(screen_info.orig_x)
-#define ORIG_Y			(screen_info.orig_y)
-#define ORIG_VIDEO_MODE		(screen_info.orig_video_mode)
-#define ORIG_VIDEO_COLS 	(screen_info.orig_video_cols)
-#define ORIG_VIDEO_EGA_BX	(screen_info.orig_video_ega_bx)
-#define ORIG_VIDEO_LINES	(screen_info.orig_video_lines)
-#define ORIG_VIDEO_ISVGA	(screen_info.orig_video_isVGA)
-#define ORIG_VIDEO_POINTS       (screen_info.orig_video_points)
 #endif /* _SCREEN_INFO_H */
-- 
1.9.1

