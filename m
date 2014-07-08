Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaGHW2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:28:50 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:33167 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaGHW0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:26:11 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 2/9] rcu: use bool type for return value in rcu_is_watching()
Date: Tue,  8 Jul 2014 18:26:11 -0400
Message-Id: <1404858378-23806-3-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
References: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use a bool type for return in rcu_is_watching()

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index dac6d20..dff3d5b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -819,7 +819,7 @@ bool notrace __rcu_is_watching(void)
  */
 bool notrace rcu_is_watching(void)
 {
-	int ret;
+	bool ret;
 
 	preempt_disable();
 	ret = __rcu_is_watching();
-- 
1.9.1

