Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935603Ab3DHSvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:51:16 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:52112 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760400Ab3DHSvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:51:15 -0400
Message-ID: <1365447073.1830.128.camel@x61.thuisdomein>
Subject: [PATCH] MIPS: Kconfig: remove "config MIPS_DISABLE_OBSOLETE_IDE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 20:51:13 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2013 18:51:13.0660 (UTC) FILETIME=[0B185BC0:01CE348A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol MIPS_DISABLE_OBSOLETE_IDE was added in v2.6.10. It
has never been used. Let's remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep" (on current and historic trees).

 arch/mips/Kconfig         | 3 ---
 arch/mips/alchemy/Kconfig | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 7b38bf8..27a4bfa 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -981,9 +981,6 @@ config MIPS_MSC
 config MIPS_NILE4
 	bool
 
-config MIPS_DISABLE_OBSOLETE_IDE
-	bool
-
 config SYNC_R4K
 	bool
 
diff --git a/arch/mips/alchemy/Kconfig b/arch/mips/alchemy/Kconfig
index c8862bd..7032ac7 100644
--- a/arch/mips/alchemy/Kconfig
+++ b/arch/mips/alchemy/Kconfig
@@ -31,7 +31,6 @@ config MIPS_DB1000
 	select ALCHEMY_GPIOINT_AU1000
 	select DMA_NONCOHERENT
 	select HW_HAS_PCI
-	select MIPS_DISABLE_OBSOLETE_IDE
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_HAS_EARLY_PRINTK
@@ -41,7 +40,6 @@ config MIPS_DB1235
 	select ARCH_REQUIRE_GPIOLIB
 	select HW_HAS_PCI
 	select DMA_COHERENT
-	select MIPS_DISABLE_OBSOLETE_IDE
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_HAS_EARLY_PRINTK
 
@@ -57,7 +55,6 @@ config MIPS_GPR
 	select ALCHEMY_GPIOINT_AU1000
 	select HW_HAS_PCI
 	select DMA_NONCOHERENT
-	select MIPS_DISABLE_OBSOLETE_IDE
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_HAS_EARLY_PRINTK
 
-- 
1.7.11.7

