Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3IQOy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:54:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51399 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008Ab3IQOy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:54:57 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm5110: Update noise gate default to match the patch file
Date: Tue, 17 Sep 2013 15:44:20 +0100
Message-Id: <1379429060-10610-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default value for the noise gate control register is changed in the
patch file, we need to reflect this in the defaults array, this patch
does so.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 37463f3..7668d7a 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -583,7 +583,7 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x0000043E, 0x0080 },    /* R1086  - DAC Volume Limit 6R */
 	{ 0x0000043F, 0x0800 },    /* R1087  - Noise Gate Select 6R */
 	{ 0x00000450, 0x0000 },    /* R1104  - DAC AEC Control 1 */
-	{ 0x00000458, 0x0001 },    /* R1112  - Noise Gate Control */
+	{ 0x00000458, 0x0000 },    /* R1112  - Noise Gate Control */
 	{ 0x00000480, 0x0040 },    /* R1152  - Class W ANC Threshold 1 */
 	{ 0x00000481, 0x0040 },    /* R1153  - Class W ANC Threshold 2 */
 	{ 0x00000490, 0x0069 },    /* R1168  - PDM SPK1 CTRL 1 */
-- 
1.7.2.5

