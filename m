Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbaICFgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:36:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50910 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaICFgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:36:39 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-f79536d000000fd1-56-5406a8e4a99c
Content-transfer-encoding: 8BIT
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH v2] irqchip: exynos-combiner: Fix compilation error on ARM64
Date: Wed, 03 Sep 2014 11:02:09 +0530
Message-id: <1409722329-18309-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSq/t0BVuIwcnZzBaNSy6zWGx6fI3V
	4vKuOWwWM87vY7JYtO0/s8XyUztYLDZvmsrswO6xZt4aRo+ds+6yezQcOM/i8e7cOXaPzUvq
	PT5vkgtgi+KySUnNySxLLdK3S+DKWDz3PGvBHZ6Kq68vMzcw/uDqYuTkkBAwkbg5/yQThC0m
	ceHeerYuRi4OIYGljBLXJuxjgilqP3GPHSKxiFHi1qTlrCAJXgFBiR+T77F0MXJwMAvISxy5
	lA0SZhZQl5g0bxEzRH0/k8S0hjdsIAk2ATOJg4tWs4PYIgIKEpt7n7GCFDEL3GaU2NmwFmyb
	sICPxNYNa1hAbBYBVYmVTU/ZIZa5Sux92MYGskwCqHnOJBuQXgmBQ+wSt7/8ZoeoF5D4NvkQ
	C0SNrMSmA8wQD0hKHFxxg2UCo8gsJGfPQjh7FpKzFzAyr2IUTS1ILihOSi8y0itOzC0uzUvX
	S87P3cQIjKbT/5717WC8ecD6EKMAB6MSD++CALYQIdbEsuLK3EOMpkBHTGSWEk3OB8ZsXkm8
	obGZkYWpiamxkbmlmZI4b4LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjI3yN7p7+kI6
	vz70rBE6U7mQ9aysvq3Qc5u3Kh+k6jb0hSScTXdWZp43t0NA41/RxZ8RKk85eHQ+5f6O1Aj1
	7e9duynl62Zex9yjB4tspM+c/rJwfd7H9wX5xdm37NZlnuHVs/Lffixc59HR+yu+nDzf9GR3
	Fe+luReYQg+orTzLcXeW3OyyB0osxRmJhlrMRcWJAGr4CCChAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t9jAd0nK9hCDC5Os7BoXHKZxWLT42us
	Fpd3zWGzmHF+H5PFom3/mS2Wn9rBYrF501RmB3aPNfPWMHrsnHWX3aPhwHkWj3fnzrF7bF5S
	7/F5k1wAW1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4Cu
	W2YO0C1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozFc8+zFtzhqbj6
	+jJzA+MPri5GTg4JAROJ9hP32CFsMYkL99azdTFycQgJLGKUuDVpOStIgldAUOLH5HssXYwc
	HMwC8hJHLmWDhJkF1CUmzVvEDFHfzyQxreENG0iCTcBM4uCi1WBDRQQUJDb3PmMFKWIWuM0o
	sbNhLRNIQljAR2LrhjUsIDaLgKrEyqan7BDLXCX2PmxjA1kmAdQ8Z5LNBEa+WUjOmIVwxiwk
	ZyxgZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERyrz6R2MK5ssDjEKMDBqMTDuyCALUSI
	NbGsuDL3EKMEB7OSCK9vIlCINyWxsiq1KD++qDQntfgQoynQfROZpUST84FpJK8k3tDYxNzU
	2NTSxMLEzFJJnPdAq3WgkEB6YklqdmpqQWoRTB8TB6dUA6Mko6T/p9WuBcFz5nOG9bnm9zVZ
	L1CyPTHp2dKJXxY4N5z3NpOMihCzYFX/yX/XX/T2FPuYl8bNeifL2G631qruYLsyg9HgnMyP
	iwUKvxb/uSq4zFVCbWLn4qNtnocLfE/KfC6f+THiQM1VN6aMw4G75rjvm7Pj0P2cb5qXV6Q+
	Pn7K3ofF2lCJpTgj0VCLuag4EQBPxeyr6wIAAA==
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

Fix the build error by including linux/interrupt.h.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Sudeep Holla <sudeep.holla@arm.com>
---
Changes since v1:
Used linux/interrupt.h instead of asm/hardirq.h

 drivers/irqchip/exynos-combiner.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index f8636a6..5945223 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/irqdomain.h>
 #include <linux/irqchip/chained_irq.h>
+#include <linux/interrupt.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 
-- 
1.7.9.5

