Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab3GEQWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:22:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51063 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab3GEQWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:22:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/8] ARM: sti: move DEBUG_STI_UART into alphabetical order
Date: Fri,  5 Jul 2013 18:23:34 +0200
Message-Id: <1373041417-217728-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1373041417-217728-1-git-send-email-arnd@arndb.de>
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:oz1lPEqqZ8/wURMVXxUPuRlPE6oSkdF9V9+lGolYv8G
 hFzQpOJLh6ffh01n3dkzFkGjNMNFT99TwRsf3lNdmhJQ3HT6Or
 VPSjcvLqXOkmG6W2THXj1x4AsD2BQW68jqo7RbgsYRZsPydaKI
 fvVVxW4Gj3t4xdMGZtX9HNGVNJ37zcG72iMIAgqdd/ccOiVAwW
 dFb6qD2eM1eZTBOBkawQWsTnr3dqK9NSQmDdscFqFHXFlf1box
 rGEvrclXoOZG5EJMHFrsrcZ4oex3IA3dC9Wqm8QqCsDJjjwfZO
 1o8GkbTU8kul/xac6sOsjjLHIRTyaoOveUuT/5GZX/WGKIjb37
 PHQ+WR+6sLioKqRwvslXpGYcByrXfos2YWfGMBYOS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was accidentally added in the wrong place, messing
up the ordering of the file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig.debug | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 77c1411..ff4920b 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -510,6 +510,16 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to the uart1 port on SiRFmarco devices.
 
+	config DEBUG_STI_UART
+		depends on ARCH_STI
+		bool "Use StiH415/416 ASC for low-level debug"
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on StiH415/416 based platforms like B2000, B2020.
+		  It support UART2 and SBC_UART1.
+
+		  If unsure, say N.
+
 	config DEBUG_U300_UART
 		bool "Kernel low-level debugging messages via U300 UART0"
 		depends on ARCH_U300
@@ -557,16 +567,6 @@ choice
 		  This option selects UART0 on VIA/Wondermedia System-on-a-chip
 		  devices, including VT8500, WM8505, WM8650 and WM8850.
 
-	config DEBUG_STI_UART
-		depends on ARCH_STI
-		bool "Use StiH415/416 ASC for low-level debug"
-		help
-		  Say Y here if you want kernel low-level debugging support
-		  on StiH415/416 based platforms like B2000, B2020.
-		  It support UART2 and SBC_UART1.
-
-		  If unsure, say N.
-
 	config DEBUG_LL_UART_NONE
 		bool "No low-level debugging UART"
 		depends on !ARCH_MULTIPLATFORM
-- 
1.8.3.1

