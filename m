Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3CTKiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 06:38:13 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:57969 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835Ab3CTKiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 06:38:12 -0400
Message-ID: <1363775886.1390.90.camel@x61.thuisdomein>
Subject: [PATCH] m68k: clean up unused "config ROMVECSIZE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 11:38:06 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2013 10:38:07.0123 (UTC) FILETIME=[024BD630:01CE2557]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig symbol ROMVECSIZE is unused since commit
f84f52a5c15db7d14a534815f27253b001735183 ("m68knommu: clean up linker
script"). Let's clean up its Kconfig entry too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/m68k/Kconfig.machine | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/m68k/Kconfig.machine b/arch/m68k/Kconfig.machine
index 7240584..28ec0c0 100644
--- a/arch/m68k/Kconfig.machine
+++ b/arch/m68k/Kconfig.machine
@@ -539,15 +539,6 @@ config ROMVEC
 	  68000 type variants the vectors are at the base of the boot device
 	  on system startup.
 
-config ROMVECSIZE
-	hex "Size of ROM vector region (in bytes)"
-	default "0x400"
-	depends on ROM
-	help
-	  Define the size of the vector region in ROM. For most 68000
-	  variants this would be 0x400 bytes in size. Set to 0 if you do
-	  not want a vector region at the start of the ROM.
-
 config ROMSTART
 	hex "Address of the base of system image in ROM"
 	default "0x400"
-- 
1.7.11.7

