Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab3K1I3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:29:31 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:32479 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3K1I33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:29:29 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH] timekeeper: fix comment typo for tk_setup_internals()
Date: Thu, 28 Nov 2013 16:28:55 +0800
Message-ID: <1385627335-20896-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trivial comment typo for tk_setup_internals().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 kernel/time/timekeeping.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 3abf534..5c02cf9 100644
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
1.7.1


