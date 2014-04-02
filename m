Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbaDBKgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:36:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50956 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758192AbaDBKgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:36:43 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 RESEND] mfd: wm8997: Add registers for high power mode
Date: Wed,  2 Apr 2014 11:27:50 +0100
Message-Id: <1396434470-28662-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1396434470-28662-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1396434470-28662-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some output configurations can require a 50Mhz SYSCLK which requires
DCVDD to be 1.8V. This patch adds the registers necessary for
supporting this operational mode.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8997-tables.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8997-tables.c b/drivers/mfd/wm8997-tables.c
index 5aa8076..c9c6519 100644
--- a/drivers/mfd/wm8997-tables.c
+++ b/drivers/mfd/wm8997-tables.c
@@ -846,6 +846,7 @@ static bool wm8997_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_RATE_ESTIMATOR_3:
 	case ARIZONA_RATE_ESTIMATOR_4:
 	case ARIZONA_RATE_ESTIMATOR_5:
+	case ARIZONA_DYNAMIC_FREQUENCY_SCALING_1:
 	case ARIZONA_FLL1_CONTROL_1:
 	case ARIZONA_FLL1_CONTROL_2:
 	case ARIZONA_FLL1_CONTROL_3:
@@ -880,6 +881,7 @@ static bool wm8997_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_FLL2_GPIO_CLOCK:
 	case ARIZONA_MIC_CHARGE_PUMP_1:
 	case ARIZONA_LDO1_CONTROL_1:
+	case ARIZONA_LDO1_CONTROL_2:
 	case ARIZONA_LDO2_CONTROL_1:
 	case ARIZONA_MIC_BIAS_CTRL_1:
 	case ARIZONA_MIC_BIAS_CTRL_2:
-- 
1.7.2.5

