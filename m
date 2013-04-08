Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935096Ab3DHSGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:06:34 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:58586 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934447Ab3DHSGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:06:33 -0400
Message-ID: <1365444391.1830.125.camel@x61.thuisdomein>
Subject: [PATCH] MIPS: Kconfig: remove "config MIPS_BOARDS_GEN"
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 20:06:31 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2013 18:06:32.0141 (UTC) FILETIME=[CCC907D0:01CE3483]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol MIPS_BOARDS_GEN is unused since v2.6.27. It should
now be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested, unsurprisingly.

 arch/mips/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 51244bf..7b38bf8 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -306,7 +306,6 @@ config MIPS_MALTA
 	select HW_HAS_PCI
 	select I8253
 	select I8259
-	select MIPS_BOARDS_GEN
 	select MIPS_BONITO64
 	select MIPS_CPU_SCACHE
 	select PCI_GT64XXX_PCI0
@@ -342,7 +341,6 @@ config MIPS_SEAD3
 	select DMA_NONCOHERENT
 	select IRQ_CPU
 	select IRQ_GIC
-	select MIPS_BOARDS_GEN
 	select MIPS_CPU_SCACHE
 	select MIPS_MSC
 	select SYS_HAS_CPU_MIPS32_R1
@@ -1079,9 +1077,6 @@ config IRQ_GT641XX
 config IRQ_GIC
 	bool
 
-config MIPS_BOARDS_GEN
-	bool
-
 config PCI_GT64XXX_PCI0
 	bool
 
-- 
1.7.11.7

