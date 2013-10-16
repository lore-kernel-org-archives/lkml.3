Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490Ab3JPJBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:01:11 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47432 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760099Ab3JPI54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:57:56 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org, sameo@linux.intel.com
Subject: [PATCH 4/9] mfd: max8997: Include linux/of.h header
Date: Wed, 16 Oct 2013 14:26:51 +0530
Message-Id: <1381913816-26730-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381913816-26730-1-git-send-email-sachin.kamat@linaro.org>
References: <1381913816-26730-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'of_match_ptr' is defined in linux/of.h. Include it explicitly to
avoid breakage in the future.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/max8997.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index cee098c..791aea3 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/interrupt.h>
 #include <linux/pm_runtime.h>
-- 
1.7.9.5

