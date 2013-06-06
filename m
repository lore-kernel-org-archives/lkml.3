Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab3FFLWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:22:41 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:50653 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533Ab3FFLWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:22:38 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: [PATCH 1/7] irq: fix checkpatch warnings
Date: Thu, 6 Jun 2013 19:20:25 +0800
Message-ID: <1370517631-8684-2-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
In-Reply-To: <1370517631-8684-1-git-send-email-wangkefeng.wang@huawei.com>
References: <1370517631-8684-1-git-send-email-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes line over 80 characters warnings.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 kernel/irq/chip.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index cbd97ce..f19865a 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -56,7 +56,8 @@ EXPORT_SYMBOL(irq_set_chip);
 int irq_set_irq_type(unsigned int irq, unsigned int type)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags,
+					IRQ_GET_DESC_CHECK_GLOBAL);
 	int ret = 0;
 
 	if (!desc)
@@ -101,7 +102,8 @@ int irq_set_msi_desc_off(unsigned int irq_base, unsigned int irq_offset,
 			 struct msi_desc *entry)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq_base + irq_offset, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+	struct irq_desc *desc = irq_get_desc_lock(irq_base + irq_offset, &flags,
+						IRQ_GET_DESC_CHECK_GLOBAL);
 
 	if (!desc)
 		return -EINVAL;
-- 
1.8.2.1


