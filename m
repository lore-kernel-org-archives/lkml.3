Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaCUTj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:39:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58582 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751272AbaCUTj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:39:27 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/2] ARM: berlin: add MACH_BERLIN_BG2Q symbol
Date: Fri, 21 Mar 2014 20:39:16 +0100
Message-Id: <1395430757-8677-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we start supporting the Marvell Berlin BG2Q, add a symbol allowing to
differentiate that SoC from the other SoCs of the Berlin family.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-berlin/Kconfig | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
index 7a02d222c378..0ff6f5877076 100644
--- a/arch/arm/mach-berlin/Kconfig
+++ b/arch/arm/mach-berlin/Kconfig
@@ -24,6 +24,13 @@ config MACH_BERLIN_BG2CD
 	select CPU_V7
 	select HAVE_ARM_TWD if SMP
 
+config MACH_BERLIN_BG2Q
+	bool "Marvell Armada 1500 Pro (BG2-Q)"
+	select CACHE_L2X0
+	select CPU_V7
+	select HAVE_ARM_TWD if SMP
+	select HAVE_SMP
+
 endmenu
 
 endif
-- 
1.8.3.2

