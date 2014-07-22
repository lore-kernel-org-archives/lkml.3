Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaGVLLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:11:52 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:42795 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaGVLLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:11:50 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/19] mfd: sec-core: Fix 'missing blank line after declarations' warning
Date: Tue, 22 Jul 2014 12:11:13 +0100
Message-Id: <1406027485-15657-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

WARNING: Missing a blank line after declarations
+               const struct of_device_id *match;
+               match = of_match_node(sec_dt_match, i2c->dev.of_node);

total: 0 errors, 1 warnings, 494 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/sec-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index fb8ba64..dba7e2b 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -273,6 +273,7 @@ static inline unsigned long sec_i2c_get_driver_data(struct i2c_client *i2c,
 #ifdef CONFIG_OF
 	if (i2c->dev.of_node) {
 		const struct of_device_id *match;
+
 		match = of_match_node(sec_dt_match, i2c->dev.of_node);
 		return (unsigned long)match->data;
 	}
-- 
1.8.3.2

