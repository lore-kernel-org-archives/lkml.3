Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaK0Hj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:39:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41760 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaK0Hf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:26 -0500
X-AuditID: cbfee68f-f791c6d000004834-9e-5476d4376bc4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, cw00.choi@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/19] clk: samsung: exynos5433: Add clocks for CMU_PERIS domain
Date: Thu, 27 Nov 2014 16:35:03 +0900
Message-id: <1417073716-22997-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWyRsSkWNf8SlmIwfWtUhaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbeY8mc5k8Wm
	x9dYLS7vmsNmMeP8PiaLpdcvMlmcuv6ZzeLwm3ZWixmTX7JZHJuxhNFi1a4/jBYvP55gcRDz
	WDNvDaPH71+TGD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCOKC6blNSczLLUIn27
	BK6M7+vPMxW88al4e2s9WwPjC6cuRk4OCQETiQevPzBD2GISF+6tZ+ti5OIQEljKKPFw22rW
	LkYOsKILe5Ig4tMZJXreTWSGcJqYJG6tfMAO0s0moCWx/8UNNhBbRMBZomFqIxNIEbPAR2aJ
	hmkXWUESwgIBEgfOtDOCTGURUJXYcogFJMwr4Cqx58hBqCsUJJYtnwlWzingJrH/60EwWwio
	ZtG3K2AzJQQWckjcX3kYrIFFQEDi22SQQSCXykpsOgA1R1Li4IobLBMYhRcwMqxiFE0tSC4o
	TkovMtYrTswtLs1L10vOz93ECIzL0/+e9e9gvHvA+hCjAAejEg+vxYGyECHWxLLiytxDjKZA
	GyYyS4km5wOjP68k3tDYzMjC1MTU2Mjc0kxJnHeh1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYxC8+eI3FpQOXvW3/ajkj11H10XbzBWTb/jcHJZ7++CGf9LGJZKXxGJlO9vWcX8X4vB
	aJ7HPJcMnlOv54tG2KzacfMI89F71bePmagHPldjFNz513rb2wVVqXXcETKhE99LaX4p0Mic
	2zHp5i21bwZPo1s36L0PyZMXfJy19FL3ig3P3h69EbtbiaU4I9FQi7moOBEA56afusYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQV3zK2UhBt8W81s8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1iyp/lTBab
	Hl9jtbi8aw6bxYzz+5gsll6/yGRx6vpnNovDb9pZLWZMfslmcWzGEkaLVbv+MFq8/HiCxUHM
	Y828NYwev39NYvTYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA/lNSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYwZnxff56p4I1Pxdtb69kaGF84dTFycEgImEhc2JPU
	xcgJZIpJXLi3nq2LkYtDSGA6o0TPu4nMEE4Tk8StlQ/YQarYBLQk9r+4wQZiiwg4SzRMbWQC
	KWIW+Mgs0TDtIitIQlggQOLAmXZGkA0sAqoSWw6xgIR5BVwl9hw5yAyxTUFi2fKZYOWcAm4S
	+78eBLOFgGoWfbvCNIGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Kh/Jr2DcVWD
	xSFGAQ5GJR5eiwNlIUKsiWXFlbmHGCU4mJVEeKUWAYV4UxIrq1KL8uOLSnNSiw8xmgIdNZFZ
	SjQ5H5iQ8kriDY1NzIwsjcwNLYyMzZXEeW/czA0REkhPLEnNTk0tSC2C6WPi4JRqYJy2Yd3r
	B0untk5UNA+b9IlRWdogiuejjMWTLSLxU6N2SQb3M34w6vf7+HxNVYa6ZOoFgYubLeRmtD54
	1LTl9uW3W47NSn8zTSXAQeWY5Lbqi0829iyZbhH9612ic5TfGvZ093jP3bxv/Wz1DD/pN9Sb
	6fK1XE+/z9gRvPTYMp1fvEe0JmZ/a1RiKc5INNRiLipOBACAPU9tEAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing gate clocks of CMU_PERIS domain
which includes TMU/TZPC/SECKEY/CHIPID/TOPRTC/EFUSE IPs.
The special clocks of CMU_PERIS use fin_pll source clock directly.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 drivers/clk/samsung/clk-exynos5433.c   | 146 ++++++++++++++++++++++++++++++++-
 include/dt-bindings/clock/exynos5433.h |  33 +++++++-
 2 files changed, 176 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index 11ee2d8..b09f2cfe 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -248,6 +248,7 @@ PNAME(mout_sclk_audio0_p)	= { "ioclk_audiocdclk0", "fin_pll",
 static struct samsung_fixed_factor_clock top_fixed_factor_clks[] __initdata = {
 	FFACTOR(0, "sclk_bus_pll", "fout_bus_pll", 1, 1, 0),
 	FFACTOR(0, "sclk_mfc_pll", "fout_mfc_pll", 1, 1, 0),
+	FFACTOR(0, "oscclk_efuse_common", "fin_pll", 1, 1, 0),
 
 	/* HACK: fin_pll hardcoded to xusbxti until detection is implemented */
 	FFACTOR(CLK_FIN_PLL, "fin_pll", "xusbxti", 1, 1, 0),
@@ -959,15 +960,69 @@ CLK_OF_DECLARE(exynos5433_cmu_peric, "samsung,exynos5433-cmu-peric",
 /*
  * Register offset definitions for CMU_PERIS
  */
-#define ENABLE_ACLK_PERIS		0x0800
-#define ENABLE_PCLK_PERIS		0x0900
+#define ENABLE_ACLK_PERIS				0x0800
+#define ENABLE_PCLK_PERIS				0x0900
+#define ENABLE_PCLK_PERIS_SECURE_TZPC			0x0904
+#define ENABLE_PCLK_PERIS_SECURE_SECKEY_APBIF		0x0908
+#define ENABLE_PCLK_PERIS_SECURE_CHIPID_APBIF		0x090c
+#define ENABLE_PCLK_PERIS_SECURE_TOPRTC			0x0910
+#define ENABLE_PCLK_PERIS_SECURE_CUSTOM_EFUSE_APBIF	0x0914
+#define ENABLE_PCLK_PERIS_SECURE_ANTIRBK_CNT_APBIF	0x0918
+#define ENABLE_PCLK_PERIS_SECURE_OTP_CON_APBIF		0x091c
+#define ENABLE_SCLK_PERIS				0x0a00
+#define ENABLE_SCLK_PERIS_SECURE_SECKEY			0x0a04
+#define ENABLE_SCLK_PERIS_SECURE_CHIPID			0x0a08
+#define ENABLE_SCLK_PERIS_SECURE_TOPRTC			0x0a0c
+#define ENABLE_SCLK_PERIS_SECURE_CUSTOM_EFUSE		0x0a10
+#define ENABLE_SCLK_PERIS_SECURE_ANTIRBK_CNT		0x0a14
+#define ENABLE_SCLK_PERIS_SECURE_OTP_CON		0x0a18
+#define ENABLE_IP_PERIS0				0x0b00
+#define ENABLE_IP_PERIS1				0x0b04
+#define ENABLE_IP_PERIS_SECURE_TZPC			0x0b08
+#define ENABLE_IP_PERIS_SECURE_SECKEY			0x0b0c
+#define ENABLE_IP_PERIS_SECURE_CHIPID			0x0b10
+#define ENABLE_IP_PERIS_SECURE_TOPRTC			0x0b14
+#define ENABLE_IP_PERIS_SECURE_CUSTOM_EFUSE		0x0b18
+#define ENABLE_IP_PERIS_SECURE_ANTIBRK_CNT		0x0b1c
+#define ENABLE_IP_PERIS_SECURE_OTP_CON			0x0b20
 
 static unsigned long peris_clk_regs[] __initdata = {
 	ENABLE_ACLK_PERIS,
 	ENABLE_PCLK_PERIS,
+	ENABLE_PCLK_PERIS_SECURE_TZPC,
+	ENABLE_PCLK_PERIS_SECURE_SECKEY_APBIF,
+	ENABLE_PCLK_PERIS_SECURE_CHIPID_APBIF,
+	ENABLE_PCLK_PERIS_SECURE_TOPRTC,
+	ENABLE_PCLK_PERIS_SECURE_CUSTOM_EFUSE_APBIF,
+	ENABLE_PCLK_PERIS_SECURE_ANTIRBK_CNT_APBIF,
+	ENABLE_PCLK_PERIS_SECURE_OTP_CON_APBIF,
+	ENABLE_SCLK_PERIS,
+	ENABLE_SCLK_PERIS_SECURE_SECKEY,
+	ENABLE_SCLK_PERIS_SECURE_CHIPID,
+	ENABLE_SCLK_PERIS_SECURE_TOPRTC,
+	ENABLE_SCLK_PERIS_SECURE_CUSTOM_EFUSE,
+	ENABLE_SCLK_PERIS_SECURE_ANTIRBK_CNT,
+	ENABLE_SCLK_PERIS_SECURE_OTP_CON,
+	ENABLE_IP_PERIS0,
+	ENABLE_IP_PERIS1,
+	ENABLE_IP_PERIS_SECURE_TZPC,
+	ENABLE_IP_PERIS_SECURE_SECKEY,
+	ENABLE_IP_PERIS_SECURE_CHIPID,
+	ENABLE_IP_PERIS_SECURE_TOPRTC,
+	ENABLE_IP_PERIS_SECURE_CUSTOM_EFUSE,
+	ENABLE_IP_PERIS_SECURE_ANTIBRK_CNT,
+	ENABLE_IP_PERIS_SECURE_OTP_CON,
 };
 
 static struct samsung_gate_clock peris_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_PERIS */
+	GATE(CLK_ACLK_AHB2APB_PERIS1P, "aclk_ahb2apb_peris1p", "aclk_peris_66",
+			ENABLE_ACLK_PERIS, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB2APB_PERIS0P, "aclk_ahb2apb_peris0p", "aclk_peris_66",
+			ENABLE_ACLK_PERIS, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_PERISNP_66, "aclk_perisnp_66", "aclk_peris_66",
+			ENABLE_ACLK_PERIS, 0, CLK_IGNORE_UNUSED, 0),
+
 	/* ENABLE_PCLK_PERIS */
 	GATE(CLK_PCLK_HPM_APBIF, "pclk_hpm_apbif", "aclk_peris_66",
 			ENABLE_PCLK_PERIS, 30, CLK_IGNORE_UNUSED, 0),
@@ -989,6 +1044,93 @@ static struct samsung_gate_clock peris_gate_clks[] __initdata = {
 			ENABLE_PCLK_PERIS, 15, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_PCLK_HDMI_CEC, "pclk_hdmi_cec", "aclk_peris_66",
 			ENABLE_PCLK_PERIS, 14, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_TZPC */
+	GATE(CLK_PCLK_TZPC12, "pclk_tzpc12", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 12, 0, 0),
+	GATE(CLK_PCLK_TZPC11, "pclk_tzpc11", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 11, 0, 0),
+	GATE(CLK_PCLK_TZPC10, "pclk_tzpc10", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 10, 0, 0),
+	GATE(CLK_PCLK_TZPC9, "pclk_tzpc9", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 9, 0, 0),
+	GATE(CLK_PCLK_TZPC8, "pclk_tzpc8", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 8, 0, 0),
+	GATE(CLK_PCLK_TZPC7, "pclk_tzpc7", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 7, 0, 0),
+	GATE(CLK_PCLK_TZPC6, "pclk_tzpc6", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 6, 0, 0),
+	GATE(CLK_PCLK_TZPC5, "pclk_tzpc5", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 5, 0, 0),
+	GATE(CLK_PCLK_TZPC4, "pclk_tzpc4", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 4, 0, 0),
+	GATE(CLK_PCLK_TZPC3, "pclk_tzpc3", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 3, 0, 0),
+	GATE(CLK_PCLK_TZPC2, "pclk_tzpc2", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 2, 0, 0),
+	GATE(CLK_PCLK_TZPC1, "pclk_tzpc1", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 1, 0, 0),
+	GATE(CLK_PCLK_TZPC0, "pclk_tzpc0", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TZPC, 0, 0, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_SECKEY_APBIF */
+	GATE(CLK_PCLK_SECKEY_APBIF, "pclk_seckey_apbif", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_SECKEY_APBIF, 0, 0, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_CHIPID_APBIF */
+	GATE(CLK_PCLK_CHIPID_APBIF, "pclk_chipid_apbif", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_CHIPID_APBIF, 0, 0, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_TOPRTC */
+	GATE(CLK_PCLK_TOPRTC, "pclk_toprtc", "aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_TOPRTC, 0, 0, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_CUSTOM_EFUSE_APBIF */
+	GATE(CLK_PCLK_CUSTOM_EFUSE_APBIF, "pclk_custom_efuse_apbif",
+			"aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_CUSTOM_EFUSE_APBIF, 0, 0, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_ANTIRBK_CNT_APBIF */
+	GATE(CLK_PCLK_ANTIRBK_CNT_APBIF, "pclk_antirbk_cnt_apbif",
+			"aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_ANTIRBK_CNT_APBIF, 0, 0, 0),
+
+	/* ENABLE_PCLK_PERIS_SECURE_OTP_CON_APBIF */
+	GATE(CLK_PCLK_OTP_CON_APBIF, "pclk_otp_con_apbif",
+			"aclk_peris_66",
+			ENABLE_PCLK_PERIS_SECURE_OTP_CON_APBIF, 0, 0, 0),
+
+	/* ENABLE_SCLK_PERIS */
+	GATE(CLK_SCLK_ASV_TB, "sclk_asv_tb", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS, 10, 0, 0),
+	GATE(CLK_SCLK_TMU1, "sclk_tmu1", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS, 4, 0, 0),
+	GATE(CLK_SCLK_TMU0, "sclk_tmu0", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS, 3, 0, 0),
+
+	/* ENABLE_SCLK_PERIS_SECURE_SECKEY */
+	GATE(CLK_SCLK_SECKEY, "sclk_seckey", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS_SECURE_SECKEY, 0, 0, 0),
+
+	/* ENABLE_SCLK_PERIS_SECURE_CHIPID */
+	GATE(CLK_SCLK_CHIPID, "sclk_chipid", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS_SECURE_CHIPID, 0, 0, 0),
+
+	/* ENABLE_SCLK_PERIS_SECURE_TOPRTC */
+	GATE(CLK_SCLK_TOPRTC, "sclk_toprtc", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS_SECURE_TOPRTC, 0, 0, 0),
+
+	/* ENABLE_SCLK_PERIS_SECURE_CUSTOM_EFUSE */
+	GATE(CLK_SCLK_CUSTOM_EFUSE, "sclk_custom_efuse", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS_SECURE_CUSTOM_EFUSE, 0, 0, 0),
+
+	/* ENABLE_SCLK_PERIS_SECURE_ANTIRBK_CNT */
+	GATE(CLK_SCLK_ANTIRBK_CNT, "sclk_antirbk_cnt", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS_SECURE_ANTIRBK_CNT, 0, 0, 0),
+
+	/* ENABLE_SCLK_PERIS_SECURE_OTP_CON */
+	GATE(CLK_SCLK_OTP_CON, "sclk_otp_con", "oscclk_efuse_common",
+			ENABLE_SCLK_PERIS_SECURE_OTP_CON, 0, 0, 0),
 };
 
 static struct samsung_cmu_info peris_cmu_info __initdata = {
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index 3d7d0cf..5c34631 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -228,8 +228,39 @@
 #define	CLK_PCLK_WDT_ATLAS		8
 #define	CLK_PCLK_MCT			9
 #define	CLK_PCLK_HDMI_CEC		10
+#define CLK_ACLK_AHB2APB_PERIS1P	11
+#define CLK_ACLK_AHB2APB_PERIS0P	12
+#define CLK_ACLK_PERISNP_66		13
+#define CLK_PCLK_TZPC12			14
+#define CLK_PCLK_TZPC11			15
+#define CLK_PCLK_TZPC10			16
+#define CLK_PCLK_TZPC9			17
+#define CLK_PCLK_TZPC8			18
+#define CLK_PCLK_TZPC7			19
+#define CLK_PCLK_TZPC6			20
+#define CLK_PCLK_TZPC5			21
+#define CLK_PCLK_TZPC4			22
+#define CLK_PCLK_TZPC3			23
+#define CLK_PCLK_TZPC2			24
+#define CLK_PCLK_TZPC1			25
+#define CLK_PCLK_TZPC0			26
+#define CLK_PCLK_SECKEY_APBIF		27
+#define CLK_PCLK_CHIPID_APBIF		28
+#define CLK_PCLK_TOPRTC			29
+#define CLK_PCLK_CUSTOM_EFUSE_APBIF	30
+#define CLK_PCLK_ANTIRBK_CNT_APBIF	31
+#define CLK_PCLK_OTP_CON_APBIF		32
+#define CLK_SCLK_ASV_TB			33
+#define CLK_SCLK_TMU1			34
+#define CLK_SCLK_TMU0			35
+#define CLK_SCLK_SECKEY			36
+#define CLK_SCLK_CHIPID			37
+#define CLK_SCLK_TOPRTC			38
+#define CLK_SCLK_CUSTOM_EFUSE		39
+#define CLK_SCLK_ANTIRBK_CNT		40
+#define CLK_SCLK_OTP_CON		41
 
-#define PERIS_NR_CLK			11
+#define PERIS_NR_CLK			42
 
 /* CMU_FSYS */
 #define CLK_MOUT_ACLK_FSYS_200_USER	1
-- 
1.8.5.5

