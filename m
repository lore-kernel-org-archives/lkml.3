Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3EJA2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 20:28:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11887 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab3EJA2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 20:28:39 -0400
X-AuditID: cbfee690-b7f136d000000fea-c9-518c3f359acb
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Inderpal Singh'" <inderpal.singh@linaro.org>,
        "'Chander Kashyap'" <chander.kashyap@linaro.org>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] ARM: EXYNOS5: Fix kernel dump in AFTR idle mode
Date: Fri, 10 May 2013 09:28:36 +0900
Message-id: <000801ce4d15$4fe51bf0$efaf53d0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zQ11T+55AgxcvhS0err/JYrFi8gd2
	iyXN3BaXd81hs1iw8RGjA6vHnWt72Dz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr4/mmu4wF
	n0UqXn5cxtLA+FSwi5GTQ0LAROJbxwtWCFtM4sK99WxdjFwcQgLLGCUmbnzMDFO068QRZojE
	IkaJXRf+MEI4fxklGlu+MoJUsQnoShxbvwVslIiAt8SpKb/AupkFqiTOvmgHGssB1MAtsbo5
	CCTMKcAjse5PJ1iJMFD595NfmEBsFgFViblfDrCB2LwCdhI7Vsxih7AFJX5MvscCMVJLYv3O
	40wQtrzE5jVvmUHGSwioSzz6qwtxQYrEnw1PocpFJPa9eAd2soTAKXaJaSsXMkPsEpD4NvkQ
	C0SvrMSmA1D/SkocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSiV5yYW1ya
	l66XnJ+7iRESkxN2MN47YH2IMRlo/URmKdHkfGBM55XEGxqbGVmYmpgaG5lbmpEmrCTOq95i
	HSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBccIh98KvSaryIpNObb83y940z8cgfxfbhrMs
	5uUlsR788i6CNWrHhWb0Z/7pvinqZHGyPWSRavwluz9e/9/M2T+Xd8q06Y6FE50PC5hd3xcw
	m7vkmVrFxb2LJvRwx69r8//id+lEx9Pvzpz7Vm07+U5kUfPUhd2PND8/vzLvZYydYanFGy+D
	GCWW4oxEQy3mouJEAEo/TXjfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAV1T+55Ag9m7+Cwerr/JYrFi8gd2
	iyXN3BaXd81hs1iw8RGjA6vHnWt72Dz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMeP5pruMBZ9FKl5+XMbSwPhUsIuRk0NCwERi14kjzBC2mMSFe+vZ
	uhi5OIQEFjFK7LrwhxHC+cso0djylRGkik1AV+LY+i2sILaIgLfEqSm/wLqZBaokzr5oB+rm
	AGrglljdHAQS5hTgkVj3pxOsRBio/PvJL0wgNouAqsTcLwfYQGxeATuJHStmsUPYghI/Jt9j
	gRipJbF+53EmCFteYvOat8wg4yUE1CUe/dWFuCBF4s+Gp1DlIhL7XrxjnMAoNAvJpFlIJs1C
	MmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj/pn0DsZVDRaHGAU4GJV4eD/s
	7A4UYk0sK67MPcQowcGsJMK7YQNQiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBySivJN7Q
	2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgnlJ+4+05IZ9fpE6l9
	VhPiajq4wl59lKw/wvKdgfHVh0VrteoO3o95YhbfWdxwKYhLTa3jTfWvw855Pz89O6yUclu7
	9Nc156P3Xa96nzLZE3Yj83Cskoz1kxkT2I1TqzXT6hdO4Fu1r9S6/MjNzqfP7/q9Wc38Xn4/
	B09zhnfK/eCl9fEXRM4osRRnJBpqMRcVJwIA9k+8GTwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Inderpal Singh <inderpal.singh@linaro.org>"

commit 088584618836b159947bc4ab5011a5cf1f081a62 upstream

The kernel crashes while resuming from AFTR idle mode. It happens
because L2 cache was not going into retention state.

This patch configures the USE_RETENTION bit of ARM_L2_OPTION register
so that it does not depend on MANUAL_L2RSTDISABLE_CONTROL of
ARM_COMMON_OPTION register for L2RSTDISABLE signal.

Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
Tested-by: Chander Kashyap <chander.kashyap@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/mach-exynos/include/mach/regs-pmu.h |    1 +
 arch/arm/mach-exynos/pmu.c                   |    5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/include/mach/regs-pmu.h
b/arch/arm/mach-exynos/include/mach/regs-pmu.h
index 3f30aa1..57344b7 100644
--- a/arch/arm/mach-exynos/include/mach/regs-pmu.h
+++ b/arch/arm/mach-exynos/include/mach/regs-pmu.h
@@ -344,6 +344,7 @@
 #define EXYNOS5_FSYS_ARM_OPTION
S5P_PMUREG(0x2208)
 #define EXYNOS5_ISP_ARM_OPTION
S5P_PMUREG(0x2288)
 #define EXYNOS5_ARM_COMMON_OPTION
S5P_PMUREG(0x2408)
+#define EXYNOS5_ARM_L2_OPTION
S5P_PMUREG(0x2608)
 #define EXYNOS5_TOP_PWR_OPTION
S5P_PMUREG(0x2C48)
 #define EXYNOS5_TOP_PWR_SYSMEM_OPTION
S5P_PMUREG(0x2CC8)
 #define EXYNOS5_JPEG_MEM_OPTION
S5P_PMUREG(0x2F48)
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index daebc1a..97d6885 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -228,6 +228,7 @@ static struct exynos_pmu_conf exynos5250_pmu_config[] =
{
 	{ EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
 	{ EXYNOS5_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
 	{ EXYNOS5_ARM_L2_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
+	{ EXYNOS5_ARM_L2_OPTION,			{ 0x10, 0x10, 0x0 }
},
 	{ EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
 	{ EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
 	{ EXYNOS5_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
@@ -353,11 +354,9 @@ static void exynos5_init_pmu(void)
 
 	/*
 	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
-	 * MANUAL_L2RSTDISABLE_CONTROL_BITFIELD Enable
 	 */
 	tmp = __raw_readl(EXYNOS5_ARM_COMMON_OPTION);
-	tmp |= (EXYNOS5_MANUAL_L2RSTDISABLE_CONTROL |
-		EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN);
+	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
 	__raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
 
 	/*
-- 
1.7.9.5

