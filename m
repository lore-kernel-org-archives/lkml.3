Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3HEJTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:19:04 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55053 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3HEJTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:19:00 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 2/2] extcon: max77693: Fix checkpatch warning
Date: Mon,  5 Aug 2013 14:32:04 +0530
Message-Id: <1375693324-30782-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375693324-30782-1-git-send-email-sachin.kamat@linaro.org>
References: <1375693324-30782-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following warning:
WARNING: space prohibited before semicolon

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max77693.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index b56bdaa..4849ea1 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -953,7 +953,7 @@ static void max77693_muic_irq_work(struct work_struct *work)
 
 	mutex_lock(&info->mutex);
 
-	for (i = 0 ; i < ARRAY_SIZE(muic_irqs) ; i++)
+	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++)
 		if (info->irq == muic_irqs[i].virq)
 			irq_type = muic_irqs[i].irq;
 
@@ -1188,7 +1188,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 		num_init_data = ARRAY_SIZE(default_init_data);
 	}
 
-	for (i = 0 ; i < num_init_data ; i++) {
+	for (i = 0; i < num_init_data; i++) {
 		enum max77693_irq_source irq_src
 				= MAX77693_IRQ_GROUP_NR;
 
-- 
1.7.9.5

