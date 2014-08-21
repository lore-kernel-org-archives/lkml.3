Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaHUTWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:22:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:62090 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbaHUTWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:22:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="375424754"
Subject: [PATCH] dmaengine maintainer update
From: Dan Williams <dan.j.williams@intel.com>
To: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org
Date: Thu, 21 Aug 2014 12:22:06 -0700
Message-ID: <20140821192035.27601.50486.stgit@viggo.jf.intel.com>
User-Agent: StGit/0.17.1-5-g6888
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am stepping down as dmaengine maintainer as the bulk of the activity
in the subsystem is primarily targeted at the slave-dma case handled by
Vinod, and I have recently been unable to give the few patches I do
receive timely review.  There is still an item in my backlog to
eliminate the async_tx api and the constraints it poses on dmaengine
drivers, but I need not hold on to the maintainer role in the meantime.
I will still be subscribed to dmaengine@vger.kernel.org to answer
questions, but all patches should be routed through Vinod unless/until a
maintainer for the non-slave-dma use case arrives.  It is non-entirely
clear at this point that there is enough work going forward for a
separate maintainer of the pure-offload case.

Ongoing development of the ioatdma driver is handled by Dave.  I'm still
interested in reviewing ioatdma patches, but he is the primary
maintainer/developer going forward.

IOP platforms are not generating any traffic in my inbox, but if a patch
did arrive I've long since lost access to hardware.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
I'll add this to final pull request for the contents of dmaengine.git
and priority fixes from patchwork that have been stalled.
 
 MAINTAINERS |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b3fdb0f004ba..848ff1281b67 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -970,24 +970,20 @@ F:	arch/arm/mach-pxa/colibri-pxa270-income.c
 
 ARM/INTEL IOP32X ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IOP33X ARM ARCHITECTURE
-M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
+S:	Orphan
 
 ARM/INTEL IOP13XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IQ81342EX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
@@ -1012,7 +1008,6 @@ F:	drivers/pcmcia/pxa2xx_stargate2.c
 
 ARM/INTEL XSC3 (MANZANO) ARM CORE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
@@ -1446,7 +1441,7 @@ F:	drivers/platform/x86/eeepc*.c
 ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
 M:	Dan Williams <dan.j.williams@intel.com>
 W:	http://sourceforge.net/projects/xscaleiop
-S:	Maintained
+S:	Odd fixes
 F:	Documentation/crypto/async-tx-api.txt
 F:	crypto/async_tx/
 F:	drivers/dma/
@@ -2778,13 +2773,11 @@ T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
 
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
 M:	Vinod Koul <vinod.koul@intel.com>
-M:	Dan Williams <dan.j.williams@intel.com>
 L:	dmaengine@vger.kernel.org
 Q:	https://patchwork.kernel.org/project/linux-dmaengine/list/
-S:	Supported
+S:	Maintained
 F:	drivers/dma/
 F:	include/linux/dma*
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git
 T:	git git://git.infradead.org/users/vkoul/slave-dma.git (slave-dma)
 
 DME1737 HARDWARE MONITOR DRIVER
@@ -4500,8 +4493,8 @@ F:	arch/x86/kernel/microcode_core.c
 F:	arch/x86/kernel/microcode_intel.c
 
 INTEL I/OAT DMA DRIVER
-M:	Dan Williams <dan.j.williams@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
+M:	Dan Williams <dan.j.williams@intel.com>
 L:	dmaengine@vger.kernel.org
 Q:	https://patchwork.kernel.org/project/linux-dmaengine/list/
 S:	Supported

