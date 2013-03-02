Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab3CBJIt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 04:08:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53401 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab3CBJIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 04:08:44 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm5102: Update rev B patch for latest evaluation
Date: Sat,  2 Mar 2013 17:08:02 +0800
Message-Id: <1362215282-14282-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 4a1cdc4..eee0306 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -66,6 +66,7 @@ static const struct reg_default wm5102_revb_patch[] = {
 	{ 0x4B0, 0x0066 },
 	{ 0x458, 0x000b },
 	{ 0x212, 0x0000 },
+	{ 0x171, 0x0000 },
 	{ 0x80, 0x0000 },
 };
 
@@ -282,7 +283,7 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000155, 0x0000 },   /* R341   - Rate Estimator 4 */ 
 	{ 0x00000156, 0x0000 },   /* R342   - Rate Estimator 5 */ 
 	{ 0x00000161, 0x0000 },   /* R353   - Dynamic Frequency Scaling 1 */ 
-	{ 0x00000171, 0x0002 },   /* R369   - FLL1 Control 1 */
+	{ 0x00000171, 0x0000 },   /* R369   - FLL1 Control 1 */
 	{ 0x00000172, 0x0008 },   /* R370   - FLL1 Control 2 */ 
 	{ 0x00000173, 0x0018 },   /* R371   - FLL1 Control 3 */ 
 	{ 0x00000174, 0x007D },   /* R372   - FLL1 Control 4 */ 
-- 
1.7.10.4

