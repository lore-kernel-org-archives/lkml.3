Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132Ab3CMTVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:21:47 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:43558 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933162Ab3CMTVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:21:46 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Jiri Kosina <trivial@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH] hrtimer/trivial: Fix comment text in hrtimer.c
Date: Wed, 13 Mar 2013 12:20:38 -0700
Message-Id: <1363202438-21234-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The comments mention HRTIMER_ABS and HRTIMER_REL, these symbols don't
exist, the proper names are HRTIMER_MODE_ABS and HRTIMER_MODE_REL.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 kernel/hrtimer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..f749bb9 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1008,7 +1008,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
  * @timer:	the timer to be added
  * @tim:	expiry time
  * @delta_ns:	"slack" range for the timer
- * @mode:	expiry mode: absolute (HRTIMER_ABS) or relative (HRTIMER_REL)
+ * @mode:	expiry mode: absolute (HRTIMER_MODE_ABS) or
+ *		relative (HRTIMER_MODE_REL)
  *
  * Returns:
  *  0 on success
@@ -1025,7 +1026,8 @@ EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
  * hrtimer_start - (re)start an hrtimer on the current CPU
  * @timer:	the timer to be added
  * @tim:	expiry time
- * @mode:	expiry mode: absolute (HRTIMER_ABS) or relative (HRTIMER_REL)
+ * @mode:	expiry mode: absolute (HRTIMER_MODE_ABS) or
+ *		relative (HRTIMER_MODE_REL)
  *
  * Returns:
  *  0 on success
-- 
1.7.11.7

