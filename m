Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaDDGlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:41:01 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35220 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaDDGkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:40:17 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 05/36] hrtimer: Coalesce format fragments in printk()
Date: Fri,  4 Apr 2014 12:05:48 +0530
Message-Id: <c89e8f824ae9cb8b932e0d630cd9eb8cd88adbba.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Breaking format fragments into multiple lines hits readability of code. Even if
it goes over 80 column width, its better to keep them together.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 514b53a..4843238 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -694,8 +694,8 @@ static int hrtimer_switch_to_hres(void)
 
 	if (tick_init_highres()) {
 		local_irq_restore(flags);
-		printk(KERN_WARNING "Could not switch to high resolution "
-				    "mode on CPU %d\n", cpu);
+		printk(KERN_WARNING "Could not switch to high resolution mode on CPU %d\n",
+			cpu);
 		return 0;
 	}
 	base->hres_active = 1;
-- 
1.7.12.rc2.18.g61b472e

