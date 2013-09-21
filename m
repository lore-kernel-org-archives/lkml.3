Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab3IUKNE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 06:13:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51214 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151Ab3IUKND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 06:13:03 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Correct register definition for FLL2_SYNC_BW
Date: Sat, 21 Sep 2013 11:02:04 +0100
Message-Id: <1379757724-28100-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had specified the mask twice for FLL2_SYNC_BW change the first mask
definition in a bit definition to match the other fields.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 include/linux/mfd/arizona/registers.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 4706d3d..cb49417 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -1908,7 +1908,7 @@
 #define ARIZONA_FLL2_SYNC_GAIN_MASK              0x003c  /* FLL2_SYNC_GAIN */
 #define ARIZONA_FLL2_SYNC_GAIN_SHIFT                  2  /* FLL2_SYNC_GAIN */
 #define ARIZONA_FLL2_SYNC_GAIN_WIDTH                  4  /* FLL2_SYNC_GAIN */
-#define ARIZONA_FLL2_SYNC_BW_MASK                0x0001  /* FLL2_SYNC_BW */
+#define ARIZONA_FLL2_SYNC_BW                     0x0001  /* FLL2_SYNC_BW */
 #define ARIZONA_FLL2_SYNC_BW_MASK                0x0001  /* FLL2_SYNC_BW */
 #define ARIZONA_FLL2_SYNC_BW_SHIFT                    0  /* FLL2_SYNC_BW */
 #define ARIZONA_FLL2_SYNC_BW_WIDTH                    1  /* FLL2_SYNC_BW */
-- 
1.7.2.5

