Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277Ab3JPI5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:57:53 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36866 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3JPI5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:57:50 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org, sameo@linux.intel.com
Subject: [PATCH 1/9] mfd: as3711: Include linux/of.h header
Date: Wed, 16 Oct 2013 14:26:48 +0530
Message-Id: <1381913816-26730-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'of_match_ptr' is defined in linux/of.h. Include it explicitly to
avoid breakage in the future.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/as3711.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/as3711.c b/drivers/mfd/as3711.c
index abd3ab7..ec684fc 100644
--- a/drivers/mfd/as3711.c
+++ b/drivers/mfd/as3711.c
@@ -17,6 +17,7 @@
 #include <linux/mfd/as3711.h>
 #include <linux/mfd/core.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
 
-- 
1.7.9.5

