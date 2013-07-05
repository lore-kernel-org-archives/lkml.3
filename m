Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab3GEQWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:22:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63956 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab3GEQWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:22:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 3/8] ARM: zynq: use DT_MACHINE_START
Date: Fri,  5 Jul 2013 18:23:32 +0200
Message-Id: <1373041417-217728-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1373041417-217728-1-git-send-email-arnd@arndb.de>
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:vI89tWaTC1kvz0Y/JupxxBOfDXY+02QPh5ml2xY8nT7
 VWmtWtqUlLhjgf3szg+YhDgvEin3XXW9DnYMWfeRODwAlQ+TqD
 xXDFB3g8KTquMnx6+HCEUA/DPhSrkUBZ6eg6Qgflgzt6nP8Mtz
 mPDqTOsBlky7HTGR8RDmg8wWhLJIpTLMSC29VeaIRD24JHzoC8
 TMSS5pbSJFSLZaQoSKqHdZBBCiT2s0vxhKkGHOj8jIQAMS56Id
 XDP5BX8SgtqlPcMrvmc/w9idKm1+n8o3CsWaQ22ONlsFQf+q/s
 Yu/FgY/8a2p5iDy1POAzoYSyl/tcQuCDMwUBh0ZyIgySTgXoKY
 anmJNGajRGOtFMK+p9nXdefEmGYqaOj+a98jGjNfa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The zynq platform code only supports DT based booting, so we
should use DT_MACHINE_START rather than MACHINE_START.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/mach-zynq/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 4130e65..5b799c2 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -101,7 +101,7 @@ static const char * const zynq_dt_match[] = {
 	NULL
 };
 
-MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
+DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
 	.smp		= smp_ops(zynq_smp_ops),
 	.map_io		= zynq_map_io,
 	.init_machine	= zynq_init_machine,
-- 
1.8.3.1

