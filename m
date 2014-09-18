Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbaIRO7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:59:15 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:30289 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaIRO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:59:14 -0400
From: James Hartley <james.hartley@imgtec.com>
To: <trivial@kernel.org>
CC: <linux-kernel@vger.kernel.org>, James Hartley <james.hartley@imgtec.com>
Subject: [PATCH] clocksource: Fix 'clcoksource' typo, trivial
Date: Thu, 18 Sep 2014 15:59:07 +0100
Message-ID: <1411052347-18197-1-git-send-email-james.hartley@imgtec.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.167.60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple typo in a comment, so fix it.

Signed-off-by: James Hartley <james.hartley@imgtec.com>
---
 kernel/time/clocksource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 2e949cc..b79f39b 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -792,7 +792,7 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 	/* Initialize mult/shift and max_idle_ns */
 	__clocksource_updatefreq_scale(cs, scale, freq);
 
-	/* Add clocksource to the clcoksource list */
+	/* Add clocksource to the clocksource list */
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
 	clocksource_enqueue_watchdog(cs);
-- 
1.7.9.5

