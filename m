Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaDFKTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 06:19:18 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:53476 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180AbaDFKTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 06:19:15 -0400
Message-ID: <1396779553.30640.16.camel@x220>
Subject: [PATCH] ARM: tegra: remove TEGRA_EMC_SCALING_ENABLE
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 06 Apr 2014 12:19:13 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2014 10:19:14.0414 (UTC) FILETIME=[A8F2A8E0:01CF5181]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a7cbe92cef27 ("ARM: tegra: remove tegra EMC scaling driver")
removed the only user of TEGRA_EMC_SCALING_ENABLE. Remove its Kconfig
entry too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/arm/mach-tegra/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 92d660f9610f..55b305d51669 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -70,7 +70,4 @@ config TEGRA_AHB
 	  which controls AHB bus master arbitration and some
 	  performance parameters(priority, prefech size).
 
-config TEGRA_EMC_SCALING_ENABLE
-	bool "Enable scaling the memory frequency"
-
 endmenu
-- 
1.9.0

