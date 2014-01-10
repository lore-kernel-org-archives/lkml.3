Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbaAJVpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:45:04 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:65014 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaAJVo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:44:58 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: lm-sensors@lm-sensors.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: [PATCH] hwmon: (sht15) add include guard
Date: Fri, 10 Jan 2014 16:44:46 -0500
Message-Id: <1389390286-6287-2-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389390286-6287-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1389390286-6287-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add include guard to include/linux/platform_data/sht15.h to prevent
multiple inclusion.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 include/linux/platform_data/sht15.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/platform_data/sht15.h b/include/linux/platform_data/sht15.h
index 33e0fd2..12289c1 100644
--- a/include/linux/platform_data/sht15.h
+++ b/include/linux/platform_data/sht15.h
@@ -12,6 +12,9 @@
  * For further information, see the Documentation/hwmon/sht15 file.
  */
 
+#ifndef _PDATA_SHT15_H
+#define _PDATA_SHT15_H
+
 /**
  * struct sht15_platform_data - sht15 connectivity info
  * @gpio_data:		no. of gpio to which bidirectional data line is
@@ -31,3 +34,5 @@ struct sht15_platform_data {
 	bool no_otp_reload;
 	bool low_resolution;
 };
+
+#endif /* _PDATA_SHT15_H */
-- 
1.8.5.2

