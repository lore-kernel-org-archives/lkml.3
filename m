Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3JECTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 22:19:01 -0400
Received: from mail-ye0-f178.google.com ([209.85.213.178]:39778 "EHLO
	mail-ye0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab3JECTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 22:19:00 -0400
From: Fabio Estevam <festevam@gmail.com>
To: benh@kernel.crashing.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] irq: irqdomain: Include <linux/of_irq.h>
Date: Fri,  4 Oct 2013 23:18:46 -0300
Message-Id: <1380939526-17619-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the following sparse warning:

kernel/irq/irqdomain.c:468:14: warning: symbol 'irq_create_of_mapping' was not declared. Should it be static?

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 kernel/irq/irqdomain.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 706724e..37cc657 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -10,6 +10,7 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/topology.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-- 
1.8.1.2

