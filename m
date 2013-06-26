Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab3FZB6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:58:19 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:45939 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FZB6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:58:18 -0400
MIME-Version: 1.0
Date: Wed, 26 Jun 2013 09:58:16 +0800
Message-ID: <CAPgLHd_j_JmDOsGSwLO_eBZnWteMzLVKJa93fY2iaSe31Ozo_w@mail.gmail.com>
Subject: [PATCH -next] ARM: edma: remove duplicated include from edma.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linux@arm.linux.org.uk, grant.likely@linaro.org, rob.herring@calxeda.com,
        nsekhar@ti.com, mporter@ti.com, joelagnel@ti.com, arnd@arndb.de,
        prabhakar.csengg@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/common/edma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index a432e6c..39ad030 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -26,7 +26,6 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/edma.h>
-#include <linux/err.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/of_dma.h>

