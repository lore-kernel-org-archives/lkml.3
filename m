Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab3JRBNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 21:13:51 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:50196 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3JRBNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 21:13:50 -0400
Message-ID: <52608B3A.7050808@huawei.com>
Date: Fri, 18 Oct 2013 09:13:30 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiri Kosina <trivial@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] timekeeping: Fix some trivial typos in comments
References: <52608AB1.1010307@huawei.com>
In-Reply-To: <52608AB1.1010307@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 kernel/time/timekeeping.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 947ba25..3abf534 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1613,9 +1613,10 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
  * ktime_get_update_offsets - hrtimer helper
  * @offs_real:	pointer to storage for monotonic -> realtime offset
  * @offs_boot:	pointer to storage for monotonic -> boottime offset
+ * @offs_tai:	pointer to storage for monotonic -> clock tai offset
  *
  * Returns current monotonic time and updates the offsets
- * Called from hrtimer_interupt() or retrigger_next_event()
+ * Called from hrtimer_interrupt() or retrigger_next_event()
  */
 ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
 							ktime_t *offs_tai)
-- 
1.7.7



