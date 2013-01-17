Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047Ab3AQDMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:12:10 -0500
Received: from smtp.outflux.net ([198.145.64.163]:57664 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758570Ab3AQCyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:39 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Mike Frysinger <vapier@gentoo.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 24/86] arch/blackfin: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:16 -0800
Message-Id: <1358391258-1771-25-git-send-email-keescook@chromium.org>
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

CC: Mike Frysinger <vapier@gentoo.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/blackfin/Kconfig |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index b6f3ad5..ca33c8d 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -562,8 +562,7 @@ choice
 	  accurate - This option is therefore marked experimental.
 
 config BFIN_KERNEL_CLOCK_MEMINIT_CALC
-	bool "Calculate Timings (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Calculate Timings"
 
 config BFIN_KERNEL_CLOCK_MEMINIT_SPEC
 	bool "Provide accurate Timings based on target SCLK"
@@ -1120,7 +1119,7 @@ endchoice
 
 comment "Memory Protection Unit"
 config MPU
-	bool "Enable the memory protection unit (EXPERIMENTAL)"
+	bool "Enable the memory protection unit"
 	default n
 	help
 	  Use the processor's MPU to protect applications from accessing
@@ -1442,7 +1441,6 @@ config BFIN_CPU_FREQ
 
 config CPU_VOLTAGE
 	bool "CPU Voltage scaling"
-	depends on EXPERIMENTAL
 	depends on CPU_FREQ
 	default n
 	help
-- 
1.7.9.5

