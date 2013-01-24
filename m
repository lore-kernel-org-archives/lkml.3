Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab3AXPAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:00:31 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45098 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3AXPA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:00:29 -0500
From: Jiang Fang <jiang.xx.fang@gmail.com>
To: dipankar@in.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] rcu: indent: fix leading space
Date: Thu, 24 Jan 2013 23:00:17 +0800
Message-Id: <1359039617-6472-1-git-send-email-jiang.xx.fang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jiang Fang <jiang.xx.fang@gmail.com>
---
 kernel/rcutree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e441b77..dbf7d7f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -3064,7 +3064,7 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
 	rcu_init_nocb();
-	 open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
-- 
1.7.9.5

