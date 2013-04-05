Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3DEKQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:16:35 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:55585 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148Ab3DEKQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:16:34 -0400
Message-ID: <1365156992.1830.63.camel@x61.thuisdomein>
Subject: [PATCH] omap2+: Remove useless Makefile line
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 05 Apr 2013 12:16:32 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Apr 2013 10:16:32.0579 (UTC) FILETIME=[A54C1930:01CE31E6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge commit 952414505f55afe5cd6dc004765076aa22b3ed7e ("Merge branch
'next/cleanup' of git://git.linaro.org/people/arnd/arm-soc") added
references to CONFIG_MACH_PCM049 and board-omap4pcm049.o to this
Makefile. But there's no Kconfig symbol MACH_PCM049 and there's no file
board-omap4pcm049.c. This line can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Note that MACH_PCM049 was removed from mach-types in v3.5.

 arch/arm/mach-omap2/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 3d0697c..62bb352 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -254,8 +254,6 @@ obj-$(CONFIG_MACH_TOUCHBOOK)		+= board-omap3touchbook.o
 obj-$(CONFIG_MACH_OMAP_4430SDP)		+= board-4430sdp.o
 obj-$(CONFIG_MACH_OMAP4_PANDA)		+= board-omap4panda.o
 
-obj-$(CONFIG_MACH_PCM049)		+= board-omap4pcm049.o
-
 obj-$(CONFIG_MACH_OMAP3517EVM)		+= board-am3517evm.o
 
 obj-$(CONFIG_MACH_CRANEBOARD)		+= board-am3517crane.o
-- 
1.7.11.7

