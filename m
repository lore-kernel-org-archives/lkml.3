Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934353AbaGYQKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:10:51 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36754 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605AbaGYQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:10:50 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from device_cfg.h
Date: Fri, 25 Jul 2014 19:10:36 +0300
Message-Id: <1406304636-31573-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from device_cfg.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/device_cfg.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_cfg.h b/drivers/staging/vt6655/device_cfg.h
index 1137ade..6adc0dd 100644
--- a/drivers/staging/vt6655/device_cfg.h
+++ b/drivers/staging/vt6655/device_cfg.h
@@ -27,7 +27,6 @@
 #ifndef __DEVICE_CONFIG_H
 #define __DEVICE_CONFIG_H
 
-//#include <linux/config.h>
 #include <linux/types.h>
 
 #include "ttype.h"
@@ -60,14 +59,12 @@ struct _version {
 #define DEVICE_VERSION       "1.19.12"
 #endif
 
-//config file
 #include <linux/fs.h>
 #include <linux/fcntl.h>
 #ifndef CONFIG_PATH
 #define CONFIG_PATH            "/etc/vntconfiguration.dat"
 #endif
 
-//Max: 2378=2312Payload + 30HD +4CRC + 2Padding + 4Len + 8TSF + 4RSR
 #define PKT_BUF_SZ          2390
 
 #define MAX_UINTS           8
-- 
1.7.9.5

