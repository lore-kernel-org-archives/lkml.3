Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3KDJ2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:28:35 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33112 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753048Ab3KDJ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:28:34 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: remove unused XSCALE_PMU Kconfig parameter
Date: Mon,  4 Nov 2013 10:28:03 +0100
Message-Id: <1383557283-4666-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the XSCALE_PMU Kconfig parameter,
which was no longer used anywhere in the source code
and Makefiles.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ad6fb6c094d..6de847c74759 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1091,11 +1091,6 @@ config IWMMXT
 	  Enable support for iWMMXt context switching at run time if
 	  running on a CPU that supports it.
 
-config XSCALE_PMU
-	bool
-	depends on CPU_XSCALE
-	default y
-
 config MULTI_IRQ_HANDLER
 	bool
 	help
-- 
1.8.1.2

