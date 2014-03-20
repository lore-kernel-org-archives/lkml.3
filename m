Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbaCTLjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:39:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49092 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbaCTLjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:39:48 -0400
Date: Thu, 20 Mar 2014 04:39:37 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-e2e680fb7566880f7210cadf628c092c0433971c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <1db1a3cfbe8a9ea49396af75c6ac04a2e67e3ab0.1395226248.git.viresh.kumar@linaro.org>
References: <1db1a3cfbe8a9ea49396af75c6ac04a2e67e3ab0.1395226248.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] hrtimer:
  Rearrange comments in the order struct members are declared
Git-Commit-ID: e2e680fb7566880f7210cadf628c092c0433971c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2e680fb7566880f7210cadf628c092c0433971c
Gitweb:     http://git.kernel.org/tip/e2e680fb7566880f7210cadf628c092c0433971c
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Wed, 19 Mar 2014 16:21:33 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 20 Mar 2014 12:35:45 +0100

hrtimer: Rearrange comments in the order struct members are declared

Rearrange kernel doc comments in the order members of struct hrtimer are
declared.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: fweisbec@gmail.com
Cc: trivial@kernel.org
Link: http://lkml.kernel.org/r/1db1a3cfbe8a9ea49396af75c6ac04a2e67e3ab0.1395226248.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index d19a5c2..e7a8d3f 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -96,12 +96,12 @@ enum hrtimer_restart {
  * @function:	timer expiry callback function
  * @base:	pointer to the timer base (per cpu and per clock)
  * @state:	state information (See bit values above)
+ * @start_pid: timer statistics field to store the pid of the task which
+ *		started the timer
  * @start_site:	timer statistics field to store the site where the timer
  *		was started
  * @start_comm: timer statistics field to store the name of the process which
  *		started the timer
- * @start_pid: timer statistics field to store the pid of the task which
- *		started the timer
  *
  * The hrtimer structure must be initialized by hrtimer_init()
  */
