Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab3JCTtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:49:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47310 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3JCTtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:49:47 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Subject: [PATCH 2/2] ARM: Remove temporary sched_clock.h header
Date: Thu,  3 Oct 2013 12:49:43 -0700
Message-Id: <1380829783-876-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-Reply-To: <1380829783-876-1-git-send-email-sboyd@codeaurora.org>
References: <1380829783-876-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header file is no longer needed now that the ARM sched_clock
framework is generic and all users have moved to linux/sched_clock.h
instead of asm/sched_clock.h. Remove it.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/include/asm/sched_clock.h | 4 ----
 1 file changed, 4 deletions(-)
 delete mode 100644 arch/arm/include/asm/sched_clock.h

diff --git a/arch/arm/include/asm/sched_clock.h b/arch/arm/include/asm/sched_clock.h
deleted file mode 100644
index 2389b71..0000000
--- a/arch/arm/include/asm/sched_clock.h
+++ /dev/null
@@ -1,4 +0,0 @@
-/* You shouldn't include this file. Use linux/sched_clock.h instead.
- * Temporary file until all asm/sched_clock.h users are gone
- */
-#include <linux/sched_clock.h>
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

