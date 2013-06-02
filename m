Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3FBGkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 02:40:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35537 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3FBGjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 02:39:47 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv2 1/6] ARM: sched_clock: Remove unused needs_suspend member
Date: Sat,  1 Jun 2013 23:39:38 -0700
Message-Id: <1370155183-31421-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The needs_suspend member is unused now that we always do the
suspend/resume handling (see 6a4dae5 (ARM: 7565/1: sched: stop
sched_clock() during suspend, 2012-10-23)).

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/sched_clock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index e8edcaa..45efe86 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -24,7 +24,6 @@ struct clock_data {
 	u32 mult;
 	u32 shift;
 	bool suspended;
-	bool needs_suspend;
 };
 
 static void sched_clock_poll(unsigned long wrap_ticks);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

