Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3GDM0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:26:55 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:43386 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3GDM0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:32 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v2 05/14] fbdev: simplefb: add 32bit RGB formats
Date: Thu,  4 Jul 2013 14:25:05 +0200
Message-Id: <1372940714-12470-6-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32bit XRGB and ARGB are used by modern x86 systems for EFI and VESA
framebuffers. Add both variants so simplefb can be used on such systems.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 include/linux/platform_data/simplefb.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/platform_data/simplefb.h b/include/linux/platform_data/simplefb.h
index 5fa2c5e..e1630be 100644
--- a/include/linux/platform_data/simplefb.h
+++ b/include/linux/platform_data/simplefb.h
@@ -20,6 +20,8 @@
 #define SIMPLEFB_FORMATS \
 { \
 	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0}, DRM_FORMAT_RGB565 }, \
+	{ "a8r8g8b8", 32, {16, 8}, {8, 8}, {0, 8}, {24, 8}, DRM_FORMAT_ARGB8888 }, \
+	{ "x8r8g8b8", 32, {16, 8}, {8, 8}, {0, 8}, {0, 0}, DRM_FORMAT_XRGB8888 }, \
 }
 
 /*
-- 
1.8.3.2

