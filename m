Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123Ab3LHWyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 17:54:33 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:59333 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760024Ab3LHWy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 17:54:27 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Daniel Mack <zonque@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 4/9] ARM: pxa: remove unused variable
Date: Mon,  9 Dec 2013 02:53:44 +0400
Message-Id: <1386543229-1542-5-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
 <1386543229-1542-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Daniel Mack <zonque@gmail.com>
---
 arch/arm/mach-pxa/irq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
index b6cc181..432842c 100644
--- a/arch/arm/mach-pxa/irq.c
+++ b/arch/arm/mach-pxa/irq.c
@@ -236,7 +236,6 @@ void __init pxa_dt_irq_init(int (*fn)(struct irq_data *, unsigned int))
 {
 	struct device_node *node;
 	const struct of_device_id *of_id;
-	struct pxa_intc_conf *conf;
 	struct resource res;
 	int n, ret;
 
@@ -246,7 +245,6 @@ void __init pxa_dt_irq_init(int (*fn)(struct irq_data *, unsigned int))
 		return;
 	}
 	of_id = of_match_node(intc_ids, node);
-	conf = of_id->data;
 
 	ret = of_property_read_u32(node, "marvell,intc-nr-irqs",
 				   &pxa_internal_irq_nr);
-- 
1.8.4.3

