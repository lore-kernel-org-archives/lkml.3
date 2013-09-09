Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3IIWMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 18:12:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:47408 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab3IIWMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 18:12:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,874,1371106800"; 
   d="scan'208";a="398997274"
Subject: [PATCH] MAINTAINERS: update email for Dan Williams
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-raid@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Jon Mason <jon.mason@intel.com>,
        Shaohua Li <shli@kernel.org>, linux-arm-kernel@lists.infradead.org
Date: Mon, 09 Sep 2013 15:12:03 -0700
Message-ID: <20130909221154.4969.71486.stgit@dwillia2-mobl1.amr.corp.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Returned to intel.com

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jon Mason <jon.mason@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 MAINTAINERS |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index defc053..058fb68 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -914,24 +914,24 @@ F:	arch/arm/mach-pxa/colibri-pxa270-income.c
 
 ARM/INTEL IOP32X ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-M:	Dan Williams <djbw@fb.com>
+M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IOP33X ARM ARCHITECTURE
-M:	Dan Williams <djbw@fb.com>
+M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IOP13XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-M:	Dan Williams <djbw@fb.com>
+M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IQ81342EX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-M:	Dan Williams <djbw@fb.com>
+M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
@@ -956,7 +956,7 @@ F:	drivers/pcmcia/pxa2xx_stargate2.c
 
 ARM/INTEL XSC3 (MANZANO) ARM CORE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-M:	Dan Williams <djbw@fb.com>
+M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
@@ -1363,7 +1363,7 @@ F:	drivers/platform/x86/asus*.c
 F:	drivers/platform/x86/eeepc*.c
 
 ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
-M:	Dan Williams <djbw@fb.com>
+M:	Dan Williams <dan.j.williams@intel.com>
 W:	http://sourceforge.net/projects/xscaleiop
 S:	Maintained
 F:	Documentation/crypto/async-tx-api.txt
@@ -2638,7 +2638,7 @@ T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
 
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
 M:	Vinod Koul <vinod.koul@intel.com>
-M:	Dan Williams <djbw@fb.com>
+M:	Dan Williams <dan.j.williams@intel.com>
 S:	Supported
 F:	drivers/dma/
 F:	include/linux/dma*
@@ -4263,7 +4263,7 @@ F:	arch/x86/kernel/microcode_core.c
 F:	arch/x86/kernel/microcode_intel.c
 
 INTEL I/OAT DMA DRIVER
-M:	Dan Williams <djbw@fb.com>
+M:	Dan Williams <dan.j.williams@intel.com>
 S:	Maintained
 F:	drivers/dma/ioat*
 
@@ -4276,7 +4276,7 @@ F:	drivers/iommu/intel-iommu.c
 F:	include/linux/intel-iommu.h
 
 INTEL IOP-ADMA DMA DRIVER
-M:	Dan Williams <djbw@fb.com>
+M:	Dan Williams <dan.j.williams@intel.com>
 S:	Odd fixes
 F:	drivers/dma/iop-adma.c
 

