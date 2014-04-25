Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaDYMPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:15:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43278 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbaDYMPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:15:04 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-80-535a51c5b8c6
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 01/10] ARM: EXYNOS: Make exynos machine_ops as static
Date: Fri, 25 Apr 2014 21:32:37 +0900
Message-id: <1398429166-5539-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+Zse7RwKhggwdrdS02zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdovDb9pZLdbPeM1icfPZdiaLHS2rWRx4
	PFqae9g8Ni+p9+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6Ml3O2sxU85ayYtvszewPjZI4u
	Rk4OCQETiVcvb7JB2GISF+6tB7K5OIQEljFKHJjfyQZTNHPfeUaIxCJGifb2x1BVbUwSj6fu
	ZQKpYhPQlXjyfi4ziC0ikC1xpfE+mM0s8J5R4vNhdRBbWMBD4trXJewgNouAqsTVjnmMIDav
	gLtEW8MXoHoOoG0KEnMm2YCEOYHKTyz/yA6xq5VR4vzv2ywgjoTALnaJd/fOMkEMEpD4NvkQ
	C0SzrMSmA8wQV0tKHFxxg2UCo/ACRoZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCHRMHEH
	4/0D1ocYk4HGTWSWEk3OB0ZTXkm8obGZkYWpiamxkbmlGWnCSuK86Y+SgoQE0hNLUrNTUwtS
	i+KLSnNSiw8xMnFwSjUwlj4X+b6sRfNZ7+/T0Y5hk8748PRebr6xtMst/svDzeb7jL7tXvXa
	dI7fxFKnPdXBCi1PlxplfTbcymUm0HzQdGnDnL/1G6s/PdH8k7Qn2Un02R6WtObvy4vnPHCY
	f++PxqIvbQ786vw5Z7bq9lRvcGX5cuxyySmhjRcfnF7H8cO+2HHGHqX5e5RYijMSDbWYi4oT
	AS0WcpKcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jAd2jgVHBBit7NCw2zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdovDb9pZLdbPeM1icfPZdiaLHS2rWRx4
	PFqae9g8Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNL
	C3MlhbzE3FRbJRefAF23zBygy5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCB
	hHWMGS/nbGcreMpZMW33Z/YGxskcXYycHBICJhIz951nhLDFJC7cW8/WxcjFISSwiFGivf0x
	lNPGJPF46l4mkCo2AV2JJ+/nMoPYIgLZElca74PZzALvGSU+H1YHsYUFPCSufV3CDmKzCKhK
	XO2YB7aBV8Bdoq3hC1A9B9A2BYk5k2xAwpxA5SeWf2SH2NXKKHH+922WCYy8CxgZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEx9oz6R2MqxosDjEKcDAq8fBOkI0MFmJNLCuuzD3EKMHB
	rCTC+8EvKliINyWxsiq1KD++qDQntfgQYzLQVROZpUST84FpIK8k3tDYxMzI0sjMwsjE3Jw0
	YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGOfozuX13PpeujjngkzOvaqVDWHfj//5pVV1
	bPEW6dTgVyuzhOe3fZtlMTVu3pPnPIb3b0WZ2l15eHV+X5m0QOOudQHTjhxKnFwocb56aXHE
	JdlknQnmsttvZzatrVioc2/5BcMPLze9uppX8S7QLZe5t5//6L1Chw91izoCJgqffTnFwXV2
	d4YSS3FGoqEWc1FxIgDummAD+QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As machine function ops are used only in this file let's make
them static.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/exynos.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index b32a907..2388ee4 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -198,7 +198,7 @@ static struct map_desc exynos5_iodesc[] __initdata = {
 	},
 };
 
-void exynos_restart(enum reboot_mode mode, const char *cmd)
+static void exynos_restart(enum reboot_mode mode, const char *cmd)
 {
 	struct device_node *np;
 	u32 val = 0x1;
@@ -235,7 +235,7 @@ void __init exynos_cpufreq_init(void)
 	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
 }
 
-void __init exynos_init_late(void)
+static void __init exynos_init_late(void)
 {
 	if (of_machine_is_compatible("samsung,exynos5440"))
 		/* to be supported later */
@@ -296,7 +296,7 @@ static void __init exynos_map_io(void)
 		iotable_init(exynos5250_iodesc, ARRAY_SIZE(exynos5250_iodesc));
 }
 
-void __init exynos_init_io(void)
+static void __init exynos_init_io(void)
 {
 	debug_ll_io_init();
 
-- 
1.7.10.4

