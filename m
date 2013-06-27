Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3F0JDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:03:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab3F0JDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:03:47 -0400
Date: Thu, 27 Jun 2013 02:03:34 -0700
From: tip-bot for Kamalesh Babulal <tipbot@zytor.com>
Message-ID: <tip-239003ea2e30374d1cdfee788867e497cca2366c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kamalesh@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20130627060409.GB18582@linux.vnet.ibm.com>
References: <20130627060409.GB18582@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Fix typo in struct sched_avg member description
Git-Commit-ID: 239003ea2e30374d1cdfee788867e497cca2366c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:03:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  239003ea2e30374d1cdfee788867e497cca2366c
Gitweb:     http://git.kernel.org/tip/239003ea2e30374d1cdfee788867e497cca2366c
Author:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
AuthorDate: Thu, 27 Jun 2013 11:34:09 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:18:26 +0200

sched: Fix typo in struct sched_avg member description

Remove extra 'for' from the description about member of
struct sched_avg.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: pjt@google.com
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/20130627060409.GB18582@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0019bef..ec80684 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -924,7 +924,7 @@ struct load_weight {
 struct sched_avg {
 	/*
 	 * These sums represent an infinite geometric series and so are bound
-	 * above by 1024/(1-y).  Thus we only need a u32 to store them for for all
+	 * above by 1024/(1-y).  Thus we only need a u32 to store them for all
 	 * choices of y < 1-2^(-32)*1024.
 	 */
 	u32 runnable_avg_sum, runnable_avg_period;
