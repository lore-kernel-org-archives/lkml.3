Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab3CDXTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 18:19:22 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54780 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab3CDXTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 18:19:21 -0500
X-IronPort-AV: E=Sophos;i="4.84,783,1355126400"; 
   d="scan'208";a="27435621"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH] ARM: Scorpion is a v7 architecture, not v6
Date: Mon,  4 Mar 2013 15:19:19 -0800
Message-Id: <1362439159-29258-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.7.1.ge545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scorpion processors have always been v7 CPUs. Fix the Kconfig
text to reflect this.

Reported-by: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index dedf02b..dc3bbbc 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1006,12 +1006,12 @@ config ARCH_MULTI_V4_V5
 	bool
 
 config ARCH_MULTI_V6
-	bool "ARMv6 based platforms (ARM11, Scorpion, ...)"
+	bool "ARMv6 based platforms (ARM11)"
 	select ARCH_MULTI_V6_V7
 	select CPU_V6
 
 config ARCH_MULTI_V7
-	bool "ARMv7 based platforms (Cortex-A, PJ4, Krait)"
+	bool "ARMv7 based platforms (Cortex-A, PJ4, Scorpion, Krait)"
 	default y
 	select ARCH_MULTI_V6_V7
 	select ARCH_VEXPRESS
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

