Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaABWYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:24:24 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35546 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbaABWXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:23:43 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Yijing Wang <wangyijing@huawei.com>, John Stultz <john.stultz@linaro.org>
Subject: [PATCH 7/9] timekeeper: fix comment typo for tk_setup_internals()
Date: Thu,  2 Jan 2014 14:23:25 -0800
Message-Id: <1388701407-5029-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388701407-5029-1-git-send-email-john.stultz@linaro.org>
References: <52C5E6A0.7010507@linaro.org>
 <1388701407-5029-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>

Fix trivial comment typo for tk_setup_internals().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2793c43..3ff3064 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -90,8 +90,9 @@ static void tk_set_sleep_time(struct timekeeper *tk, struct timespec t)
 }
 
 /**
- * timekeeper_setup_internals - Set up internals to use clocksource clock.
+ * tk_setup_internals - Set up internals to use clocksource clock.
  *
+ * @tk:		The target timekeeper to setup.
  * @clock:		Pointer to clocksource.
  *
  * Calculates a fixed cycle/nsec interval for a given clocksource/adjustment
-- 
1.8.3.2

