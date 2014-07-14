Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878AbaGNEBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 00:01:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12546 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaGNEBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 00:01:33 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-f5-53c3561bac89
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [RESPIN PATCH v6] ARM: EXYNOS: Move cpufreq and cpuidle device
 registration to init_machine
Date: Mon, 14 Jul 2014 09:28:43 +0530
Message-id: <1405310323-3195-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkRlc67HCwwYQL7BbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrHoWMZocfPZdiYHHo+W
	5h42j81L6j36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY8L0K0wFi/grzt+6xtjA+Ieni5GT
	Q0LARGLi+vOsELaYxIV769lAbCGBpYwSa84qwtSceniUvYuRCyg+nVHi/prnjBDOBCaJ/8sf
	MINUsQnoSjx5PxfMFhHIlui/vZoFpIhZ4DGjxJuVRxlBEsICaRKrmr6yg9gsAqoSvUf3gjXw
	CrhLLJ/8GegMDqB1ChJzJtmA9EoITGeXeD93DQtEvYDEt8mHWCBqZCU2HWCGuE5S4uCKGywT
	GAUXMDKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAgM7NP/nvXtYLx5wPoQYzLQuInMUqLJ
	+cDIyCuJNzQ2M7IwNTE1NjK3NCNNWEmcd9HDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jDVijKb/3QM/aJgvOdMqdi9lLv85h7Xam8POLv1vcVet2i3hHdemDrULhyarC85OXaoWxcZy
	Ld7laCDP6ivX3tfc3/jZVU2toLj8YP3SpfY/OAq19svJsF4RYmHV9toyz0p1i9Lmgxfun5AV
	u+aQ/7/33uyjW6//vhJolbr96UR3fb0OltXWSUosxRmJhlrMRcWJACyZGa+CAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jQV2psMPBBot+WFksm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBaLtgJVrJ/xmsWiYxmjxc1n25kceDxa
	mnvYPDYvqffo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
	JYW8xNxUWyUXnwBdt8wcoMOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1
	jBkTpl9hKljEX3H+1jXGBsY/PF2MnBwSAiYSpx4eZYewxSQu3FvP1sXIxSEkMJ1R4v6a54wQ
	zgQmif/LHzCDVLEJ6Eo8eT8XzBYRyJbov72aBaSIWeAxo8SblUcZQRLCAmkSq5q+go1lEVCV
	6D26F6yBV8BdYvnkz6xdjBxA6xQk5kyymcDIvYCRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcOQ8k97BuKrB4hCjAAejEg9vBsfhYCHWxLLiytxDjBIczEoivOFuQCHelMTKqtSi/Pii
	0pzU4kOMpkDLJzJLiSbnA6M6ryTe0NjE3NTY1NLEwsTMUkmc92CrdaCQQHpiSWp2ampBahFM
	HxMHp1QDo6RIuvb7CE+fEtvZ7S/ONx86UuLneTjsT/GjNKXd8To9d/5NdTvQe2YFy7eyUJ4C
	1QWfQnYnXUrRS3QOPh/2kzXGxbXw0zS2BF2zXQyRrpMetjrP5OaROX1K88zyxyd3e7/utpdc
	cGiuclXb6S1/d3dm8ZV3Lb5hZPKpxD7A/uxjufK1zMruSizFGYmGWsxFxYkAHE4jWbICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As exynos_cpuidle_init and exynos_cpufreq_init function have just one lines
of code for registering platform devices. We can move these lines to
exynos_dt_machine_init and delete exynos_cpuidle_init and exynos_cpufreq_init
function. This will help in reducing lines of code in exynos.c, making it
more cleaner.

Suggested-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---

This patch is part of exynos-cleanup series v6 [1]. Just respinning after
resolving merge conflicts on latest kgene/for-next.

[1]: https://lkml.org/lkml/2014/7/10/338


 arch/arm/mach-exynos/exynos.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 2a43a17..99dc5aa 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -175,17 +175,6 @@ static struct platform_device exynos_cpuidle = {
 	.id                = -1,
 };
 
-void __init exynos_cpuidle_init(void)
-{
-	if (soc_is_exynos4210() || soc_is_exynos5250())
-		platform_device_register(&exynos_cpuidle);
-}
-
-void __init exynos_cpufreq_init(void)
-{
-	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
-}
-
 void __iomem *sysram_base_addr;
 void __iomem *sysram_ns_base_addr;
 
@@ -335,10 +324,11 @@ static void __init exynos_dt_machine_init(void)
 	if (!IS_ENABLED(CONFIG_SMP))
 		exynos_sysram_init();
 
-	if (!of_machine_is_compatible("samsung,exynos5420"))
-		exynos_cpuidle_init();
+	if (of_machine_is_compatible("samsung,exynos4210") ||
+			of_machine_is_compatible("samsung,exynos5250"))
+		platform_device_register(&exynos_cpuidle);
 
-	exynos_cpufreq_init();
+	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
-- 
1.7.9.5

