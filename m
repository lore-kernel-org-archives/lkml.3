Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab3J0MnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 08:43:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58934 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753161Ab3J0MnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 08:43:22 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: msalter@redhat.com, a-jacquiot@ti.com
Cc: linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] c6x: remove unused COMMON_CLKDEV Kconfig parameter
Date: Sun, 27 Oct 2013 13:43:04 +0100
Message-Id: <1382877784-5020-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the COMMON_CLKDEV kernel configuration
parameter defined in arch/c6x/Kconfig, but used nowhere
in the makefiles and source code.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/c6x/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index 957dd00..11bb75b0 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -36,9 +36,6 @@ config GENERIC_HWEIGHT
 config GENERIC_BUG
 	def_bool y
 
-config COMMON_CLKDEV
-	def_bool y
-
 config C6X_BIG_KERNEL
 	bool "Build a big kernel"
 	help
-- 
1.8.1.2

