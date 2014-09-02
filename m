Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaIBP3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:29:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13134 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaIBP3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:29:36 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-f79ce6d00000115a-3d-5405e25e25ae
Content-transfer-encoding: 8BIT
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] irqchip: exynos-combiner: Fix compilation error on ARM64
Date: Tue, 02 Sep 2014 20:54:52 +0530
Message-id: <1409671492-7725-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkRjfuEWuIwZ8zQhabHl9jtbi8aw6b
	xYzz+5gsFm37z2yxedNUZgdWj52z7rJ7vDt3jt1j85J6j8+b5AJYorhsUlJzMstSi/TtErgy
	7r+5y1Qwm7tix5xW5gbG05xdjJwcEgImEruf32KEsMUkLtxbz9bFyMUhJLCUUeLT/c0sMEUn
	2vtYIBLTgRJT+8A6eAUEJX5MvgeU4OBgFpCXOHIpGyTMLKAuMWneImaI+n4miSm/VjODJNgE
	zCQOLlrNDmKLCChIbO59xgpSxCzQzyjx9+B6RpBBwgKeEh+OJIDUsAioSux9cpIZYpeLxI+W
	lWwgJRJAvXMm2YC0SggsYpe4+vc+M0S9gMS3yYdYIGpkJTYdYIa4X1Li4IobLBMYRWYhuXoW
	wtWzkFy9gJF5FaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZgjJz+92zCDsZ7B6wPMQpwMCrx
	8Er8YAkRYk0sK67MPcRoCnTERGYp0eR8YCTmlcQbGpsZWZiamBobmVuaKYnzvpb6GSwkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBsWpNIMfc9VxPbysEWt/bUZT8Us3cxKp8hphaW0tnYnLY
	9ugdnwp/7P60VyW0j/XXhmCWf88FLzZEfV5lZuLGc1wv6upE0efZr51Pa7lkN0z+FNi6sOZG
	4gujjLrjP50nqnS8a65/2D8l7eW030UyayUfnl40v6362z6ZuzlvDaVC7X78mZ2ar8RSnJFo
	qMVcVJwIAC4NsT2MAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t9jQd24R6whBjOfcllsenyN1eLyrjls
	FjPO72OyWLTtP7PF5k1TmR1YPXbOusvu8e7cOXaPzUvqPT5vkgtgiWpgtMlITUxJLVJIzUvO
	T8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2qukUJaYUwoUCkgsLlbSt8M0
	ITTETdcCpjFC1zckCK7HyAANJKxhzLj/5i5TwWzuih1zWpkbGE9zdjFyckgImEicaO9jgbDF
	JC7cW8/WxcjFISQwnVHi09Q+RpAEr4CgxI/J94CKODiYBeQljlzKBgkzC6hLTJq3iBmivp9J
	Ysqv1cwgCTYBM4mDi1azg9giAgoSm3ufsYIUMQv0M0r8PbieEWSQsICnxIcjCSA1LAKqEnuf
	nGSG2OUi8aNlJRtIiQRQ75xJNhMY+WYhuWIWwhWzkFyxgJF5FaNoakFyQXFSeq6hXnFibnFp
	Xrpecn7uJkZwBD6T2sG4ssHiEKMAB6MSD6/kD5YQIdbEsuLK3EOMEhzMSiK8ey+yhgjxpiRW
	VqUW5ccXleakFh9iNAW6byKzlGhyPjA55JXEGxqbmJsam1qaWJiYWSqJ8x5otQ4UEkhPLEnN
	Tk0tSC2C6WPi4JRqYPRq3OvQX3ks6NfFhPQ8++5J9pU7OIKFP7+ffqvmmsyLpnN3N9R3TzRo
	DDj3QmDG6ybu7Rw/ptu/162qnb0j3vkbv+mZ35O0Zt3o2pW7N+KpvzLvUzEWeROh4KrEBW9d
	9XlUWjh9Io71GWro/d93RUHnfpLwr02OV+eu9eGcp3dRUDYpsWnGUyWW4oxEQy3mouJEALxl
	fpjWAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following compilation error occurs on 64-bit Exynos7 SoC:

drivers/irqchip/exynos-combiner.c: In function ‘combiner_irq_domain_map’:
drivers/irqchip/exynos-combiner.c:162:2: error: implicit declaration of function ‘set_irq_flags’ [-Werror=implicit-function-declaration]
  set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
  ^
drivers/irqchip/exynos-combiner.c:162:21: error: ‘IRQF_VALID’ undeclared (first use in this function)
  set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
                     ^
drivers/irqchip/exynos-combiner.c:162:21: note: each undeclared identifier is reported only once for each function it appears in
drivers/irqchip/exynos-combiner.c:162:34: error: ‘IRQF_PROBE’ undeclared (first use in this function)
  set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);

Fix the build error by including asm/hardirq.h.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/exynos-combiner.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index f8636a6..7fbedcc 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -18,6 +18,8 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 
+#include <asm/hardirq.h>
+
 #include "irqchip.h"
 
 #define COMBINER_ENABLE_SET	0x0
-- 
1.7.9.5

