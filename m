Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab3CYKj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:39:57 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:52539 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757175Ab3CYKj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:39:56 -0400
Message-ID: <1364207994.1390.273.camel@x61.thuisdomein>
Subject: [PATCH] MIPS: Kconfig: Rename SNIPROM too
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 11:39:54 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 10:39:54.0436 (UTC) FILETIME=[16534040:01CE2945]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SNIPROM was renamed to CONFIG_FW_SNIPROM in v3.8. Let's rename
SNIPROM itself too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Should this go into stable (for v3.8.y)?

 arch/mips/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index cd2e21f..b2df476 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -657,7 +657,7 @@ config SNI_RM
 	bool "SNI RM200/300/400"
 	select FW_ARC if CPU_LITTLE_ENDIAN
 	select FW_ARC32 if CPU_LITTLE_ENDIAN
-	select SNIPROM if CPU_BIG_ENDIAN
+	select FW_SNIPROM if CPU_BIG_ENDIAN
 	select ARCH_MAY_HAVE_PC_FDC
 	select BOOT_ELF32
 	select CEVT_R4K
@@ -1144,7 +1144,7 @@ config DEFAULT_SGI_PARTITION
 config FW_ARC32
 	bool
 
-config SNIPROM
+config FW_SNIPROM
 	bool
 
 config BOOT_ELF32
-- 
1.7.11.7

