Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431Ab3JPI6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:58:11 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60868 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760359Ab3JPI6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:58:04 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org, sameo@linux.intel.com
Subject: [PATCH 7/9] mfd: tps6586x: Include linux/of.h header
Date: Wed, 16 Oct 2013 14:26:54 +0530
Message-Id: <1381913816-26730-7-git-send-email-sachin.kamat@linaro.org>
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
 drivers/mfd/tps6586x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 68906b1..ee61fd7 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -26,6 +26,7 @@
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <linux/of.h>
 
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps6586x.h>
-- 
1.7.9.5

