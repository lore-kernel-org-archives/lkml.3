Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaDOLkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:40:18 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:65116 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaDOLkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:40:17 -0400
Message-ID: <1397562009.24265.1.camel@phoenix>
Subject: [PATCH] mfd: tps65218: Remove unused *rdev[] from struct tps65218
From: Axel Lin <axel.lin@ingics.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Keerthy <j-keerthy@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Apr 2014 19:40:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *rdev[] is not used since commit 413be59e2f333
"regulator: tps65218: Remove unnecessary regulator_unregister call".

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 include/linux/mfd/tps65218.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/mfd/tps65218.h b/include/linux/mfd/tps65218.h
index d2e357d..2f9b593 100644
--- a/include/linux/mfd/tps65218.h
+++ b/include/linux/mfd/tps65218.h
@@ -267,7 +267,6 @@ struct tps65218 {
 	u32 irq_mask;
 	struct regmap_irq_chip_data *irq_data;
 	struct regulator_desc desc[TPS65218_NUM_REGULATOR];
-	struct regulator_dev *rdev[TPS65218_NUM_REGULATOR];
 	struct tps_info *info[TPS65218_NUM_REGULATOR];
 	struct regmap *regmap;
 };
-- 
1.8.3.2



