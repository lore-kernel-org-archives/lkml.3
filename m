Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbaCSKvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:51:55 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57246 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602AbaCSKvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:51:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, trivial@kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] hrtimer: rearrange comments in the order struct members are declared
Date: Wed, 19 Mar 2014 16:21:33 +0530
Message-Id: <1db1a3cfbe8a9ea49396af75c6ac04a2e67e3ab0.1395226248.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange kernel doc comments in the order members of struct hrtimer are
declared.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
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
-- 
1.7.12.rc2.18.g61b472e

