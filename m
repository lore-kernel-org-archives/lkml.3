Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab3FMMVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:21:55 -0400
Received: from multi.imgtec.com ([194.200.65.239]:31966 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab3FMMVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:21:30 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 03/10] metag/kernel/irq.c: Declare root_domain as static
Date: Thu, 13 Jun 2013 13:19:34 +0100
Message-ID: <1371125981-5184-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
References: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_13_13_21_25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markos Chandras <markos.chandras@imgtec.com>

It is only referenced within the irq.c file, so restrict it's scope
as appropriate.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/metag/kernel/irq.c b/arch/metag/kernel/irq.c
index 87707ef..d91b1e9 100644
--- a/arch/metag/kernel/irq.c
+++ b/arch/metag/kernel/irq.c
@@ -25,7 +25,7 @@ static union irq_ctx *hardirq_ctx[NR_CPUS] __read_mostly;
 static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
 #endif
 
-struct irq_domain *root_domain;
+static struct irq_domain *root_domain;
 
 static unsigned int startup_meta_irq(struct irq_data *data)
 {
-- 
1.8.1.2


