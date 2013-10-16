Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399Ab3JPI6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:58:09 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44027 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760360Ab3JPI6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:58:06 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org, sameo@linux.intel.com
Subject: [PATCH 8/9] mfd: tps65910: Include linux/of.h header
Date: Wed, 16 Oct 2013 14:26:55 +0530
Message-Id: <1381913816-26730-8-git-send-email-sachin.kamat@linaro.org>
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
 drivers/mfd/tps65910.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 78ffe6e..c0f608e 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -25,6 +25,7 @@
 #include <linux/mfd/core.h>
 #include <linux/regmap.h>
 #include <linux/mfd/tps65910.h>
+#include <linux/of.h>
 #include <linux/of_device.h>
 
 static struct resource rtc_resources[] = {
-- 
1.7.9.5

