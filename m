Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3DZMRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:17:44 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:33255 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab3DZMRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:17:42 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/5] mfd: abx500-core: fix sparse warning
Date: Fri, 26 Apr 2013 14:17:14 +0200
Message-Id: <1366978638-967-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1366978638-967-1-git-send-email-fabio.baltieri@linaro.org>
References: <1366978638-967-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning:

drivers/mfd/abx500-core.c:159:38: warning: Using plain integer as NULL pointer

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/mfd/abx500-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/abx500-core.c b/drivers/mfd/abx500-core.c
index 9818afb..3714acb 100644
--- a/drivers/mfd/abx500-core.c
+++ b/drivers/mfd/abx500-core.c
@@ -156,7 +156,7 @@ EXPORT_SYMBOL(abx500_startup_irq_enabled);
 void abx500_dump_all_banks(void)
 {
 	struct abx500_ops *ops;
-	struct device dummy_child = {0};
+	struct device dummy_child = {NULL};
 	struct abx500_device_entry *dev_entry;
 
 	list_for_each_entry(dev_entry, &abx500_list, list) {
-- 
1.8.1.3

