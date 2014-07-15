Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756AbaGOWb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:31:28 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:50413 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaGOWb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:31:26 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 1/3] rcu: tiny.c: Update reference to tree.c
Date: Tue, 15 Jul 2014 18:31:47 -0400
Message-Id: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit updates the references to rcutree.c which is now rcu/tree.c

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tiny.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index d9efcc1..6bd785c 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -51,7 +51,7 @@ static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
 #include "tiny_plugin.h"
 
-/* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
+/* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcu/tree.c. */
 static void rcu_idle_enter_common(long long newval)
 {
 	if (newval) {
@@ -114,7 +114,7 @@ void rcu_irq_exit(void)
 }
 EXPORT_SYMBOL_GPL(rcu_irq_exit);
 
-/* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcutree.c. */
+/* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcu/tree.c. */
 static void rcu_idle_exit_common(long long oldval)
 {
 	if (oldval) {
-- 
1.9.1

