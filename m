Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3JRKm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 06:42:59 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:46578 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab3JRKm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 06:42:57 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org,
        "SangYoung, Son" <hello.son@samsung.com>
Subject: [PATCH 1/1] mfd: max77693: Include linux/of.h header
Date: Fri, 18 Oct 2013 16:11:57 +0530
Message-Id: <1382092917-31252-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'of_match_ptr' is defined in linux/of.h. Include it explicitly to
avoid build breakage in the future.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: SangYoung, Son <hello.son@samsung.com>
---
 drivers/mfd/max77693.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 4d81ed2..9f92463 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -28,6 +28,7 @@
 #include <linux/i2c.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
+#include <linux/of.h>
 #include <linux/pm_runtime.h>
 #include <linux/mutex.h>
 #include <linux/mfd/core.h>
-- 
1.7.9.5

