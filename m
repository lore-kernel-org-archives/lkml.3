Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaLXChP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 21:37:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50512 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaLXChN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 21:37:13 -0500
X-AuditID: cbfee68f-f791c6d000004834-6b-549a26d7e32a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: ben-linux@fluff.org, kyungmin.park@samsung.com, inki.dae@samsung.com,
        cw00.choi@samsung.com, k.kozlowski@samsung.com,
        b.zolnierkie@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: EXYNOS: Add exynos3250 suspend-to-ram support
Date: Wed, 24 Dec 2014 11:37:09 +0900
Message-id: <1419388629-27066-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWyRsSkRPe62qwQg1lbBCw2zljPajFp3QEm
	i+tfngNZ9yewWLx+YWjRu+Aqm8XZpjfsFpseX2O1uLxrDpvFjPP7mBy4PP6uesHssXlJvUff
	llWMHp83yQWwRHHZpKTmZJalFunbJXBlHL11kKVgslbF97W7mRsYJyt3MXJySAiYSEyYtY4V
	whaTuHBvPVsXIxeHkMBSRonPf9YywRRtmf2RGSKxiFGi9eZzFginiUliS9M2ZpAqNgEtif0v
	brCB2CICkhJNDX/AOpgF/jNKrDk1FSwhLOAs0bx0HSOIzSKgKnH63Hwgm4ODV8BVouMNH8Q2
	BYlly2eygvRKCLSzS1z+180KUS8g8W3yIRaQegkBWYlNB5gh6iUlDq64wTKBUXABI8MqRtHU
	guSC4qT0ImO94sTc4tK8dL3k/NxNjMBAPv3vWf8OxrsHrA8xCnAwKvHwLjgzI0SINbGsuDL3
	EKMp0IaJzFKiyfnAeMkriTc0NjOyMDUxNTYytzRTEuddKPUzWEggPbEkNTs1tSC1KL6oNCe1
	+BAjEwenVAOj6SWb9H0ZR59++RQgO2e5y6/DCoEX7hg/jV99MG/5kWttE3StZqS+nFKraH6y
	5ka7rXJTqF3ctdM8hmuslBc9FzJNfPziQFRPkOEs5p1zWDX6bL9yC2XWH2/lT99n/jQipWyu
	zPrN3juW9p4pnr5px9H9DAHTnop57W+f4P9oz7ulJo5Hc0qXKbEUZyQaajEXFScCAIw2r3lf	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jAd3rarNCDLYuYLfYOGM9q8WkdQeY
	LK5/eQ5k3Z/AYvH6haFF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY3Lg8vi76gWzx+Yl9R59
	W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI+SQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePorYMsBZO1
	Kr6v3c3cwDhZuYuRk0NCwERiy+yPzBC2mMSFe+vZuhi5OIQEFjFKtN58zgLhNDFJbGnaBlbF
	JqAlsf/FDTYQW0RAUqKp4Q8zSBGzwH9GiTWnpoIlhAWcJZqXrmMEsVkEVCVOn5sPZHNw8Aq4
	SnS84YPYpiCxbPlM1gmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMfJM6kdjCsb
	LA4xCnAwKvHwLjgzI0SINbGsuDL3EKMEB7OSCK/OjZkhQrwpiZVVqUX58UWlOanFhxhNgZZP
	ZJYSTc4HxnBeSbyhsYmZkaWRuaGFkbG5kjivkn1biJBAemJJanZqakFqEUwfEwenVAMjj/Ed
	Pef+6E4u54CpNsuZlS6EHpyr1JRvmZzKouUmqTtT+nnej4Z8KcnJOgFFWfU2bdu/3bigsIXj
	aOORy3sZnus5X7N6t32VyS8RFtugNVOX3FXtvKDKIBuRXJR5NPzrat0g7Wf+LzaXet+UKE0T
	l1CTPtZZp7OL4VbjOXUtngRn7spYdSWW4oxEQy3mouJEALqSggmpAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for suspend-to-ram feature of Exynos3250 SoC.
Exynos3250 don't contain the L2 cache.

The measured power-consumption in suspend state:
- before entering suspend : 31mA
- in suspend state : 16mA

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
This patch is based on v3.19-rc1 and is tested on Exynos3250-based Rinato board.

 arch/arm/mach-exynos/regs-pmu.h |  3 ++
 arch/arm/mach-exynos/suspend.c  | 77 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index b5f4406..eb461e1 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -160,12 +160,14 @@
 #define EXYNOS5_L2RSTDISABLE_VALUE		BIT(3)
 
 #define S5P_PAD_RET_MAUDIO_OPTION		0x3028
+#define S5P_PAD_RET_MMC2_OPTION			0x30c8
 #define S5P_PAD_RET_GPIO_OPTION			0x3108
 #define S5P_PAD_RET_UART_OPTION			0x3128
 #define S5P_PAD_RET_MMCA_OPTION			0x3148
 #define S5P_PAD_RET_MMCB_OPTION			0x3168
 #define S5P_PAD_RET_EBIA_OPTION			0x3188
 #define S5P_PAD_RET_EBIB_OPTION			0x31A8
+#define S5P_PAD_RET_SPI_OPTION			0x31c8
 
 #define S5P_PS_HOLD_CONTROL			0x330C
 #define S5P_PS_HOLD_EN				(1 << 31)
@@ -326,6 +328,7 @@
 			(EXYNOS3_ARM_CORE0_OPTION + ((_nr) * 0x80))
 
 #define EXYNOS3_ARM_COMMON_OPTION			0x2408
+#define EXYNOS3_ARM_L2_OPTION				0x2608
 #define EXYNOS3_TOP_PWR_OPTION				0x2C48
 #define EXYNOS3_CORE_TOP_PWR_OPTION			0x2CA8
 #define EXYNOS3_XUSBXTI_DURATION			0x341C
diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index f8e7dcd..d6feef3 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -91,6 +91,12 @@ static unsigned int exynos_pmu_spare3;
 
 static u32 exynos_irqwake_intmask = 0xffffffff;
 
+static const struct exynos_wkup_irq exynos3250_wkup_irq[] = {
+	{ 73, BIT(1) }, /* RTC alarm */
+	{ 74, BIT(2) }, /* RTC tick */
+	{ /* sentinel */ },
+};
+
 static const struct exynos_wkup_irq exynos4_wkup_irq[] = {
 	{ 76, BIT(1) }, /* RTC alarm */
 	{ 77, BIT(2) }, /* RTC tick */
@@ -114,6 +120,19 @@ unsigned int exynos_release_ret_regs[] = {
 	REG_TABLE_END,
 };
 
+unsigned int exynos3250_release_ret_regs[] = {
+	S5P_PAD_RET_MAUDIO_OPTION,
+	S5P_PAD_RET_GPIO_OPTION,
+	S5P_PAD_RET_UART_OPTION,
+	S5P_PAD_RET_MMCA_OPTION,
+	S5P_PAD_RET_MMCB_OPTION,
+	S5P_PAD_RET_EBIA_OPTION,
+	S5P_PAD_RET_EBIB_OPTION,
+	S5P_PAD_RET_MMC2_OPTION,
+	S5P_PAD_RET_SPI_OPTION,
+	REG_TABLE_END,
+};
+
 unsigned int exynos5420_release_ret_regs[] = {
 	EXYNOS_PAD_RET_DRAM_OPTION,
 	EXYNOS_PAD_RET_MAUDIO_OPTION,
@@ -173,6 +192,12 @@ static int exynos_cpu_suspend(unsigned long arg)
 	return exynos_cpu_do_idle();
 }
 
+static int exynos3250_cpu_suspend(unsigned long arg)
+{
+	flush_cache_all();
+	return exynos_cpu_do_idle();
+}
+
 static int exynos5420_cpu_suspend(unsigned long arg)
 {
 	/* MCPM works with HW CPU identifiers */
@@ -230,6 +255,23 @@ static void exynos_pm_prepare(void)
 	pmu_raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
 }
 
+static void exynos3250_pm_prepare(void)
+{
+	unsigned int tmp;
+
+	/* Set wake-up mask registers */
+	exynos_pm_set_wakeup_mask();
+
+	tmp = pmu_raw_readl(EXYNOS3_ARM_L2_OPTION);
+	tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
+	pmu_raw_writel(tmp, EXYNOS3_ARM_L2_OPTION);
+
+	exynos_pm_enter_sleep_mode();
+
+	/* ensure at least INFORM0 has the resume address */
+	pmu_raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
+}
+
 static void exynos5420_pm_prepare(void)
 {
 	unsigned int tmp;
@@ -344,6 +386,28 @@ early_wakeup:
 	pmu_raw_writel(0x0, S5P_INFORM1);
 }
 
+static void exynos3250_pm_resume(void)
+{
+	u32 cpuid = read_cpuid_part();
+
+	if (exynos_pm_central_resume())
+		goto early_wakeup;
+
+	/* For release retention */
+	exynos_pm_release_retention();
+
+	pmu_raw_writel(S5P_USE_STANDBY_WFI_ALL, S5P_CENTRAL_SEQ_OPTION);
+
+	if (call_firmware_op(resume) == -ENOSYS
+	    && cpuid == ARM_CPU_PART_CORTEX_A9)
+		exynos_cpu_restore_register();
+
+early_wakeup:
+
+	/* Clear SLEEP mode set in INFORM1 */
+	pmu_raw_writel(0x0, S5P_INFORM1);
+}
+
 static void exynos5420_prepare_pm_resume(void)
 {
 	if (IS_ENABLED(CONFIG_EXYNOS5420_MCPM))
@@ -483,6 +547,16 @@ static const struct platform_suspend_ops exynos_suspend_ops = {
 	.valid		= suspend_valid_only_mem,
 };
 
+static const struct exynos_pm_data exynos3250_pm_data = {
+	.wkup_irq	= exynos3250_wkup_irq,
+	.wake_disable_mask = ((0xFF << 8) | (0x1F << 1)),
+	.release_ret_regs = exynos3250_release_ret_regs,
+	.pm_suspend	= exynos_pm_suspend,
+	.pm_resume	= exynos3250_pm_resume,
+	.pm_prepare	= exynos3250_pm_prepare,
+	.cpu_suspend	= exynos3250_cpu_suspend,
+};
+
 static const struct exynos_pm_data exynos4_pm_data = {
 	.wkup_irq	= exynos4_wkup_irq,
 	.wake_disable_mask = ((0xFF << 8) | (0x1F << 1)),
@@ -518,6 +592,9 @@ static struct exynos_pm_data exynos5420_pm_data = {
 
 static struct of_device_id exynos_pmu_of_device_ids[] = {
 	{
+		.compatible = "samsung,exynos3250-pmu",
+		.data = &exynos3250_pm_data,
+	}, {
 		.compatible = "samsung,exynos4210-pmu",
 		.data = &exynos4_pm_data,
 	}, {
-- 
1.8.5.5

