Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3G0Rqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 13:46:53 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:41339 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3G0Rqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 13:46:51 -0400
From: "santosh.anbu" <asantoshking@gmail.com>
To: airlied@linux.ie
Cc: asantosh.king@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] i2c.c: Fixed coding style issue for if statement
Date: Sat, 27 Jul 2013 23:18:36 +0530
Message-Id: <1374947316-7864-1-git-send-email-asantosh.king@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "santosh.anbu" <asantosh.king@gmail.com>

Fixed coding style issue

Signed-off-by: santosh.anbu <asantosh.king@gmail.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c b/drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c
index cfb9288..e88529c 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c
@@ -114,15 +114,19 @@ dcb_i2c_parse(struct nouveau_bios *bios, u8 idx, struct dcb_i2c_entry *info)
 
 		if (idx == 0) {
 			info->drive = nv_ro08(bios, ent + 4);
-			if (!info->drive) info->drive = 0x3f;
+			if (!info->drive)
+				info->drive = 0x3f;
 			info->sense = nv_ro08(bios, ent + 5);
-			if (!info->sense) info->sense = 0x3e;
+			if (!info->sense)
+				info->sense = 0x3e;
 		} else
 		if (idx == 1) {
 			info->drive = nv_ro08(bios, ent + 6);
-			if (!info->drive) info->drive = 0x37;
+			if (!info->drive)
+				info->drive = 0x37;
 			info->sense = nv_ro08(bios, ent + 7);
-			if (!info->sense) info->sense = 0x36;
+			if (!info->sense)
+				info->sense = 0x36;
 		}
 
 		info->type  = DCB_I2C_NV04_BIT;
-- 
1.8.1.2

