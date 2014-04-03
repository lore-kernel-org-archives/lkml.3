Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaDCLRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:17:41 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42404 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaDCLRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:17:39 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH] ARM64: Remove duplicated Kconfig entry for "kernel/power/Kconfig"
Date: Thu,  3 Apr 2014 19:16:49 +0800
Message-Id: <1396523809-6945-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a duplicated Kconfig entry for "kernel/power/Kconfig"
in menu "Power management options" and "CPU Power Management",
remove the one from menu "CPU Power Management" suggested by
Viresh.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/Kconfig |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e6e4d37..e759af5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -323,8 +323,6 @@ menu "CPU Power Management"
 
 source "drivers/cpuidle/Kconfig"
 
-source "kernel/power/Kconfig"
-
 source "drivers/cpufreq/Kconfig"
 
 endmenu
-- 
1.7.9.5

