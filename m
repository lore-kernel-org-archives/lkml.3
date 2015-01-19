Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbbASILg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:11:36 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38364 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbbASILe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:11:34 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH v2 5/7] staging: sm7xxfb: no space is necessary after a cast
Date: Mon, 19 Jan 2015 13:41:04 +0530
Message-Id: <1421655067-7490-5-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1421655067-7490-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1421655067-7490-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch cleanup: space is not necessary after cast

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/sm7xxfb/sm7xxfb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 6bce9f1..6f0469a 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -352,8 +352,8 @@ static ssize_t smtcfb_read(struct fb_info *info, char __user *buf, size_t
 			dst++;
 		}
 		if (c & 3) {
-			u8 *dst8 = (u8 *) dst;
-			u8 __iomem *src8 = (u8 __iomem *) src;
+			u8 *dst8 = (u8 *)dst;
+			u8 __iomem *src8 = (u8 __iomem *)src;
 
 			for (i = c & 3; i--;) {
 				if (i & 1) {
@@ -363,7 +363,7 @@ static ssize_t smtcfb_read(struct fb_info *info, char __user *buf, size_t
 					src8 += 2;
 				}
 			}
-			src = (u32 __iomem *) src8;
+			src = (u32 __iomem *)src8;
 		}
 
 		if (copy_to_user(buf, buffer, c)) {
@@ -442,8 +442,8 @@ smtcfb_write(struct fb_info *info, const char __user *buf, size_t count,
 			src++;
 		}
 		if (c & 3) {
-			u8 *src8 = (u8 *) src;
-			u8 __iomem *dst8 = (u8 __iomem *) dst;
+			u8 *src8 = (u8 *)src;
+			u8 __iomem *dst8 = (u8 __iomem *)dst;
 
 			for (i = c & 3; i--;) {
 				if (i & 1) {
@@ -453,7 +453,7 @@ smtcfb_write(struct fb_info *info, const char __user *buf, size_t count,
 					dst8 += 2;
 				}
 			}
-			dst = (u32 __iomem *) dst8;
+			dst = (u32 __iomem *)dst8;
 		}
 
 		*ppos += c;
-- 
1.8.1.2

