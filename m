Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3KSJWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:22:16 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:50515 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3KSJWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:22:13 -0500
From: Alex Shi <alex.shi@linaro.org>
To: peterz@infradead.org, mingo@redhat.com
Cc: Morten.Rasmussen@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Alex Shi <alex.shi@linaro.org>
Subject: [PATCH] sched: remove unused variable in sched_domain
Date: Tue, 19 Nov 2013 17:21:52 +0800
Message-Id: <1384852912-24791-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'u64 last_update' variable isn't used now, remove it to save a
bit space.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 include/linux/sched.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6f7ffa4..ac68802 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -831,8 +831,6 @@ struct sched_domain {
 	unsigned int balance_interval;	/* initialise to 1. units in ms. */
 	unsigned int nr_balance_failed; /* initialise to 0 */
 
-	u64 last_update;
-
 	/* idle_balance() stats */
 	u64 max_newidle_lb_cost;
 	unsigned long next_decay_max_lb_cost;
-- 
1.8.1.2

