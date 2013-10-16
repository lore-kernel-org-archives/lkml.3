Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569Ab3JPI7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:59:52 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:53745 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323Ab3JPI6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:58:02 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org, sameo@linux.intel.com
Subject: [PATCH 6/9] mfd: tps6507x: Include linux/of.h header
Date: Wed, 16 Oct 2013 14:26:53 +0530
Message-Id: <1381913816-26730-6-git-send-email-sachin.kamat@linaro.org>
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
 drivers/mfd/tps6507x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
index 5ad4b77..a081b92 100644
--- a/drivers/mfd/tps6507x.c
+++ b/drivers/mfd/tps6507x.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps6507x.h>
-- 
1.7.9.5

