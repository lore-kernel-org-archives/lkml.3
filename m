Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913Ab3L0FIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 00:08:45 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44833 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3L0FIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 00:08:44 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, patches@linaro.org
Subject: [PATCH] irqchip: s3c24xx: add missing comma for completeness
Date: Fri, 27 Dec 2013 10:35:13 +0530
Message-Id: <1388120713-14113-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change, adding for uniformity.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/irqchip/irq-s3c24xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-s3c24xx.c b/drivers/irqchip/irq-s3c24xx.c
index bbcc944..ee41ae2 100644
--- a/drivers/irqchip/irq-s3c24xx.c
+++ b/drivers/irqchip/irq-s3c24xx.c
@@ -270,7 +270,7 @@ static struct irq_chip s3c_irq_chip = {
 	.irq_mask	= s3c_irq_mask,
 	.irq_unmask	= s3c_irq_unmask,
 	.irq_set_type	= s3c_irq_type,
-	.irq_set_wake	= s3c_irq_wake
+	.irq_set_wake	= s3c_irq_wake,
 };
 
 static struct irq_chip s3c_irq_level_chip = {
@@ -287,7 +287,7 @@ static struct irq_chip s3c_irqext_chip = {
 	.irq_unmask	= s3c_irq_unmask,
 	.irq_ack	= s3c_irq_ack,
 	.irq_set_type	= s3c_irqext_type,
-	.irq_set_wake	= s3c_irqext_wake
+	.irq_set_wake	= s3c_irqext_wake,
 };
 
 static struct irq_chip s3c_irq_eint0t4 = {
-- 
1.7.9.5

