Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbbAUG1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:27:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:42797 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbAUG1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:27:03 -0500
X-AuditID: cbfee68d-f79296d000004278-57-54bf46b3700c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: mturquette@linaro.org, kgene@kernel.org, pankaj.dubey@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        sw0312.kim@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/12] clk: samsung: exynos5433: Add MUX clocks of CMU_TOP
 domain
Date: Wed, 21 Jan 2015 15:26:51 +0900
Message-id: <1421821618-8627-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWyRsSkUHeL2/4Qg0+zWS0u79e2uP7lOavF
	pPsTWCz6H79mtri8aw6bxYzz+5gsnk64yGaxaOsXdovDb9pZLWZMfslmsWrXH0YHbo+ds+6y
	e2xa1cnmcefaHjaPvi2rGD0+b5ILYI3isklJzcksSy3St0vgypixdTNLQVtQxYVls9kaGI+7
	dTFyckgImEgcaX3HBGGLSVy4t56ti5GLQ0hgKaPE8fY3TDBFt78cY4dILGKUmHO6hRHCaWKS
	aDnbxgJSxSagJbH/xQ2gdg4OEQFDiZuHlEBqmAXeMEp0v//NClIjLBAmcXjdKnYQm0VAVeLn
	9OfMIDavgIvEo/brUNsUJJYtn8kKModTwFWi/TYTiCkEVHJuSwnISAmBbewS6/9cZ4YYIyDx
	bfIhFpAaCQFZiU0HmCGmSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsY
	gbFw+t+z3h2Mtw9YH2IU4GBU4uF9obg/RIg1say4MvcQoynQhonMUqLJ+cCIyyuJNzQ2M7Iw
	NTE1NjK3NFMS51WU+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbGoNb7bMV7m0cfVgbL7
	JW635ySvZrjJ5uYflSy+sLQupVv+tvOMPRudZwec6Lr47OyWrfZ/3Bg1JcRb57ec2rEhmHFN
	0qnJZ39suJxjd3zL2lWbvjxcvbRW5ereTOnebd/fT798Xqspm/1uRV3nDVEG2ysLQ8TenbPi
	iEvlcGWbEZ4vY/7/+zslluKMREMt5qLiRAChJGRigAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAd3NbvtDDPqfmllc3q9tcf3Lc1aL
	SfcnsFj0P37NbHF51xw2ixnn9zFZPJ1wkc1i0dYv7BaH37SzWsyY/JLNYtWuP4wO3B47Z91l
	99i0qpPN4861PWwefVtWMXp83iQXwBrVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhr
	aGlhrqSQl5ibaqvk4hOg65aZA3SakkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMD
	NJCwhjFjxtbNLAVtQRUXls1ma2A87tbFyMkhIWAicfvLMXYIW0ziwr31bF2MXBxCAosYJeac
	bmGEcJqYJFrOtrGAVLEJaEnsf3EDqIqDQ0TAUOLmISWQGmaBN4wS3e9/s4LUCAuESRxetwps
	KouAqsTP6c+ZQWxeAReJR+3XmSC2KUgsWz6TFWQOp4CrRPttJhBTCKjk3JaSCYy8CxgZVjGK
	phYkFxQnpeca6hUn5haX5qXrJefnbmIER9ozqR2MKxssDjEKcDAq8fC+UNwfIsSaWFZcmXuI
	UYKDWUmEV1ECKMSbklhZlVqUH19UmpNafIjRFOimicxSosn5wCSQVxJvaGxiZmRpZG5oYWRs
	riTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXA2LX2kB3T0nvsqklP/2pW/fc3CNrmrfU7dlmk
	RvnuJS2K7Z8LZ2/dlGfln6TS9H93KX+wYZum8bZHa+2LPDxSzI8oVCkG9Jw5vVt/7XvFT8Gs
	skEx69dv9refxcrKdS1KY9dq8a8dvxIrWDIEDyv3Ghz67XPM33PJxNVy7H4bbhpNW/yROeqk
	EktxRqKhFnNRcSIAPCjfU8oCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the MUX (multiplexer) clocks for CMU_TOP domain of Exynos5433.
CMU_TOP domain provides source clocks to other CMU domains.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/samsung/clk-exynos5433.c   | 90 ++++++++++++++++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h | 31 +++++++++++-
 2 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index 59a87bc..077fa61 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -208,6 +208,7 @@ PNAME(mout_mphy_pll_user_p)	= { "fin_pll", "sclk_mphy_pll", };
 PNAME(mout_mfc_pll_user_p)	= { "fin_pll", "sclk_mfc_pll", };
 PNAME(mout_bus_pll_user_p)	= { "fin_pll", "sclk_bus_pll", };
 PNAME(mout_bus_pll_user_t_p)	= { "fin_pll", "mout_bus_pll_user", };
+PNAME(mout_mphy_pll_user_t_p)	= { "fin_pll", "mout_mphy_pll_user", };
 
 PNAME(mout_bus_mfc_pll_user_p)	= { "mout_bus_pll_user", "mout_mfc_pll_user",};
 PNAME(mout_mfc_bus_pll_user_p)	= { "mout_mfc_pll_user", "mout_bus_pll_user",};
@@ -215,6 +216,12 @@ PNAME(mout_aclk_cam1_552_b_p)	= { "mout_aclk_cam1_552_a",
 				    "mout_mfc_pll_user", };
 PNAME(mout_aclk_cam1_552_a_p)	= { "mout_isp_pll", "mout_bus_pll_user", };
 
+PNAME(mout_aclk_mfc_400_c_p)	= { "mout_aclk_mfc_400_b",
+				    "mout_mphy_pll_user", };
+PNAME(mout_aclk_mfc_400_b_p)	= { "mout_aclk_mfc_400_a",
+				    "mout_bus_pll_user", };
+PNAME(mout_aclk_mfc_400_a_p)	= { "mout_mfc_pll_user", "mout_isp_pll", };
+
 PNAME(mout_bus_mphy_pll_user_p)	= { "mout_bus_pll_user",
 				    "mout_mphy_pll_user", };
 PNAME(mout_aclk_mscl_b_p)	= { "mout_aclk_mscl_400_a",
@@ -231,6 +238,21 @@ PNAME(mout_sclk_mmc0_d_p)	= { "mout_sclk_mmc0_c", "mout_isp_pll", };
 PNAME(mout_sclk_mmc0_c_p)	= { "mout_sclk_mmc0_b", "mout_mphy_pll_user",};
 PNAME(mout_sclk_mmc0_b_p)	= { "mout_sclk_mmc0_a", "mout_mfc_pll_user", };
 
+PNAME(mout_sclk_spdif_p)	= { "sclk_audio0", "sclk_audio1",
+				    "fin_pll", "ioclk_spdif_extclk", };
+PNAME(mout_sclk_audio1_p)	= { "ioclk_audiocdclk1", "fin_pll",
+				    "mout_aud_pll_user_t",};
+PNAME(mout_sclk_audio0_p)	= { "ioclk_audiocdclk0", "fin_pll",
+				    "mout_aud_pll_user_t",};
+
+static struct samsung_fixed_rate_clock top_fixed_clks[] __initdata = {
+	/* Xi2s{0|1}CDCLK input clock for I2S/PCM */
+	FRATE(0, "ioclk_audiocdclk1", NULL, CLK_IS_ROOT, 100000000),
+	FRATE(0, "ioclk_audiocdclk0", NULL, CLK_IS_ROOT, 100000000),
+	/* Xi2s1SDI input clock for SPDIF */
+	FRATE(0, "ioclk_spdif_extclk", NULL, CLK_IS_ROOT, 100000000),
+};
+
 static struct samsung_mux_clock top_mux_clks[] __initdata = {
 	/* MUX_SEL_TOP0 */
 	MUX(CLK_MOUT_AUD_PLL, "mout_aud_pll", mout_aud_pll_p, MUX_SEL_TOP0,
@@ -276,6 +298,14 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
 	MUX(CLK_MOUT_ACLK_G2D_400_A, "mout_aclk_g2d_400_a",
 			mout_bus_mfc_pll_user_p, MUX_SEL_TOP3, 0, 1),
 
+	/* MUX_SEL_TOP4 */
+	MUX(CLK_MOUT_ACLK_MFC_400_C, "mout_aclk_mfc_400_c",
+			mout_aclk_mfc_400_c_p, MUX_SEL_TOP4, 8, 1),
+	MUX(CLK_MOUT_ACLK_MFC_400_B, "mout_aclk_mfc_400_b",
+			mout_aclk_mfc_400_b_p, MUX_SEL_TOP4, 4, 1),
+	MUX(CLK_MOUT_ACLK_MFC_400_A, "mout_aclk_mfc_400_a",
+			mout_aclk_mfc_400_a_p, MUX_SEL_TOP4, 0, 1),
+
 	/* MUX_SEL_TOP_MSCL */
 	MUX(CLK_MOUT_SCLK_JPEG_C, "mout_sclk_jpeg_c", mout_sclk_jpeg_c_p,
 			MUX_SEL_TOP_MSCL, 8, 1),
@@ -284,6 +314,20 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
 	MUX(CLK_MOUT_SCLK_JPEG_A, "mout_sclk_jpeg_a", mout_bus_pll_user_t_p,
 			MUX_SEL_TOP_MSCL, 0, 1),
 
+	/* MUX_SEL_TOP_CAM1 */
+	MUX(CLK_MOUT_SCLK_ISP_SENSOR2, "mout_sclk_isp_sensor2",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_CAM1, 24, 1),
+	MUX(CLK_MOUT_SCLK_ISP_SENSOR1, "mout_sclk_isp_sensor1",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_CAM1, 20, 1),
+	MUX(CLK_MOUT_SCLK_ISP_SENSOR0, "mout_sclk_isp_sensor0",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_CAM1, 16, 1),
+	MUX(CLK_MOUT_SCLK_ISP_UART, "mout_sclk_isp_uart",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_CAM1, 8, 1),
+	MUX(CLK_MOUT_SCLK_ISP_SPI1, "mout_sclk_isp_spi1",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_CAM1, 4, 1),
+	MUX(CLK_MOUT_SCLK_ISP_SPI0, "mout_sclk_isp_spi0",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_CAM1, 0, 1),
+
 	/* MUX_SEL_TOP_FSYS0 */
 	MUX(CLK_MOUT_SCLK_MMC2_B, "mout_sclk_mmc2_b", mout_sclk_mmc2_b_p,
 			MUX_SEL_TOP_FSYS0, 28, 1),
@@ -302,6 +346,16 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
 	MUX(CLK_MOUT_SCLK_MMC0_A, "mout_sclk_mmc0_a", mout_bus_pll_user_t_p,
 			MUX_SEL_TOP_FSYS0, 0, 1),
 
+	/* MUX_SEL_TOP_FSYS1 */
+	MUX(CLK_MOUT_SCLK_PCIE_100, "mout_sclk_pcie_100", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_FSYS1, 12, 1),
+	MUX(CLK_MOUT_SCLK_UFSUNIPRO, "mout_sclk_ufsunipro",
+			mout_mphy_pll_user_t_p, MUX_SEL_TOP_FSYS1, 8, 1),
+	MUX(CLK_MOUT_SCLK_USBHOST30, "mout_sclk_usbhost30",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_FSYS1, 4, 1),
+	MUX(CLK_MOUT_SCLK_USBDRD30, "mout_sclk_usbdrd30",
+			mout_bus_pll_user_t_p, MUX_SEL_TOP_FSYS1, 0, 1),
+
 	/* MUX_SEL_TOP_PERIC0 */
 	MUX(CLK_MOUT_SCLK_SPI4, "mout_sclk_spi4", mout_bus_pll_user_t_p,
 			MUX_SEL_TOP_PERIC0, 28, 1),
@@ -319,6 +373,16 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
 			MUX_SEL_TOP_PERIC0, 4, 1),
 	MUX(CLK_MOUT_SCLK_SPI0, "mout_sclk_spi0", mout_bus_pll_user_t_p,
 			MUX_SEL_TOP_PERIC0, 0, 1),
+
+	/* MUX_SEL_TOP_PERIC1 */
+	MUX(CLK_MOUT_SCLK_SLIMBUS, "mout_sclk_slimbus", mout_aud_pll_user_p,
+			MUX_SEL_TOP_PERIC1, 16, 1),
+	MUX(CLK_MOUT_SCLK_SPDIF, "mout_sclk_spdif", mout_sclk_spdif_p,
+			MUX_SEL_TOP_PERIC1, 12, 2),
+	MUX(CLK_MOUT_SCLK_AUDIO1, "mout_sclk_audio1", mout_sclk_audio1_p,
+			MUX_SEL_TOP_PERIC1, 4, 2),
+	MUX(CLK_MOUT_SCLK_AUDIO0, "mout_sclk_audio0", mout_sclk_audio0_p,
+			MUX_SEL_TOP_PERIC1, 0, 2),
 };
 
 static struct samsung_div_clock top_div_clks[] __initdata = {
@@ -382,6 +446,16 @@ static struct samsung_div_clock top_div_clks[] __initdata = {
 	DIV(CLK_DIV_SCLK_UART0, "div_sclk_uart0", "mout_sclk_uart1",
 			DIV_TOP_PERIC2, 0, 4),
 
+	/* DIV_TOP_PERIC3 */
+	DIV(CLK_DIV_SCLK_I2S1, "div_sclk_i2s1", "sclk_audio1",
+			DIV_TOP_PERIC3, 16, 6),
+	DIV(CLK_DIV_SCLK_PCM1, "div_sclk_pcm1", "sclk_audio1",
+			DIV_TOP_PERIC3, 8, 8),
+	DIV(CLK_DIV_SCLK_AUDIO1, "div_sclk_audio1", "mout_sclk_audio1",
+			DIV_TOP_PERIC3, 4, 4),
+	DIV(CLK_DIV_SCLK_AUDIO0, "div_sclk_audio0", "mout_sclk_audio0",
+			DIV_TOP_PERIC3, 0, 4),
+
 	/* DIV_TOP_PERIC4 */
 	DIV(CLK_DIV_SCLK_SPI4_B, "div_sclk_spi4_b", "div_sclk_spi4_a",
 			DIV_TOP_PERIC4, 16, 8),
@@ -418,6 +492,12 @@ static struct samsung_gate_clock top_gate_clks[] __initdata = {
 			ENABLE_SCLK_TOP_PERIC, 12, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_SPI3_PERIC, "sclk_spi3_peric", "div_sclk_spi3_b",
 			ENABLE_SCLK_TOP_PERIC, 11, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPDIF_PERIC, "sclk_spdif_peric", "mout_sclk_spdif",
+			ENABLE_SCLK_TOP_PERIC, 9, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_I2S1_PERIC, "sclk_i2s1_peric", "div_sclk_i2s1",
+			ENABLE_SCLK_TOP_PERIC, 8, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_PCM1_PERIC, "sclk_pcm1_peric", "div_sclk_pcm1",
+			ENABLE_SCLK_TOP_PERIC, 7, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_UART2_PERIC, "sclk_uart2_peric", "div_sclk_uart2",
 			ENABLE_SCLK_TOP_PERIC, 5, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_UART1_PERIC, "sclk_uart1_peric", "div_sclk_uart1",
@@ -430,6 +510,14 @@ static struct samsung_gate_clock top_gate_clks[] __initdata = {
 			ENABLE_SCLK_TOP_PERIC, 1, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_SPI0_PERIC, "sclk_spi0_peric", "div_sclk_spi0_b",
 			ENABLE_SCLK_TOP_PERIC, 0, CLK_SET_RATE_PARENT, 0),
+
+	/* MUX_ENABLE_TOP_PERIC1 */
+	GATE(CLK_SCLK_SLIMBUS, "sclk_slimbus", "mout_sclk_slimbus",
+			MUX_ENABLE_TOP_PERIC1, 16, 0, 0),
+	GATE(CLK_SCLK_AUDIO1, "sclk_audio1", "div_sclk_audio1",
+			MUX_ENABLE_TOP_PERIC1, 4, 0, 0),
+	GATE(CLK_SCLK_AUDIO0, "sclk_audio0", "div_sclk_audio0",
+			MUX_ENABLE_TOP_PERIC1, 0, 0, 0),
 };
 
 /*
@@ -516,6 +604,8 @@ static struct samsung_cmu_info top_cmu_info __initdata = {
 	.nr_div_clks		= ARRAY_SIZE(top_div_clks),
 	.gate_clks		= top_gate_clks,
 	.nr_gate_clks		= ARRAY_SIZE(top_gate_clks),
+	.fixed_clks		= top_fixed_clks,
+	.nr_fixed_clks		= ARRAY_SIZE(top_fixed_clks),
 	.nr_clk_ids		= TOP_NR_CLK,
 	.clk_regs		= top_clk_regs,
 	.nr_clk_regs		= ARRAY_SIZE(top_clk_regs),
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index 5cd0201..6025006 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -51,6 +51,23 @@
 #define CLK_MOUT_SCLK_SPI2		44
 #define CLK_MOUT_SCLK_SPI1		45
 #define CLK_MOUT_SCLK_SPI0		46
+#define CLK_MOUT_ACLK_MFC_400_C		47
+#define CLK_MOUT_ACLK_MFC_400_B		48
+#define CLK_MOUT_ACLK_MFC_400_A		49
+#define CLK_MOUT_SCLK_ISP_SENSOR2	50
+#define CLK_MOUT_SCLK_ISP_SENSOR1	51
+#define CLK_MOUT_SCLK_ISP_SENSOR0	52
+#define CLK_MOUT_SCLK_ISP_UART		53
+#define CLK_MOUT_SCLK_ISP_SPI1		54
+#define CLK_MOUT_SCLK_ISP_SPI0		55
+#define CLK_MOUT_SCLK_PCIE_100		56
+#define CLK_MOUT_SCLK_UFSUNIPRO		57
+#define CLK_MOUT_SCLK_USBHOST30		58
+#define CLK_MOUT_SCLK_USBDRD30		59
+#define CLK_MOUT_SCLK_SLIMBUS		60
+#define CLK_MOUT_SCLK_SPDIF		61
+#define CLK_MOUT_SCLK_AUDIO1		62
+#define CLK_MOUT_SCLK_AUDIO0		63
 
 #define CLK_DIV_ACLK_FSYS_200		100
 #define CLK_DIV_ACLK_IMEM_SSSX_266	101
@@ -79,6 +96,10 @@
 #define CLK_DIV_SCLK_SPI4_A		124
 #define CLK_DIV_SCLK_SPI3_B		125
 #define CLK_DIV_SCLK_SPI3_A		126
+#define CLK_DIV_SCLK_I2S1		127
+#define CLK_DIV_SCLK_PCM1		128
+#define CLK_DIV_SCLK_AUDIO1		129
+#define CLK_DIV_SCLK_AUDIO0		130
 
 #define CLK_ACLK_PERIC_66		200
 #define CLK_ACLK_PERIS_66		201
@@ -94,8 +115,14 @@
 #define CLK_SCLK_SPI2_PERIC		211
 #define CLK_SCLK_SPI1_PERIC		212
 #define CLK_SCLK_SPI0_PERIC		213
-
-#define TOP_NR_CLK			214
+#define CLK_SCLK_SPDIF_PERIC		214
+#define CLK_SCLK_I2S1_PERIC		215
+#define CLK_SCLK_PCM1_PERIC		216
+#define CLK_SCLK_SLIMBUS		217
+#define CLK_SCLK_AUDIO1			218
+#define CLK_SCLK_AUDIO0			219
+
+#define TOP_NR_CLK			220
 
 /* CMU_CPIF */
 #define CLK_FOUT_MPHY_PLL		1
-- 
1.8.5.5

