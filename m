Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaCIVlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 17:41:49 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:51969 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140AbaCIVls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 17:41:48 -0400
Message-ID: <1394401306.9066.2.camel@x220>
Subject: [PATCH] [TRIVIAL] ARM: spear: clean up editing mistake
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel@vger.kernel.org
Date: Sun, 09 Mar 2014 22:41:46 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2014 21:41:46.0798 (UTC) FILETIME=[5EE78CE0:01CF3BE0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up an obvious editing mistake introduced by commit 4b6effb6ff38
("ARM: spear: merge Kconfig files").

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/arm/mach-spear/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-spear/Kconfig b/arch/arm/mach-spear/Kconfig
index 1595776..596e990 100644
--- a/arch/arm/mach-spear/Kconfig
+++ b/arch/arm/mach-spear/Kconfig
@@ -91,7 +91,7 @@ config MACH_SPEAR600
 	depends on ARCH_SPEAR6XX
 	select USE_OF
 	help
-	  Supports ST SPEAr600 boards configured via the device-treesource "arch/arm/mach-spear6xx/Kconfig"
+	  Supports ST SPEAr600 boards configured via the device-tree
 
 config ARCH_SPEAR_AUTO
 	depends on !ARCH_SPEAR13XX && !ARCH_SPEAR6XX
-- 
1.8.5.3

