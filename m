Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaIZHXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:23:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59506 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaIZHXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:23:31 -0400
X-AuditID: cbfee68e-f79b46d000002b74-6b-54251470b64e
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, cw00.choi@samsung.com, vikas.sajjan@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 2/2] ARM: EXYNOS3250: Add initial support EXYNOS3250
 suspend/resume.
Date: Fri, 26 Sep 2014 16:23:22 +0900
Message-id: <1411716202-31644-3-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1411716202-31644-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1411716202-31644-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWyRsSkRLdARDXEYPddC4vrX56zWnSefcJs
	0bvgKpvFpsfXWC0u75rDZjHj/D4mi5vPtjM5sHtsXlLv0bdlFaPH501yAcxRXDYpqTmZZalF
	+nYJXBlLpyxnLFgnVrFz337GBsbrQl2MnBwSAiYSZ94fZ4OwxSQu3FsPZHNxCAksZZRo3fiJ
	BaaoZ+5NJojEdEaJTY+mMUM4bUwS33Z1MoNUsQnoSPzfd5MdxBYRyJaYv7cbzGYWKJG4sGgr
	2CRhgTCJa1uvgcVZBFQldrRdAerl4OAV8JCY3h8DYkoIKEjMmWQDUsEp4Cnx9scssGohoIrr
	K56xgqyVEGhnl9j0cA4LxBgBiW+TD7FA9MpKbDrADHGzpMTBFTdYJjAKL2BkWMUomlqQXFCc
	lF5kpFecmFtcmpeul5yfu4kRGM6n/z3r28F484D1IUYBDkYlHt4b61RChFgTy4orcw8xmgJt
	mMgsJZqcD4yavJJ4Q2MzIwtTE1NjI3NLMyVx3gSpn8FCAumJJanZqakFqUXxRaU5qcWHGJk4
	OKUaGE0X8hpUnJa6ceW5qdI/07+LufJ+1lTJR14Ne9Oqm3982Ya291venrvjlDS7S+/3+kzr
	xfqNuQ/8Gu9oZ/etVJNmddk8OWCZGuuHi+eyxKacaTrxxjjBfH6K4xbFz6xNt2a/8LFp9pP9
	9fK/+0rX2SKRhk3c2zplv+qePy3ydtKLg9v0HA6FuCixFGckGmoxFxUnAgBPm+MfYgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t9jQd0CEdUQg5sTDSyuf3nOatF59gmz
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG4+287kwO6xeUm9R9+WVYwenzfJBTBHNTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmLJ2ynLFgnVjFzn37GRsYrwt1MXJySAiYSPTM
	vckEYYtJXLi3nq2LkYtDSGA6o8SmR9OYIZw2JolvuzqZQarYBHQk/u+7yQ5iiwhkS8zf2w1m
	MwuUSFxYtJUFxBYWCJO4tvUaWJxFQFViR9sVoF4ODl4BD4np/TEgpoSAgsScSTYgFZwCnhJv
	f8wCqxYCqri+4hnrBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo+WZ9A7GVQ0W
	hxgFOBiVeHgb1qiECLEmlhVX5h5ilOBgVhLh3cihGiLEm5JYWZValB9fVJqTWnyI0RToponM
	UqLJ+cBIziuJNzQ2MTOyNDI3tDAyNlcS5z3Yah0oJJCeWJKanZpakFoE08fEwSnVwJggFLZ+
	Lt9Mz/sVXFqWee/Ci61sBS7M21oeecvcIWJ+faoT17xcK6W0kMsfl73/3bJjgofProb7GswT
	5oSHdp+XiReP6r1sPFO7OP/nhhviKttLnryJmvGhaCbrruO31u8R+S6z3ez9x6hoGeZ+PSst
	/0VBnMtOVyRkNd/OS7f4yFHnIGIVp8RSnJFoqMVcVJwIAJmKQFisAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It adds data and callback needed for exynos3250's suspend/resume.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 arch/arm/mach-exynos/regs-pmu.h |    4 ++++
 arch/arm/mach-exynos/suspend.c  |   31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 322f132..b5125dc1 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -131,6 +131,10 @@
 #define S5P_CORE_LOCAL_PWR_EN			0x3
 #define S5P_CORE_WAKEUP_FROM_LOCAL_CFG		(0x3 << 8)
 
+/* Only for EXYNOS3250 */
+#define	S5P_PAD_RET_MMCC_OPTION			0x30C8
+#define	S5P_PAD_RET_SPI_OPTION			0x31C8
+
 /* Only for EXYNOS4210 */
 #define S5P_CMU_CLKSTOP_LCD1_LOWPWR	0x1154
 #define S5P_CMU_RESET_LCD1_LOWPWR	0x1174
diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index b41d146..de7d6d5 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -87,6 +87,12 @@ struct exynos_pm_data *pm_data;
 
 static u32 exynos_irqwake_intmask = 0xffffffff;
 
+static const struct exynos_wkup_irq exynos3250_wkup_irq[] = {
+	{ 105, BIT(1) }, /* RTC alarm */
+	{ 106, BIT(2) }, /* RTC tick */
+	{ /* sentinel */ },
+};
+
 static const struct exynos_wkup_irq exynos4_wkup_irq[] = {
 	{ 76, BIT(1) }, /* RTC alarm */
 	{ 77, BIT(2) }, /* RTC tick */
@@ -99,6 +105,19 @@ static const struct exynos_wkup_irq exynos5250_wkup_irq[] = {
 	{ /* sentinel */ },
 };
 
+unsigned int exynos3250_release_ret_regs[] = {
+	S5P_PAD_RET_MAUDIO_OPTION,
+	S5P_PAD_RET_GPIO_OPTION,
+	S5P_PAD_RET_UART_OPTION,
+	S5P_PAD_RET_MMCA_OPTION,
+	S5P_PAD_RET_MMCB_OPTION,
+	S5P_PAD_RET_MMCC_OPTION,
+	S5P_PAD_RET_EBIA_OPTION,
+	S5P_PAD_RET_EBIB_OPTION,
+	S5P_PAD_RET_SPI_OPTION,
+	REG_TABLE_END,
+};
+
 unsigned int exynos_release_ret_regs[] = {
 	S5P_PAD_RET_MAUDIO_OPTION,
 	S5P_PAD_RET_GPIO_OPTION,
@@ -288,6 +307,15 @@ static const struct platform_suspend_ops exynos_suspend_ops = {
 	.valid		= suspend_valid_only_mem,
 };
 
+static const struct exynos_pm_data exynos3250_pm_data = {
+	.wkup_irq	= exynos3250_wkup_irq,
+	.release_ret_regs = exynos3250_release_ret_regs,
+	.pm_suspend	= exynos_pm_suspend,
+	.pm_resume	= exynos_pm_resume,
+	.pm_prepare	= exynos_pm_prepare,
+	.cpu_suspend	= exynos_cpu_suspend,
+};
+
 static const struct exynos_pm_data exynos4_pm_data = {
 	.wkup_irq	= exynos4_wkup_irq,
 	.wake_disable_mask = ((0xFF << 8) | (0x1F << 1)),
@@ -314,6 +342,9 @@ static const struct exynos_pm_data exynos5250_pm_data = {
 
 static struct of_device_id exynos_pmu_of_device_ids[] = {
 	{
+		.compatible = "samsung,exynos3250-pmu",
+		.data = &exynos3250_pm_data,
+	}, {
 		.compatible = "samsung,exynos4210-pmu",
 		.data = &exynos4_pm_data,
 	}, {
-- 
1.7.9.5

