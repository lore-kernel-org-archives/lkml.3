Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbaCTQ6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:58:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55547 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757894AbaCTQ6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:58:02 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mfd: wm5110: Correct default for HEADPHONE_DETECT_1
Date: Thu, 20 Mar 2014 16:49:23 +0000
Message-Id: <1395334164-3012-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index ca99685..178e041 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -538,7 +538,7 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x00000219, 0x01A6 },    /* R537   - Mic Bias Ctrl 2 */
 	{ 0x0000021A, 0x01A6 },    /* R538   - Mic Bias Ctrl 3 */
 	{ 0x00000293, 0x0000 },    /* R659   - Accessory Detect Mode 1 */
-	{ 0x0000029B, 0x0020 },    /* R667   - Headphone Detect 1 */
+	{ 0x0000029B, 0x0028 },    /* R667   - Headphone Detect 1 */
 	{ 0x0000029C, 0x0000 },    /* R668   - Headphone Detect 2 */
 	{ 0x000002A2, 0x0000 },    /* R674   - Micd clamp control */
 	{ 0x000002A3, 0x1102 },    /* R675   - Mic Detect 1 */
-- 
1.7.2.5

