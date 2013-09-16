Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3IPPmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:42:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49077 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025Ab3IPPma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:42:30 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Update volatile registers for WM5110 DSP
Date: Mon, 16 Sep 2013 16:31:54 +0100
Message-Id: <1379345514-2998-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 2a79723..92c6ea6 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -2334,20 +2334,34 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_AOD_IRQ2:
 	case ARIZONA_ASRC_STATUS:
 	case ARIZONA_DSP_STATUS:
-	case ARIZONA_DSP1_CONTROL_1:
-	case ARIZONA_DSP1_CLOCKING_1:
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
 	case ARIZONA_DSP1_STATUS_3:
+	case ARIZONA_DSP1_SCRATCH_0:
+	case ARIZONA_DSP1_SCRATCH_1:
+	case ARIZONA_DSP1_SCRATCH_2:
+	case ARIZONA_DSP1_SCRATCH_3:
 	case ARIZONA_DSP2_STATUS_1:
 	case ARIZONA_DSP2_STATUS_2:
 	case ARIZONA_DSP2_STATUS_3:
+	case ARIZONA_DSP2_SCRATCH_0:
+	case ARIZONA_DSP2_SCRATCH_1:
+	case ARIZONA_DSP2_SCRATCH_2:
+	case ARIZONA_DSP2_SCRATCH_3:
 	case ARIZONA_DSP3_STATUS_1:
 	case ARIZONA_DSP3_STATUS_2:
 	case ARIZONA_DSP3_STATUS_3:
+	case ARIZONA_DSP3_SCRATCH_0:
+	case ARIZONA_DSP3_SCRATCH_1:
+	case ARIZONA_DSP3_SCRATCH_2:
+	case ARIZONA_DSP3_SCRATCH_3:
 	case ARIZONA_DSP4_STATUS_1:
 	case ARIZONA_DSP4_STATUS_2:
 	case ARIZONA_DSP4_STATUS_3:
+	case ARIZONA_DSP4_SCRATCH_0:
+	case ARIZONA_DSP4_SCRATCH_1:
+	case ARIZONA_DSP4_SCRATCH_2:
+	case ARIZONA_DSP4_SCRATCH_3:
 		return true;
 	default:
 		return false;
-- 
1.7.2.5

