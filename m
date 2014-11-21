Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaKUTot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:44:49 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34797 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaKUTop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:44:45 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd.bergmann@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 09/12] time: Fixup comments to reflect usage of timespec64
Date: Fri, 21 Nov 2014 11:44:15 -0800
Message-Id: <1416599058-13836-10-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up a few comments that weren't updated when the
functions were converted to use timespec64 structures.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 62440b1..14c6270 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -519,9 +519,9 @@ EXPORT_SYMBOL(__getnstimeofday64);
 
 /**
  * getnstimeofday64 - Returns the time of day in a timespec64.
- * @ts:		pointer to the timespec to be set
+ * @ts:		pointer to the timespec64 to be set
  *
- * Returns the time of day in a timespec (WARN if suspended).
+ * Returns the time of day in a timespec64 (WARN if suspended).
  */
 void getnstimeofday64(struct timespec64 *ts)
 {
@@ -623,7 +623,7 @@ EXPORT_SYMBOL_GPL(ktime_get_raw);
  *
  * The function calculates the monotonic clock from the realtime
  * clock and the wall_to_monotonic offset and stores the result
- * in normalized timespec format in the variable pointed to by @ts.
+ * in normalized timespec64 format in the variable pointed to by @ts.
  */
 void ktime_get_ts64(struct timespec64 *ts)
 {
-- 
1.9.1

