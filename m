Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbaAJVpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:45:00 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:59752 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaAJVo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:44:58 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: lm-sensors@lm-sensors.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: [PATCH] hwmon: (max197) add include guard
Date: Fri, 10 Jan 2014 16:44:45 -0500
Message-Id: <1389390286-6287-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add include guard to include/linux/platform_data/max197.h to prevent
multiple inclusion.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 include/linux/platform_data/max197.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/platform_data/max197.h b/include/linux/platform_data/max197.h
index e2a41dd..8da8f94 100644
--- a/include/linux/platform_data/max197.h
+++ b/include/linux/platform_data/max197.h
@@ -11,6 +11,9 @@
  * For further information, see the Documentation/hwmon/max197 file.
  */
 
+#ifndef _PDATA_MAX197_H
+#define _PDATA_MAX197_H
+
 /**
  * struct max197_platform_data - MAX197 connectivity info
  * @convert:	Function used to start a conversion with control byte ctrl.
@@ -19,3 +22,5 @@
 struct max197_platform_data {
 	int (*convert)(u8 ctrl);
 };
+
+#endif /* _PDATA_MAX197_H */
-- 
1.8.5.2

