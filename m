Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003Ab3AQDN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:13:28 -0500
Received: from smtp.outflux.net ([198.145.64.163]:56304 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758558Ab3AQCyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:38 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Michal Simek <monstr@monstr.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 25/86] arch/microblaze/platform: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:17 -0800
Message-Id: <1358391258-1771-26-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Michal Simek <monstr@monstr.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/microblaze/platform/Kconfig.platform |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/platform/Kconfig.platform b/arch/microblaze/platform/Kconfig.platform
index 669c7ee..b174721 100644
--- a/arch/microblaze/platform/Kconfig.platform
+++ b/arch/microblaze/platform/Kconfig.platform
@@ -20,7 +20,7 @@ endchoice
 
 config SELFMOD
 	bool "Use self modified code for intc/timer"
-	depends on EXPERIMENTAL && NO_MMU
+	depends on NO_MMU
 	default n
 	help
 	  This choice enables self-modified code for interrupt controller
-- 
1.7.9.5

