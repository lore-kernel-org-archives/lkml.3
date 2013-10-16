Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589Ab3JPJBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:01:13 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39443 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760078Ab3JPI5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:57:52 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org, sameo@linux.intel.com
Subject: [PATCH 2/9] mfd: max77686: Include linux/of.h header
Date: Wed, 16 Oct 2013 14:26:49 +0530
Message-Id: <1381913816-26730-2-git-send-email-sachin.kamat@linaro.org>
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
 drivers/mfd/max77686.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 522be67..34520cb 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -31,6 +31,7 @@
 #include <linux/mfd/max77686.h>
 #include <linux/mfd/max77686-private.h>
 #include <linux/err.h>
+#include <linux/of.h>
 
 #define I2C_ADDR_RTC	(0x0C >> 1)
 
-- 
1.7.9.5

