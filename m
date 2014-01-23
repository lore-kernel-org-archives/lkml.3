Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaAWTZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:25:02 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:47322 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752899AbaAWTY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:24:59 -0500
From: Feng Kan <fkan@apm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V4 4/5] arm64: Select reboot driver for X-Gene platform
Date: Thu, 23 Jan 2014 11:20:00 -0800
Message-Id: <1390504801-24483-5-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1390504801-24483-1-git-send-email-fkan@apm.com>
References: <1390504801-24483-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select reboot driver for X-Gene platform.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index dd4327f..f43820f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -123,6 +123,8 @@ config ARCH_VEXPRESS
 
 config ARCH_XGENE
 	bool "AppliedMicro X-Gene SOC Family"
+	select MFD_SYSCON
+	select POWER_RESET_SYSCON
 	help
 	  This enables support for AppliedMicro X-Gene SOC Family
 
-- 
1.7.6.1

