Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3JAUs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:48:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60999 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab3JAUsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:48:53 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm64: Remove duplicate DEBUG_STACK_USAGE config
Date: Tue,  1 Oct 2013 13:48:43 -0700
Message-Id: <1380660523-19036-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.474.g128a96c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item already exists generically in lib/Kconfig.debug.
Remove the duplicate config in arm64.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm64/Kconfig.debug | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 1a6bfe9..835c5597 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -6,13 +6,6 @@ config FRAME_POINTER
 	bool
 	default y
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T output.
-
 config EARLY_PRINTK
 	bool "Early printk support"
 	default y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

