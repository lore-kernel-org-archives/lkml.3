Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3HEJSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:18:49 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37347 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3HEJSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:18:48 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/2] extcon: max8997: Fix checkpatch warning
Date: Mon,  5 Aug 2013 14:32:03 +0530
Message-Id: <1375693324-30782-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following warning:
WARNING: space prohibited before semicolon

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max8997.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 67d6738..e55ec38 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -537,7 +537,7 @@ static void max8997_muic_irq_work(struct work_struct *work)
 
 	mutex_lock(&info->mutex);
 
-	for (i = 0 ; i < ARRAY_SIZE(muic_irqs) ; i++)
+	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++)
 		if (info->irq == muic_irqs[i].virq)
 			irq_type = muic_irqs[i].irq;
 
-- 
1.7.9.5

