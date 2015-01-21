Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbbAUG13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:27:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:26429 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbbAUG1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:27:02 -0500
X-AuditID: cbfee691-f79b86d000004a5a-df-54bf46b481ea
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: mturquette@linaro.org, kgene@kernel.org, pankaj.dubey@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        sw0312.kim@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Inha Song <ideal.song@samsung.com>
Subject: [PATCH v3 03/12] clk: samsung: exynos5433: Add clocks for CMU_PERIC
 domain
Date: Wed, 21 Jan 2015 15:26:52 +0900
Message-id: <1421821618-8627-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkWHeL2/4Qg7k9nBaX92tbXP/ynNVi
	19/7jBaT7k9gseh//JrZ4vKuOWwWM87vY7J4OuEim8WirV/YLQ6/aWe1mDH5JZvFql1/GB14
	PHbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoErY/fLdywFf9wrXj88
	z9rA2GHXxcjJISFgIjHt00ZmCFtM4sK99WwgtpDAUkaJz/2mMDVflv0EquECii9ilPj7fCML
	hNPEJNFyto0FpIpNQEti/4sbQN0cHCIChhI3DymB1DALTGCSWLf2BFiNsECoRPPFF6wgNouA
	qsSUcz3sIDavgIvE6YaljBDbFCSWLZ/JCjKHU8BVov02E4gpBFRybksJyEgJgX3sEhM/XYEa
	IyDxbfIhFpAaCQFZiU0HoH6RlDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNz
	NzECY+L0v2cTdzDeP2B9iFGAg1GJh/eF4v4QIdbEsuLK3EOMpkAbJjJLiSbnAyMvryTe0NjM
	yMLUxNTYyNzSTEmcV0f6Z7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRq2ubbIswl0+Vk6b
	gnZYvT3G8+lO/aPyp5Neyh9j6Xrp+p1h5n7uGYIGp5Y3NX7oNHg5YWbOb5Gwc++zXhhemZY5
	y6nz45RHNjL8Ma/Ynl05mv3i1qa7CfLcoWH5v1/3r9MVWm/0fufixwxBdvwvvxs+zSo4/rU2
	US7pir1/29T+wzdkfmrq71ViKc5INNRiLipOBACQaUWNhAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd3NbvtDDD6/sLa4vF/b4vqX56wW
	u/7eZ7SYdH8Ci0X/49fMFpd3zWGzmHF+H5PF0wkX2SwWbf3CbnH4TTurxYzJL9ksVu36w+jA
	47Fz1l12j02rOtk87lzbw+bRt2UVo8fnTXIBrFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7x
	pmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QPcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUN
	CYLrMTJAAwlrGDN2v3zHUvDHveL1w/OsDYwddl2MnBwSAiYSX5b9ZIawxSQu3FvP1sXIxSEk
	sIhR4u/zjSwQThOTRMvZNhaQKjYBLYn9L24AVXFwiAgYStw8pARSwywwgUli3doTYDXCAqES
	zRdfsILYLAKqElPO9bCD2LwCLhKnG5YyQmxTkFi2fCYryBxOAVeJ9ttMIKYQUMm5LSUTGHkX
	MDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOuWdSOxhXNlgcYhTgYFTi4X2huD9EiDWx
	rLgy9xCjBAezkgivogRQiDclsbIqtSg/vqg0J7X4EKMp0E0TmaVEk/OB6SCvJN7Q2MTMyNLI
	3NDCyNhcSZxXyb4tREggPbEkNTs1tSC1CKaPiYNTqoEx+PMmYc155XYv2zbPYkmdprh3Qaww
	/8Rihb3Gs+2Tdv/O35X0MdJZdqWc+rbmiIn7IjillnrduGE04/766xtnHNvfFr/e0cTgzfEC
	t7n307xLH3AH3lzHupfvz96jrAbV2xcoFKyL/xi+MF/0Y+oqYQHN4uOsGxfo39hz2sbO+XvV
	ikM3az9zKLEUZyQaajEXFScCAAyac4bPAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing divider/gate clocks of CMU_PERIC domain
which includes I2S/PCM/SPDIF/PWM/SLIMBUS IPs. The SPI/I2S may use
external input clock which has 'ioclk_*' prefix.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
[ideal.song: Change clk flags of to pclk_gpio_* clk, pclk_gpio_* should be always on.]
Signed-off-by: Inha Song <ideal.song@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/clk/samsung/clk-exynos5433.c   | 83 +++++++++++++++++++++++++++++++++-
 include/dt-bindings/clock/exynos5433.h | 34 +++++++++++++-
 2 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index 077fa61..cfc9d69 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -251,6 +251,14 @@ static struct samsung_fixed_rate_clock top_fixed_clks[] __initdata = {
 	FRATE(0, "ioclk_audiocdclk0", NULL, CLK_IS_ROOT, 100000000),
 	/* Xi2s1SDI input clock for SPDIF */
 	FRATE(0, "ioclk_spdif_extclk", NULL, CLK_IS_ROOT, 100000000),
+	/* XspiCLK[4:0] input clock for SPI */
+	FRATE(0, "ioclk_spi4_clk_in", NULL, CLK_IS_ROOT, 50000000),
+	FRATE(0, "ioclk_spi3_clk_in", NULL, CLK_IS_ROOT, 50000000),
+	FRATE(0, "ioclk_spi2_clk_in", NULL, CLK_IS_ROOT, 50000000),
+	FRATE(0, "ioclk_spi1_clk_in", NULL, CLK_IS_ROOT, 50000000),
+	FRATE(0, "ioclk_spi0_clk_in", NULL, CLK_IS_ROOT, 50000000),
+	/* Xi2s1SCLK input clock for I2S1_BCLK */
+	FRATE(0, "ioclk_i2s1_bclk_in", NULL, CLK_IS_ROOT, 12288000),
 };
 
 static struct samsung_mux_clock top_mux_clks[] __initdata = {
@@ -756,6 +764,7 @@ CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
  * Register offset definitions for CMU_PERIC
  */
 #define DIV_PERIC			0x0600
+#define DIV_STAT_PERIC			0x0700
 #define ENABLE_ACLK_PERIC		0x0800
 #define ENABLE_PCLK_PERIC0		0x0900
 #define ENABLE_PCLK_PERIC1		0x0904
@@ -766,6 +775,7 @@ CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
 
 static unsigned long peric_clk_regs[] __initdata = {
 	DIV_PERIC,
+	DIV_STAT_PERIC,
 	ENABLE_ACLK_PERIC,
 	ENABLE_PCLK_PERIC0,
 	ENABLE_PCLK_PERIC1,
@@ -775,14 +785,57 @@ static unsigned long peric_clk_regs[] __initdata = {
 	ENABLE_IP_PERIC2,
 };
 
+static struct samsung_div_clock peric_div_clks[] __initdata = {
+	/* DIV_PERIC */
+	DIV(CLK_DIV_SCLK_SCI, "div_sclk_sci", "fin_pll", DIV_PERIC, 4, 4),
+	DIV(CLK_DIV_SCLK_SC_IN, "div_sclk_sc_in", "fin_pll", DIV_PERIC, 0, 4),
+};
+
 static struct samsung_gate_clock peric_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_PERIC */
+	GATE(CLK_ACLK_AHB2APB_PERIC2P, "aclk_ahb2apb_peric2p", "aclk_peric_66",
+			ENABLE_ACLK_PERIC, 3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB2APB_PERIC1P, "aclk_ahb2apb_peric1p", "aclk_peric_66",
+			ENABLE_ACLK_PERIC, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB2APB_PERIC0P, "aclk_ahb2apb_peric0p", "aclk_peric_66",
+			ENABLE_ACLK_PERIC, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_PERICNP_66, "aclk_pericnp_66", "aclk_peric_66",
+			ENABLE_ACLK_PERIC, 0, CLK_IGNORE_UNUSED, 0),
+
 	/* ENABLE_PCLK_PERIC0 */
+	GATE(CLK_PCLK_SCI, "pclk_sci", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			31, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_GPIO_FINGER, "pclk_gpio_finger", "aclk_peric_66",
+			ENABLE_PCLK_PERIC0, 30, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_GPIO_ESE, "pclk_gpio_ese", "aclk_peric_66",
+			ENABLE_PCLK_PERIC0, 29, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_PWM, "pclk_pwm", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			28, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_SPDIF, "pclk_spdif", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			26, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_PCM1, "pclk_pcm1", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			25, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_I2S1, "pclk_i2s", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			24, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_PCLK_SPI2, "pclk_spi2", "aclk_peric_66", ENABLE_PCLK_PERIC0,
 			23, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_PCLK_SPI1, "pclk_spi1", "aclk_peric_66", ENABLE_PCLK_PERIC0,
 			22, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_PCLK_SPI0, "pclk_spi0", "aclk_peric_66", ENABLE_PCLK_PERIC0,
 			21, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_ADCIF, "pclk_adcif", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			20, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_GPIO_TOUCH, "pclk_gpio_touch", "aclk_peric_66",
+			ENABLE_PCLK_PERIC0, 19, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_GPIO_NFC, "pclk_gpio_nfc", "aclk_peric_66",
+			ENABLE_PCLK_PERIC0, 18, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_GPIO_PERIC, "pclk_gpio_peric", "aclk_peric_66",
+			ENABLE_PCLK_PERIC0, 17, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_PMU_PERIC, "pclk_pmu_peric", "aclk_peric_66",
+			ENABLE_PCLK_PERIC0, 16, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_SYSREG_PERIC, "pclk_sysreg_peric", "aclk_peric_66",
+			ENABLE_PCLK_PERIC0, 15,
+			CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_PCLK_UART2, "pclk_uart2", "aclk_peric_66", ENABLE_PCLK_PERIC0,
 			14, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_PCLK_UART1, "pclk_uart1", "aclk_peric_66", ENABLE_PCLK_PERIC0,
@@ -837,15 +890,39 @@ static struct samsung_gate_clock peric_gate_clks[] __initdata = {
 			ENABLE_PCLK_PERIC1, 0, CLK_SET_RATE_PARENT, 0),
 
 	/* ENABLE_SCLK_PERIC */
+	GATE(CLK_SCLK_IOCLK_SPI4, "sclk_ioclk_spi4", "ioclk_spi4_clk_in",
+			ENABLE_SCLK_PERIC, 21, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_IOCLK_SPI3, "sclk_ioclk_spi3", "ioclk_spi3_clk_in",
+			ENABLE_SCLK_PERIC, 20, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_SPI4, "sclk_spi4", "sclk_spi4_peric", ENABLE_SCLK_PERIC,
 			19, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_SPI3, "sclk_spi3", "sclk_spi3_peric", ENABLE_SCLK_PERIC,
 			18, CLK_SET_RATE_PARENT, 0),
-
+	GATE(CLK_SCLK_SCI, "sclk_sci", "div_sclk_sci", ENABLE_SCLK_PERIC,
+			17, 0, 0),
+	GATE(CLK_SCLK_SC_IN, "sclk_sc_in", "div_sclk_sc_in", ENABLE_SCLK_PERIC,
+			16, 0, 0),
+	GATE(CLK_SCLK_PWM, "sclk_pwm", "fin_pll", ENABLE_SCLK_PERIC, 15, 0, 0),
+	GATE(CLK_SCLK_IOCLK_SPI2, "sclk_ioclk_spi2", "ioclk_spi2_clk_in",
+			ENABLE_SCLK_PERIC, 13, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_IOCLK_SPI1, "sclk_ioclk_spi1", "ioclk_spi1_clk_in",
+			ENABLE_SCLK_PERIC, 12,
+			CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_IOCLK_SPI0, "sclk_ioclk_spi0", "ioclk_spi0_clk_in",
+			ENABLE_SCLK_PERIC, 11, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_IOCLK_I2S1_BCLK, "sclk_ioclk_i2s1_bclk",
+			"ioclk_i2s1_bclk_in", ENABLE_SCLK_PERIC, 10,
+			CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPDIF, "sclk_spdif", "sclk_spdif_peric",
+			ENABLE_SCLK_PERIC, 8, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_PCM1, "sclk_pcm1", "sclk_pcm1_peric",
+			ENABLE_SCLK_PERIC, 7, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_I2S1, "sclk_i2s1", "sclk_i2s1_peric",
+			ENABLE_SCLK_PERIC, 6, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_SPI2, "sclk_spi2", "sclk_spi2_peric", ENABLE_SCLK_PERIC,
 			5, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_SPI1, "sclk_spi1", "sclk_spi1_peric", ENABLE_SCLK_PERIC,
-			4, CLK_SET_RATE_PARENT, 0),
+			4, CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_SPI0, "sclk_spi0", "sclk_spi0_peric", ENABLE_SCLK_PERIC,
 			3, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_UART2, "sclk_uart2", "sclk_uart2_peric",
@@ -857,6 +934,8 @@ static struct samsung_gate_clock peric_gate_clks[] __initdata = {
 };
 
 static struct samsung_cmu_info peric_cmu_info __initdata = {
+	.div_clks		= peric_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(peric_div_clks),
 	.gate_clks		= peric_gate_clks,
 	.nr_gate_clks		= ARRAY_SIZE(peric_gate_clks),
 	.nr_clk_ids		= PERIC_NR_CLK,
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index 6025006..62d3ec7 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -181,8 +181,40 @@
 #define CLK_SCLK_UART2			34
 #define CLK_SCLK_UART1			35
 #define CLK_SCLK_UART0			36
+#define CLK_ACLK_AHB2APB_PERIC2P	37
+#define CLK_ACLK_AHB2APB_PERIC1P	38
+#define CLK_ACLK_AHB2APB_PERIC0P	39
+#define CLK_ACLK_PERICNP_66		40
+#define CLK_PCLK_SCI			41
+#define CLK_PCLK_GPIO_FINGER		42
+#define CLK_PCLK_GPIO_ESE		43
+#define CLK_PCLK_PWM			44
+#define CLK_PCLK_SPDIF			45
+#define CLK_PCLK_PCM1			46
+#define CLK_PCLK_I2S1			47
+#define CLK_PCLK_ADCIF			48
+#define CLK_PCLK_GPIO_TOUCH		49
+#define CLK_PCLK_GPIO_NFC		50
+#define CLK_PCLK_GPIO_PERIC		51
+#define CLK_PCLK_PMU_PERIC		52
+#define CLK_PCLK_SYSREG_PERIC		53
+#define CLK_SCLK_IOCLK_SPI4		54
+#define CLK_SCLK_IOCLK_SPI3		55
+#define CLK_SCLK_SCI			56
+#define CLK_SCLK_SC_IN			57
+#define CLK_SCLK_PWM			58
+#define CLK_SCLK_IOCLK_SPI2		59
+#define CLK_SCLK_IOCLK_SPI1		60
+#define CLK_SCLK_IOCLK_SPI0		61
+#define CLK_SCLK_IOCLK_I2S1_BCLK	62
+#define CLK_SCLK_SPDIF			63
+#define CLK_SCLK_PCM1			64
+#define CLK_SCLK_I2S1			65
 
-#define PERIC_NR_CLK			37
+#define CLK_DIV_SCLK_SCI		70
+#define CLK_DIV_SCLK_SC_IN		71
+
+#define PERIC_NR_CLK			72
 
 /* CMU_PERIS */
 #define	CLK_PCLK_HPM_APBIF		1
-- 
1.8.5.5

