Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaBLJQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:16:19 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:41897 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaBLJPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:15:30 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 2/4] mfd: max14577: Include missing err.h
Date: Wed, 12 Feb 2014 14:40:11 +0530
Message-Id: <1392196213-20576-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392196213-20576-1-git-send-email-sachin.kamat@linaro.org>
References: <1392196213-20576-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add this header explicitly for IS_ERR and friends.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/max14577.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 2ac2f2d7cea6..88cf5811ce3b 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -18,6 +18,7 @@
  * This driver is based on max8997.c
  */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/core.h>
-- 
1.7.9.5

