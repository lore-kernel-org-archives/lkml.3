Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaHACpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 22:45:42 -0400
Received: from exprod5og125.obsmtp.com ([64.18.0.245]:49791 "HELO
	exprod5og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753660AbaHACpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 22:45:11 -0400
From: Feng Kan <fkan@apm.com>
To: linux@roeck-us.net, dbaryshkov@gmail.com, catalin.marinas@arm.com,
        dwmw2@infradead.org, arnd@arndb.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@apm.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V9 5/6] arm64: Select reboot driver for X-Gene platform
Date: Thu, 31 Jul 2014 19:45:56 -0700
Message-Id: <1406861157-29169-6-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406861157-29169-1-git-send-email-fkan@apm.com>
References: <1406861157-29169-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select reboot driver for X-Gene platform.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 839f48c..df6a646 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -141,6 +141,8 @@ config ARCH_VEXPRESS
 
 config ARCH_XGENE
 	bool "AppliedMicro X-Gene SOC Family"
+	select MFD_SYSCON
+	select POWER_RESET_SYSCON
 	help
 	  This enables support for AppliedMicro X-Gene SOC Family
 
-- 
1.9.1

