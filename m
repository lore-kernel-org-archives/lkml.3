Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab3BKUyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:54:32 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:34801 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab3BKUyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:54:31 -0500
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Dong Aisheng <dong.aisheng@linaro.org>
Subject: [PATCH 1/2] mfd: syscon: Fix sparse warning
Date: Mon, 11 Feb 2013 18:48:00 -0200
Message-Id: <1360615681-19909-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the following sparse warnings:

drivers/mfd/syscon.c:40:15: warning: symbol 'syscon_node_to_regmap' was not declared. Should it be static?
drivers/mfd/syscon.c:56:15: warning: symbol 'syscon_regmap_lookup_by_compatible' was not declared. Should it be static?
drivers/mfd/syscon.c:72:15: warning: symbol 'syscon_regmap_lookup_by_phandle' was not declared. Should it be static?

Cc: Dong Aisheng <dong.aisheng@linaro.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/mfd/syscon.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 3f10591..61aea63 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -20,6 +20,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
 
 static struct platform_driver syscon_driver;
 
-- 
1.7.9.5

