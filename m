Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbaGWFOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:14:01 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:48937 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061AbaGWFKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:10:45 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 03/16] rcu: Fix comment for gp_state field values
Date: Wed, 23 Jul 2014 01:09:40 -0400
Message-Id: <1406092194-13004-4-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment in the code states that the values are for gp_flags field, when the
values are actually for gp_state field. This commit fixes the inconsistency.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index f703ea8..9643f10 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -498,7 +498,7 @@ struct rcu_state {
 #define RCU_GP_FLAG_INIT 0x1	/* Need grace-period initialization. */
 #define RCU_GP_FLAG_FQS  0x2	/* Need grace-period quiescent-state forcing. */
 
-/* Values for rcu_state structure's gp_flags field. */
+/* Values for rcu_state structure's gp_state field. */
 #define RCU_GP_WAIT_INIT 0	/* Initial state. */
 #define RCU_GP_WAIT_GPS  1	/* Wait for grace-period start. */
 #define RCU_GP_WAIT_FQS  2	/* Wait for force-quiescent-state time. */
-- 
2.0.0.rc2

