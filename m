Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343Ab3DTA3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 20:29:12 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47892 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965151Ab3DTA3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 20:29:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,512,1363158000"; 
   d="scan'208";a="40095501"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/4] ARM: sched_clock: Remove unused needs_suspend member
Date: Fri, 19 Apr 2013 17:29:03 -0700
Message-Id: <1366417746-24990-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1.392.g85e7e81
In-Reply-To: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
References: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
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
index 8805848..48ab64a 100644
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

