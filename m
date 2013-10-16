Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316Ab3JPI57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:57:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53681 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3JPI5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:57:54 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org, sameo@linux.intel.com
Subject: [PATCH 3/9] mfd: max8907: Include linux/of.h header
Date: Wed, 16 Oct 2013 14:26:50 +0530
Message-Id: <1381913816-26730-3-git-send-email-sachin.kamat@linaro.org>
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
 drivers/mfd/max8907.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/max8907.c b/drivers/mfd/max8907.c
index e9b1c93..3bbfedc 100644
--- a/drivers/mfd/max8907.c
+++ b/drivers/mfd/max8907.c
@@ -17,6 +17,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/max8907.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
-- 
1.7.9.5

