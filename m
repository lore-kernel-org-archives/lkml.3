Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaK0HfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:35:25 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52583 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaK0HfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:21 -0500
X-AuditID: cbfee691-f79b86d000004a5a-ff-5476d437c56c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, cw00.choi@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Inha Song <ideal.song@samsung.com>
Subject: [PATCH 05/19] clk: samsung: exynos5433: Add clocks for CMU_PERIC domain
Date: Thu, 27 Nov 2014 16:35:02 +0900
Message-id: <1417073716-22997-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkRNf8SlmIwYQ+SYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Sx2/b3PaDHp/gQWixu/2lgtehdcZbM42/SG3WLK
	n+VMFpseX2O1uLxrDpvFjPP7mCyWXr/IZHHq+mc2i8Nv2lktZkx+yWZxbMYSRotVu/4wWrz8
	eILFQdxjzbw1jB6/f01i9Ng56y67x51re9g8Ni+p97hyoonVo2/LKkaPz5vkAjiiuGxSUnMy
	y1KL9O0SuDImTp7KWtDoVtE18R57A+NOmy5GTg4JAROJawfvsELYYhIX7q1n62Lk4hASWMoo
	censL3aYojO3p7FAJKYzSpw9fh/KaWKSuLXyAVgVm4CWxP4XN9hAbBEBZ4mGqY1MIEXMAlNZ
	JNYtWALUwcEhLBAgca3XEaSGRUBV4tDr6WCreQVcJR7/XQK1TUFi2fKZYHFOATeJ/V8PgtlC
	QDWLvl0BmykhsJRDYvGOp8wQgwQkvk0+BDZfQkBWYtMBZog5khIHV9xgmcAovICRYRWjaGpB
	ckFxUnqRqV5xYm5xaV66XnJ+7iZGYIye/vds4g7G+wesDzEKcDAq8fBaHCgLEWJNLCuuzD3E
	aAq0YSKzlGhyPjAR5JXEGxqbGVmYmpgaG5lbmimJ8+pI/wwWEkhPLEnNTk0tSC2KLyrNSS0+
	xMjEwSnVwFj+blX9089P5pXsPfne3Pkun8L3tWz7Dgvd3Ryr/SO36EwOu/t9V+8Ppz7+cv+g
	tOPm/bq+t+yLH3RacLRUH5625j/jihUPDmjzLJ3s/klkwebtM3fvEiycurX1ZI/0z/PRtdmi
	uTdbF0l76s8UDviZujp8e/Q+kR1X/yxeefG/hl++FPM6mRclSizFGYmGWsxFxYkAwAY73MwC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xoK75lbIQg97JfBaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0slns+nuf0WLS/QksFjd+tbFa9C64ymZxtukNu8WU
	P8uZLDY9vsZqcXnXHDaLGef3MVksvX6RyeLU9c9sFofftLNazJj8ks3i2IwljBardv1htHj5
	8QSLg7jHmnlrGD1+/5rE6LFz1l12jzvX9rB5bF5S73HlRBOrR9+WVYwenzfJBXBENTDaZKQm
	pqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9qaRQlphTChQK
	SCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMmDh5KmtBo1tF18R77A2MO226GDk5JARM
	JM7cnsYCYYtJXLi3nq2LkYtDSGA6o8TZ4/dZIJwmJolbKx+wg1SxCWhJ7H9xgw3EFhFwlmiY
	2sgEUsQsMJVFYt2CJUAdHBzCAgES13odQWpYBFQlDr2ezgpi8wq4Sjz+u4QdYpuCxLLlM8Hi
	nAJuEvu/HgSzhYBqFn27wjSBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAE8Ex6
	B+OqBotDjAIcjEo8vBYHykKEWBPLiitzDzFKcDArifBKLQIK8aYkVlalFuXHF5XmpBYfYjQF
	umois5Rocj4wOeWVxBsam5gZWRqZG1oYGZsrifPeuJkbIiSQnliSmp2aWpBaBNPHxMEp1cCY
	sfv09DWvTO7vZpaSm5qu9GzXmUgBibgTRw+VHdpyuaX9m1PCsx6Wha7n8j9/LX6ooONw8kKS
	37mz76f0/GCbpWiYr6/13kP41WL5GBd5Fr13txj5V+9bfuO0al7b3cUrW89NEDKJP3cycHvm
	5JuKexYopbuY+wktjLnlwseiVPz3hd3B31c+KrEUZyQaajEXFScCAPQcMfYWAwAA
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
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 drivers/clk/samsung/clk-exynos5433.c   | 79 +++++++++++++++++++++++++++++++++-
 include/dt-bindings/clock/exynos5433.h | 34 ++++++++++++++-
 2 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index e0d71fd..11ee2d8 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -259,6 +259,14 @@ static struct samsung_fixed_rate_clock top_fixed_clks[] __initdata = {
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
@@ -763,6 +771,7 @@ CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
  * Register offset definitions for CMU_PERIC
  */
 #define DIV_PERIC			0x0600
+#define DIV_STAT_PERIC			0x0700
 #define ENABLE_ACLK_PERIC		0x0800
 #define ENABLE_PCLK_PERIC0		0x0900
 #define ENABLE_PCLK_PERIC1		0x0904
@@ -773,6 +782,7 @@ CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
 
 static unsigned long peric_clk_regs[] __initdata = {
 	DIV_PERIC,
+	DIV_STAT_PERIC,
 	ENABLE_ACLK_PERIC,
 	ENABLE_PCLK_PERIC0,
 	ENABLE_PCLK_PERIC1,
@@ -782,14 +792,56 @@ static unsigned long peric_clk_regs[] __initdata = {
 	ENABLE_IP_PERIC2,
 };
 
+static struct samsung_div_clock peric_div_clks[] __initdata = {
+	/* DIV_PERIC */
+	DIV(CLK_DIV_SCLK_SCI, "div_sclk_sci", "fin_pll", DIV_PERIC, 4, 8),
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
+			ENABLE_PCLK_PERIC0, 15, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_PCLK_UART2, "pclk_uart2", "aclk_peric_66", ENABLE_PCLK_PERIC0,
 			14, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_PCLK_UART1, "pclk_uart1", "aclk_peric_66", ENABLE_PCLK_PERIC0,
@@ -844,11 +896,34 @@ static struct samsung_gate_clock peric_gate_clks[] __initdata = {
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
+			ENABLE_SCLK_PERIC, 12, CLK_SET_RATE_PARENT, 0),
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
@@ -864,6 +939,8 @@ static struct samsung_gate_clock peric_gate_clks[] __initdata = {
 };
 
 static struct samsung_cmu_info peric_cmu_info __initdata = {
+	.div_clks		= peric_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(peric_div_clks),
 	.gate_clks		= peric_gate_clks,
 	.nr_gate_clks		= ARRAY_SIZE(peric_gate_clks),
 	.nr_clk_ids		= PERIC_NR_CLK,
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index 3e9960b..3d7d0cf 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -182,8 +182,40 @@
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

