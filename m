Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3CYJ65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:58:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41562 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3CYJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:58:54 -0400
Date: Mon, 25 Mar 2013 02:57:39 -0700
From: tip-bot for David Daney <tipbot@zytor.com>
Message-ID: <tip-8ffbc7d9ff0064ce000788272a609fa79d06ead1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        trivial@kernel.org, ddaney.cavm@gmail.com, david.daney@cavium.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        trivial@kernel.org, ddaney.cavm@gmail.com, david.daney@cavium.com,
        tglx@linutronix.de
In-Reply-To: <1363202438-21234-1-git-send-email-ddaney.cavm@gmail.com>
References: <1363202438-21234-1-git-send-email-ddaney.cavm@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] hrtimer/trivial: Fix comment text in hrtimer.c
Git-Commit-ID: 8ffbc7d9ff0064ce000788272a609fa79d06ead1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 25 Mar 2013 02:57:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ffbc7d9ff0064ce000788272a609fa79d06ead1
Gitweb:     http://git.kernel.org/tip/8ffbc7d9ff0064ce000788272a609fa79d06ead1
Author:     David Daney <ddaney.cavm@gmail.com>
AuthorDate: Wed, 13 Mar 2013 12:20:38 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 25 Mar 2013 10:46:59 +0100

hrtimer/trivial: Fix comment text in hrtimer.c

The comments mention HRTIMER_ABS and HRTIMER_REL, these symbols don't
exist, the proper names are HRTIMER_MODE_ABS and HRTIMER_MODE_REL.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Jiri Kosina <trivial@kernel.org>
Link: http://lkml.kernel.org/r/1363202438-21234-1-git-send-email-ddaney.cavm@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/hrtimer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cc47812..031184e 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1010,7 +1010,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
  * @timer:	the timer to be added
  * @tim:	expiry time
  * @delta_ns:	"slack" range for the timer
- * @mode:	expiry mode: absolute (HRTIMER_ABS) or relative (HRTIMER_REL)
+ * @mode:	expiry mode: absolute (HRTIMER_MODE_ABS) or
+ *		relative (HRTIMER_MODE_REL)
  *
  * Returns:
  *  0 on success
@@ -1027,7 +1028,8 @@ EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
  * hrtimer_start - (re)start an hrtimer on the current CPU
  * @timer:	the timer to be added
  * @tim:	expiry time
- * @mode:	expiry mode: absolute (HRTIMER_ABS) or relative (HRTIMER_REL)
+ * @mode:	expiry mode: absolute (HRTIMER_MODE_ABS) or
+ *		relative (HRTIMER_MODE_REL)
  *
  * Returns:
  *  0 on success
