Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab3DARar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:30:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47082 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756986Ab3DAR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 07/15] mfd: wm5102: Update patch for latest evaluation
Date: Mon,  1 Apr 2013 18:28:04 +0100
Message-Id: <1364837292-30191-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index a433f58..909e043 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -57,15 +57,20 @@ static const struct reg_default wm5102_reva_patch[] = {
 };
 
 static const struct reg_default wm5102_revb_patch[] = {
+	{ 0x19, 0x0001 },
 	{ 0x80, 0x0003 },
 	{ 0x081, 0xE022 },
-	{ 0x410, 0x4080 },
-	{ 0x418, 0x4080 },
-	{ 0x420, 0x4080 },
-	{ 0x428, 0xC000 },
+	{ 0x410, 0x6080 },
+	{ 0x418, 0xa080 },
+	{ 0x420, 0xa080 },
+	{ 0x428, 0xe000 },
+	{ 0x443, 0xDC1A },
 	{ 0x4B0, 0x0066 },
 	{ 0x458, 0x000b },
 	{ 0x212, 0x0000 },
+	{ 0x171, 0x0000 },
+	{ 0x35E, 0x000C },
+	{ 0x2D4, 0x0000 },
 	{ 0x80, 0x0000 },
 };
 
@@ -282,7 +287,7 @@ static const struct reg_default wm5102_reg_default[] = {
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

