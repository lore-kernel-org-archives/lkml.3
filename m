Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3ETDsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:48:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64166 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab3ETDs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:48:29 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 19 May 2013 22:48:28 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: lm-sensors <lm-sensors@lm-sensors.org>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] MAINTAINERS: Add myself as maintainer for LM95234 and TMP401 drivers
Date: Sun, 19 May 2013 20:48:35 -0700
Message-Id: <1369021715-31502-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote the LM95234 driver and extended the TMP401 driver substantially,
and I have hardware to test both, so it makes sense to explicitly
maintain them.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 MAINTAINERS |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d7782b..f0f3d20 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4976,6 +4976,13 @@ S:	Maintained
 F:	Documentation/hwmon/lm90
 F:	drivers/hwmon/lm90.c
 
+LM95234 HARDWARE MONITOR DRIVER
+M:	Guenter Roeck <linux@roeck-us.net>
+L:	lm-sensors@lm-sensors.org
+S:	Maintained
+F:	Documentation/hwmon/lm95234
+F:	drivers/hwmon/lm95234.c
+
 LME2510 MEDIA DRIVER
 M:	Malcolm Priestley <tvboxspy@gmail.com>
 L:	linux-media@vger.kernel.org
@@ -8182,6 +8189,13 @@ F:	drivers/mmc/host/sh_mobile_sdhi.c
 F:	include/linux/mmc/tmio.h
 F:	include/linux/mmc/sh_mobile_sdhi.h
 
+TMP401 HARDWARE MONITOR DRIVER
+M:	Guenter Roeck <linux@roeck-us.net>
+L:	lm-sensors@lm-sensors.org
+S:	Maintained
+F:	Documentation/hwmon/tmp401
+F:	drivers/hwmon/tmp401.c
+
 TMPFS (SHMEM FILESYSTEM)
 M:	Hugh Dickins <hughd@google.com>
 L:	linux-mm@kvack.org
-- 
1.7.9.7

