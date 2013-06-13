Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3FMSaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:30:03 -0400
Received: from etezian.org ([198.101.225.253]:56462 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758983Ab3FMS3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:29:00 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 14/19] bh1770glc: Modified the neutral glass attenuation value
Date: Thu, 13 Jun 2013 20:20:48 +0200
Message-Id: <811ab0e9e602fd48bd5bf61e64451674123b66c9.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Onur Atilla <oatilla@gmail.com>

Changed the neutral glass attenuation value from 16384
to 8192. This is for adaptation to the new scaling factor.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 include/linux/i2c/bh1770glc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/i2c/bh1770glc.h b/include/linux/i2c/bh1770glc.h
index 3efbae4..aaf0906 100644
--- a/include/linux/i2c/bh1770glc.h
+++ b/include/linux/i2c/bh1770glc.h
@@ -32,7 +32,7 @@
 #define BH1770_LED_100mA	4
 #define BH1770_LED_150mA	5
 #define BH1770_LED_200mA	6
-#define BH1770_NEUTRAL_GA 16384 /* 16384 / 16384 = 1 */
+#define BH1770_NEUTRAL_GA	8192 /* 8192 / 8192 = 1 */
 
 /**
  * struct bh1770_platform_data - platform data for bh1770glc driver
@@ -41,7 +41,7 @@
  * @setup_resources: Call back for interrupt line setup function
  * @release_resources: Call back for interrupte line release function
  *
- * Example of glass attenuation: 16384 * 385 / 100 means attenuation factor
+ * Example of glass attenuation: 8192 * 385 / 100 means attenuation factor
  * of 3.85. i.e. light_above_sensor = light_above_cover_window / 3.85
  */
 
-- 
1.7.10.4

