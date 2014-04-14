Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaDNBkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:40:13 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:44647 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaDNBkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAJhHMCCE0QHvzqrdY-w8bB8ZK=JRN02V29XwaFYRXmu=9RhG9Q@mail.gmail.com>
References: <CAJhHMCCE0QHvzqrdY-w8bB8ZK=JRN02V29XwaFYRXmu=9RhG9Q@mail.gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 13 Apr 2014 21:39:39 -0400
Message-ID: <CAJhHMCCgMgL2etE8sYPgUfy+OXcyxG6_X1v1OhUxzX5c0kaZ4w@mail.gmail.com>
Subject: [PATCH 1/1] kernel/rcu/tree.c: remove duplicate extern definition
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 0c47e30..67e850a 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -947,12 +947,6 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
     force_quiescent_state(rsp);  /* Kick them all. */
 }

-/*
- * This function really isn't for public consumption, but RCU is special in
- * that context switches can allow the state machine to make progress.
- */
-extern void resched_cpu(int cpu);
-
 static void print_cpu_stall(struct rcu_state *rsp)
 {
     int cpu;
--
1.7.9.5

-- 
Pranith
