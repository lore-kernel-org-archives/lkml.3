Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbaLJNye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:54:34 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:33138 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaLJNyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:54:33 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Warren <swarren@nvidia.com>, Rob Herring <robh+dt@kernel.org>
Subject: [PATCH trivial 1/3] ARM: dt: GIC: Spelling s/specific/specifier/, s/flaggs/flags/
Date: Wed, 10 Dec 2014 14:54:28 +0100
Message-Id: <1418219670-18283-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Rob Herring <robh+dt@kernel.org>
---
 include/dt-bindings/interrupt-controller/arm-gic.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/dt-bindings/interrupt-controller/arm-gic.h b/include/dt-bindings/interrupt-controller/arm-gic.h
index 1ea1b702fec2c49f..d4110d5caa3efde4 100644
--- a/include/dt-bindings/interrupt-controller/arm-gic.h
+++ b/include/dt-bindings/interrupt-controller/arm-gic.h
@@ -7,14 +7,14 @@
 
 #include <dt-bindings/interrupt-controller/irq.h>
 
-/* interrupt specific cell 0 */
+/* interrupt specifier cell 0 */
 
 #define GIC_SPI 0
 #define GIC_PPI 1
 
 /*
  * Interrupt specifier cell 2.
- * The flaggs in irq.h are valid, plus those below.
+ * The flags in irq.h are valid, plus those below.
  */
 #define GIC_CPU_MASK_RAW(x) ((x) << 8)
 #define GIC_CPU_MASK_SIMPLE(num) GIC_CPU_MASK_RAW((1 << (num)) - 1)
-- 
1.9.1

