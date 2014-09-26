Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbaIZHXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:23:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44418 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbaIZHXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:23:30 -0400
X-AuditID: cbfee68f-f791c6d000004834-16-5425146fac15
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, cw00.choi@samsung.com, vikas.sajjan@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 1/2] ARM: EXYNOS: suspend: Make restoring registers into
 selectable option.
Date: Fri, 26 Sep 2014 16:23:21 +0900
Message-id: <1411716202-31644-2-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1411716202-31644-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1411716202-31644-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWyRsSkULdARDXE4F0jm8X1L89ZLTrPPmG2
	6F1wlc1i0+NrrBaXd81hs5hxfh+Txc1n25kc2D02L6n36NuyitHj8ya5AOYoLpuU1JzMstQi
	fbsErozF6/ezF9yTrPh38jVTA+Md0S5GTg4JAROJ7uu32SBsMYkL99YD2VwcQgJLGSXeLJ/K
	BlO0du9yVhBbSGA6o8TOL9IQRW1MEk9aJ7ODJNgEdCT+77sJZosIZEvM39sNZjMLlEhcWLSV
	BcQWFoiVmDptBthQFgFViQ+n7gAN5eDgFfCQ2NTgCGJKCChIzJlkA1LBKeAp8fbHLHaItR4S
	11c8YwVZKyHQzi5xfOYaqDECEt8mH2KB6JWV2HSAGeJkSYmDK26wTGAUXsDIsIpRNLUguaA4
	Kb3IWK84Mbe4NC9dLzk/dxMjMJhP/3vWv4Px7gHrQ4wCHIxKPLw31qmECLEmlhVX5h5iNAXa
	MJFZSjQ5HxgzeSXxhsZmRhamJqbGRuaWZkrivAulfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYDTvWvV9zZGKis0M81j/rPfziTX9xBVlsrpOZ7aY4uHvlfueSf3+xvfvsyjv4VVOt5rv
	bp0ou/Lh4+iHOg4hSv+vCt1j7pk6afbbeZ+CM5cKezW3SE5semUwrbn1zKpZVRcPF8fFJlz8
	WzFdXGej57YrW1rOznnSc/H8xcaoUMUPG67O2vbJ5bqKEktxRqKhFnNRcSIAYiIAdGECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t9jQd18EdUQgy1d1hbXvzxnteg8+4TZ
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFjefbWdyYPfYvKTeo2/LKkaPz5vkApijGhhtMlITU1KL
	FFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CWKymUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzFq/fz15wT7Li38nXTA2Md0S7GDk5JARMJNbu
	Xc4KYYtJXLi3ng3EFhKYziix84t0FyMXkN3GJPGkdTI7SIJNQEfi/76bYLaIQLbE/L3dYDaz
	QInEhUVbWUBsYYFYianTZoANYhFQlfhw6g7QAg4OXgEPiU0NjiCmhICCxJxJNiAVnAKeEm9/
	zGKHWOshcX3FM9YJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTHyjOpHYwrGywO
	MQpwMCrx8N5YpxIixJpYVlyZe4hRgoNZSYR3I4dqiBBvSmJlVWpRfnxRaU5q8SFGU6CbJjJL
	iSbnA+M4ryTe0NjEzMjSyNzQwsjYXEmc90CrdaCQQHpiSWp2ampBahFMHxMHp1QDo7cPx4vO
	OQ7+6c3zEznMjx08mJeQt+dcpiXjMcPrbDucfFbuP/HNrOv1xOWsF5rv8GT1fLxWs8UnXuzP
	1JK4cG62fZI5qr9ePRDZIHalPKDTq+FXqYdjYtzcd+FuCY5H7jEcrHx8WoHn/l/ZoOi6fUv/
	pW449/PB6rkce/1lZ1s9fvY58fVzJyWW4oxEQy3mouJEANGluCurAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some EXYNOS series may not requried to save ROM registers as it's default
for now. This patch makes restoring registers into machine-specific option.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 arch/arm/mach-exynos/suspend.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index f5d9773..b41d146 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -48,23 +48,28 @@ struct exynos_wkup_irq {
 	u32 mask;
 };
 
-static struct sleep_save exynos5_sys_save[] = {
-	SAVE_ITEM(EXYNOS5_SYS_I2C_CFG),
+static struct sleep_save exynos_save_regs[] = {
+	/* SROM side */
+	SAVE_ITEM(S5P_SROM_BW),
+	SAVE_ITEM(S5P_SROM_BC0),
+	SAVE_ITEM(S5P_SROM_BC1),
+	SAVE_ITEM(S5P_SROM_BC2),
+	SAVE_ITEM(S5P_SROM_BC3),
 };
 
-static struct sleep_save exynos_core_save[] = {
-	/* SROM side */
+static struct sleep_save exynos5_save_regs[] = {
 	SAVE_ITEM(S5P_SROM_BW),
 	SAVE_ITEM(S5P_SROM_BC0),
 	SAVE_ITEM(S5P_SROM_BC1),
 	SAVE_ITEM(S5P_SROM_BC2),
 	SAVE_ITEM(S5P_SROM_BC3),
+	SAVE_ITEM(EXYNOS5_SYS_I2C_CFG),
 };
 
 struct exynos_pm_data {
 	const struct exynos_wkup_irq *wkup_irq;
-	struct sleep_save *extra_save;
-	int num_extra_save;
+	struct sleep_save *save_regs;
+	int num_save_regs;
 	unsigned int wake_disable_mask;
 	unsigned int *release_ret_regs;
 
@@ -165,11 +170,9 @@ static void exynos_pm_prepare(void)
 	/* Set wake-up mask registers */
 	exynos_pm_set_wakeup_mask();
 
-	s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
-
-	 if (pm_data->extra_save)
-		s3c_pm_do_save(pm_data->extra_save,
-				pm_data->num_extra_save);
+	 if (pm_data->save_regs)
+		s3c_pm_do_save(pm_data->save_regs,
+				pm_data->num_save_regs);
 
 	exynos_pm_enter_sleep_mode();
 }
@@ -203,11 +206,9 @@ static void exynos_pm_resume(void)
 	/* For release retention */
 	exynos_pm_release_retention();
 
-	if (pm_data->extra_save)
-		s3c_pm_do_restore_core(pm_data->extra_save,
-					pm_data->num_extra_save);
-
-	s3c_pm_do_restore_core(exynos_core_save, ARRAY_SIZE(exynos_core_save));
+	if (pm_data->save_regs)
+		s3c_pm_do_restore_core(pm_data->save_regs,
+					pm_data->num_save_regs);
 
 	if (cpuid == ARM_CPU_PART_CORTEX_A9)
 		scu_enable(S5P_VA_SCU);
@@ -291,6 +292,8 @@ static const struct exynos_pm_data exynos4_pm_data = {
 	.wkup_irq	= exynos4_wkup_irq,
 	.wake_disable_mask = ((0xFF << 8) | (0x1F << 1)),
 	.release_ret_regs = exynos_release_ret_regs,
+	.save_regs	= exynos_save_regs,
+	.num_save_regs	= ARRAY_SIZE(exynos_save_regs),
 	.pm_suspend	= exynos_pm_suspend,
 	.pm_resume	= exynos_pm_resume,
 	.pm_prepare	= exynos_pm_prepare,
@@ -301,8 +304,8 @@ static const struct exynos_pm_data exynos5250_pm_data = {
 	.wkup_irq	= exynos5250_wkup_irq,
 	.wake_disable_mask = ((0xFF << 8) | (0x1F << 1)),
 	.release_ret_regs = exynos_release_ret_regs,
-	.extra_save	= exynos5_sys_save,
-	.num_extra_save	= ARRAY_SIZE(exynos5_sys_save),
+	.save_regs	= exynos5_save_regs,
+	.num_save_regs	= ARRAY_SIZE(exynos5_save_regs),
 	.pm_suspend	= exynos_pm_suspend,
 	.pm_resume	= exynos_pm_resume,
 	.pm_prepare	= exynos_pm_prepare,
-- 
1.7.9.5

