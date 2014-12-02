Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaLBI4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:56:52 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31595 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaLBIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:04 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-b4-547d7d3689f6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/19] clk: samsung: exynos5433: Add clocks for CMU_MIF domain
Date: Tue, 02 Dec 2014 17:49:43 +0900
Message-id: <1417510196-6714-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsWyRsSkRNestjbE4MgkS4vHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azWLT1C7vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGVMXV5d
	8LyPqeLCyU7mBsZlrxm7GDk5JARMJNZM+sECYYtJXLi3nq2LkYtDSGApo8STK/uYYIputu9l
	gkhMZ5Ro3NcA5TQxSTy4sQFsFJuAlsT+FzfYQGwRAWeJhqmNYEXMAm+YJfbc3w22Q1jAT+LQ
	thZ2EJtFQFXi0u0nzCA2r4CLxNvd/VB3KEgsWz6TFcTmFHCV6DrTB1YvBFTzq/UjO0TNVA6J
	K/t1IeYISHybfAiolwMoLiux6QAzRImkxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSiV5yYW1ya
	l66XnJ+7iREYkaf/PZuwg/HeAetDjAIcjEo8vCfO14QIsSaWFVfmHmI0BdowkVlKNDkfGPd5
	JfGGxmZGFqYmpsZG5pZmSuK8r6V+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgDBW+UJ9X
	0LPn+Fu51hidlov8TJ2tS8oK8qf87Gs6pbo6/r9q4GJdac4nmgfUDxjHN546lbvXzmTC3V3n
	j0o3bX488+/P93m/F1bx87m+Y7pvVb17a+b2CwW+2ilNVuftjlyr9om9FKKRo3R7uz6/2XG5
	61pKMWtv2Sqcna15w2FlhOaEEzUqSizFGYmGWsxFxYkAWpsMMMMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQV2z2toQg5m96haP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbfY9Pgaq8Xl
	XXPYLGac3wfUf+cfm8XS6xeZLE5d/8xmsWjrF3aLw2/aWS1mTH7JZrFq1x9Gi5cfT7A4iHms
	mbeG0eP3r0mMHjtn3WX32Lyk3uPKiSZWj74tqxg9Pm+SC2CPamC0yUhNTEktUkjNS85PycxL
	t1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAF6TUmhLDGnFCgUkFhcrKRvh2lCaIib
	rgVMY4Sub0gQXI+RARpIWMOYMXV5dcHzPqaKCyc7mRsYl71m7GLk5JAQMJG42b6XCcIWk7hw
	bz1bFyMXh5DAdEaJxn0NTBBOE5PEgxsbwDrYBLQk9r+4wQZiiwg4SzRMbQQrYhZ4wyyx5/5u
	FpCEsICfxKFtLewgNouAqsSl20+YQWxeAReJt7v7WSDWKUgsWz6TFcTmFHCV6DrTB1YvBFTz
	q/Uj+wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgiP+mdQOxpUNFocYBTgYlXh4
	T5yvCRFiTSwrrsw9xCjBwawkwvvLuDZEiDclsbIqtSg/vqg0J7X4EKMp0FUTmaVEk/OBySiv
	JN7Q2MTMyNLI3NDCyNhcSZz3xs3cECGB9MSS1OzU1ILUIpg+Jg5OqQZGRYsYqZwtXjEcSXwZ
	rP5/BQQO+sek1DTcn7SRsafBxKnq37ofG2MX/zCZZcCwTKp3Te+36rt5EfPKOo8cYXsmfrJX
	rYz//LOXM3fucrMwbF4RGthfHGQl/vuk2srcOxc7fXTTwh6K6a5bsPuF/cT5r04bPnsXW97+
	NJ0h8sTzy9sW/ztw1VlViaU4I9FQi7moOBEAf5s+uw4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the mux/divider/gate clock fo CMU_MIF domain which includes
the clocks for DMC(DRAM memory controller) and CCI(Cache Coherent Interconnect).
The CMU_MIF domain provides the source clocks for CMU_DISP/CMU_BUS2.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 drivers/clk/samsung/clk-exynos5433.c   | 590 +++++++++++++++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h | 190 ++++++++++-
 2 files changed, 779 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index 4dec9fc..10197a1 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -737,6 +737,66 @@ CLK_OF_DECLARE(exynos5433_cmu_cpif, "samsung,exynos5433-cmu-cpif",
 #define MFC_PLL_CON0			0x0130
 #define MFC_PLL_CON1			0x0134
 #define MFC_PLL_FREQ_DET		0x013c
+#define MUX_SEL_MIF0			0x0200
+#define MUX_SEL_MIF1			0x0204
+#define MUX_SEL_MIF2			0x0208
+#define MUX_SEL_MIF3			0x020c
+#define MUX_SEL_MIF4			0x0210
+#define MUX_SEL_MIF5			0x0214
+#define MUX_SEL_MIF6			0x0218
+#define MUX_SEL_MIF7			0x021c
+#define MUX_ENABLE_MIF0			0x0300
+#define MUX_ENABLE_MIF1			0x0304
+#define MUX_ENABLE_MIF2			0x0308
+#define MUX_ENABLE_MIF3			0x030c
+#define MUX_ENABLE_MIF4			0x0310
+#define MUX_ENABLE_MIF5			0x0314
+#define MUX_ENABLE_MIF6			0x0318
+#define MUX_ENABLE_MIF7			0x031c
+#define MUX_STAT_MIF0			0x0400
+#define MUX_STAT_MIF1			0x0404
+#define MUX_STAT_MIF2			0x0408
+#define MUX_STAT_MIF3			0x040c
+#define MUX_STAT_MIF4			0x0410
+#define MUX_STAT_MIF5			0x0414
+#define MUX_STAT_MIF6			0x0418
+#define MUX_STAT_MIF7			0x041c
+#define DIV_MIF1			0x0604
+#define DIV_MIF2			0x0608
+#define DIV_MIF3			0x060c
+#define DIV_MIF4			0x0610
+#define DIV_MIF5			0x0614
+#define DIV_MIF_PLL_FREQ_DET		0x0618
+#define DIV_STAT_MIF1			0x0704
+#define DIV_STAT_MIF2			0x0708
+#define DIV_STAT_MIF3			0x070c
+#define DIV_STAT_MIF4			0x0710
+#define DIV_STAT_MIF5			0x0714
+#define DIV_STAT_MIF_PLL_FREQ_DET	0x0718
+#define ENABLE_ACLK_MIF0		0x0800
+#define ENABLE_ACLK_MIF1		0x0804
+#define ENABLE_ACLK_MIF2		0x0808
+#define ENABLE_ACLK_MIF3		0x080c
+#define ENABLE_PCLK_MIF			0x0900
+#define ENABLE_PCLK_MIF_SECURE_DREX0_TZ	0x0904
+#define ENABLE_PCLK_MIF_SECURE_DREX1_TZ	0x0908
+#define ENABLE_PCLK_MIF_SECURE_MONOTONIC_CNT	0x090c
+#define ENABLE_PCLK_MIF_SECURE_RTC	0x0910
+#define ENABLE_SCLK_MIF			0x0a00
+#define ENABLE_IP_MIF0			0x0b00
+#define ENABLE_IP_MIF1			0x0b04
+#define ENABLE_IP_MIF2			0x0b08
+#define ENABLE_IP_MIF3			0x0b0c
+#define ENABLE_IP_MIF_SECURE_DREX0_TZ	0x0b10
+#define ENABLE_IP_MIF_SECURE_DREX1_TZ	0x0b14
+#define ENABLE_IP_MIF_SECURE_MONOTONIC_CNT	0x0b18
+#define ENABLE_IP_MIF_SECURE_RTC	0x0b1c
+#define CLKOUT_CMU_MIF			0x0c00
+#define CLKOUT_CMU_MIF_DIV_STAT		0x0c04
+#define DREX_FREQ_CTRL0			0x1000
+#define DREX_FREQ_CTRL1			0x1004
+#define PAUSE				0x1008
+#define DDRPHY_LOCK_CTRL		0x100c
 
 static unsigned long mif_clk_regs[] __initdata = {
 	MEM0_PLL_LOCK,
@@ -755,6 +815,66 @@ static unsigned long mif_clk_regs[] __initdata = {
 	MFC_PLL_CON0,
 	MFC_PLL_CON1,
 	MFC_PLL_FREQ_DET,
+	MUX_SEL_MIF0,
+	MUX_SEL_MIF1,
+	MUX_SEL_MIF2,
+	MUX_SEL_MIF3,
+	MUX_SEL_MIF4,
+	MUX_SEL_MIF5,
+	MUX_SEL_MIF6,
+	MUX_SEL_MIF7,
+	MUX_ENABLE_MIF0,
+	MUX_ENABLE_MIF1,
+	MUX_ENABLE_MIF2,
+	MUX_ENABLE_MIF3,
+	MUX_ENABLE_MIF4,
+	MUX_ENABLE_MIF5,
+	MUX_ENABLE_MIF6,
+	MUX_ENABLE_MIF7,
+	MUX_STAT_MIF0,
+	MUX_STAT_MIF1,
+	MUX_STAT_MIF2,
+	MUX_STAT_MIF3,
+	MUX_STAT_MIF4,
+	MUX_STAT_MIF5,
+	MUX_STAT_MIF6,
+	MUX_STAT_MIF7,
+	DIV_MIF1,
+	DIV_MIF2,
+	DIV_MIF3,
+	DIV_MIF4,
+	DIV_MIF5,
+	DIV_MIF_PLL_FREQ_DET,
+	DIV_STAT_MIF1,
+	DIV_STAT_MIF2,
+	DIV_STAT_MIF3,
+	DIV_STAT_MIF4,
+	DIV_STAT_MIF5,
+	DIV_STAT_MIF_PLL_FREQ_DET,
+	ENABLE_ACLK_MIF0,
+	ENABLE_ACLK_MIF1,
+	ENABLE_ACLK_MIF2,
+	ENABLE_ACLK_MIF3,
+	ENABLE_PCLK_MIF,
+	ENABLE_PCLK_MIF_SECURE_DREX0_TZ,
+	ENABLE_PCLK_MIF_SECURE_DREX1_TZ,
+	ENABLE_PCLK_MIF_SECURE_MONOTONIC_CNT,
+	ENABLE_PCLK_MIF_SECURE_RTC,
+	ENABLE_SCLK_MIF,
+	ENABLE_IP_MIF0,
+	ENABLE_IP_MIF1,
+	ENABLE_IP_MIF2,
+	ENABLE_IP_MIF3,
+	ENABLE_IP_MIF_SECURE_DREX0_TZ,
+	ENABLE_IP_MIF_SECURE_DREX1_TZ,
+	ENABLE_IP_MIF_SECURE_MONOTONIC_CNT,
+	ENABLE_IP_MIF_SECURE_RTC,
+	CLKOUT_CMU_MIF,
+	CLKOUT_CMU_MIF_DIV_STAT,
+	DREX_FREQ_CTRL0,
+	DREX_FREQ_CTRL1,
+	PAUSE,
+	DDRPHY_LOCK_CTRL,
 };
 
 static struct samsung_pll_clock mif_pll_clks[] __initdata = {
@@ -768,9 +888,479 @@ static struct samsung_pll_clock mif_pll_clks[] __initdata = {
 		MFC_PLL_LOCK, MFC_PLL_CON0, exynos5443_pll_rates),
 };
 
+/* list of all parent clock list */
+PNAME(mout_mfc_pll_div2_p)	= { "mout_mfc_pll", "dout_mfc_pll", };
+PNAME(mout_bus_pll_div2_p)	= { "mout_bus_pll", "dout_bus_pll", };
+PNAME(mout_mem1_pll_div2_p)	= { "mout_mem1_pll", "dout_mem1_pll", };
+PNAME(mout_mem0_pll_div2_p)	= { "mout_mem0_pll", "dout_mem0_pll", };
+PNAME(mout_mfc_pll_p)		= { "fin_pll", "fout_mfc_pll", };
+PNAME(mout_bus_pll_p)		= { "fin_pll", "fout_bus_pll", };
+PNAME(mout_mem1_pll_p)		= { "fin_pll", "fout_mem1_pll", };
+PNAME(mout_mem0_pll_p)		= { "fin_pll", "fout_mem0_pll", };
+
+PNAME(mout_clk2x_phy_c_p)	= { "mout_mem0_pll_div2", "mout_clkm_phy_b", };
+PNAME(mout_clk2x_phy_b_p)	= { "mout_bus_pll_div2", "mout_clkm_phy_a", };
+PNAME(mout_clk2x_phy_a_p)	= { "mout_bus_pll_div2", "mout_mfc_pll_div2", };
+PNAME(mout_clkm_phy_c_p)	= { "mout_mem0_pll_div2", "mout_clkm_phy_b", };
+PNAME(mout_clkm_phy_b_p)	= { "mout_mem1_pll_div2", "mout_clkm_phy_a", };
+PNAME(mout_clkm_phy_a_p)	= { "mout_bus_pll_div2", "mout_mfc_pll_div2", };
+
+PNAME(mout_aclk_mifnm_200_p)	= { "mout_mem0_pll_div2", "div_mif_pre", };
+PNAME(mout_aclk_mifnm_400_p)	= { "mout_mem1_pll_div2", "mout_bus_pll_div2",};
+
+PNAME(mout_aclk_disp_333_b_p)	= { "mout_aclk_disp_333_a",
+				    "mout_bus_pll_div2", };
+PNAME(mout_aclk_disp_333_a_p)	= { "mout_mfc_pll_div2", "sclk_mphy_pll", };
+
+PNAME(mout_sclk_decon_vclk_c_p)	= { "mout_sclk_decon_vclk_b",
+				    "sclk_mphy_pll", };
+PNAME(mout_sclk_decon_vclk_b_p)	= { "mout_sclk_decon_vclk_a",
+				    "mout_mfc_pll_div2", };
+PNAME(mout_sclk_decon_vclk_a_p)	= { "fin_pll", "mout_bus_pll_div2", };
+PNAME(mout_sclk_decon_eclk_c_p)	= { "mout_sclk_decon_eclk_b",
+				    "sclk_mphy_pll", };
+PNAME(mout_sclk_decon_eclk_b_p)	= { "mout_sclk_decon_eclk_a",
+				    "mout_mfc_pll_div2", };
+PNAME(mout_sclk_decon_eclk_a_p)	= { "fin_pll", "mout_bus_pll_div2", };
+
+PNAME(mout_sclk_decon_tv_eclk_c_p) = { "mout_sclk_decon_tv_eclk_b",
+				       "sclk_mphy_pll", };
+PNAME(mout_sclk_decon_tv_eclk_b_p) = { "mout_sclk_decon_tv_eclk_a",
+				       "mout_mfc_pll_div2", };
+PNAME(mout_sclk_decon_tv_eclk_a_p) = { "fin_pll", "mout_bus_pll_div2", };
+PNAME(mout_sclk_dsd_c_p)	= { "mout_sclk_dsd_b", "mout_bus_pll_div2", };
+PNAME(mout_sclk_dsd_b_p)	= { "mout_sclk_dsd_a", "sclk_mphy_pll", };
+PNAME(mout_sclk_dsd_a_p)	= { "fin_pll", "mout_mfc_pll_div2", };
+
+PNAME(mout_sclk_dsim0_c_p)	= { "mout_sclk_dsim0_b", "sclk_mphy_pll", };
+PNAME(mout_sclk_dsim0_b_p)	= { "mout_sclk_dsim0_a", "mout_mfc_pll_div2" };
+PNAME(mout_sclk_dsim0_a_p)	= { "fin_pll", "mout_bus_pll_div2", };
+
+PNAME(mout_sclk_decon_tv_vclk_c_p) = { "mout_sclk_decon_tv_vclk_b",
+				       "sclk_mphy_pll", };
+PNAME(mout_sclk_decon_tv_vclk_b_p) = { "mout_sclk_decon_tv_vclk_a",
+				       "mout_mfc_pll_div2", };
+PNAME(mout_sclk_decon_tv_vclk_a_p) = { "fin_pll", "mout_bus_pll_div2", };
+PNAME(mout_sclk_dsim1_c_p)	= { "mout_sclk_dsim1_b", "sclk_mphy_pll", };
+PNAME(mout_sclk_dsim1_b_p)	= { "mout_sclk_dsim1_a", "mout_mfc_pll_div2",};
+PNAME(mout_sclk_dsim1_a_p)	= { "fin_pll", "mout_bus_pll_div2", };
+
+static struct samsung_fixed_factor_clock mif_fixed_factor_clks[] __initdata = {
+	/* dout_{mfc|bus|mem1|mem0}_pll is half fixed rate from parent mux */
+	FFACTOR(CLK_DOUT_MFC_PLL, "dout_mfc_pll", "mout_mfc_pll", 1, 1, 0),
+	FFACTOR(CLK_DOUT_BUS_PLL, "dout_bus_pll", "mout_bus_pll", 1, 1, 0),
+	FFACTOR(CLK_DOUT_MEM1_PLL, "dout_mem1_pll", "mout_mem1_pll", 1, 1, 0),
+	FFACTOR(CLK_DOUT_MEM0_PLL, "dout_mem0_pll", "mout_mem0_pll", 1, 1, 0),
+};
+
+static struct samsung_mux_clock mif_mux_clks[] __initdata = {
+	/* MUX_SEL_MIF0 */
+	MUX(CLK_MOUT_MFC_PLL_DIV2, "mout_mfc_pll_div2", mout_mfc_pll_div2_p,
+			MUX_SEL_MIF0, 28, 1),
+	MUX(CLK_MOUT_BUS_PLL_DIV2, "mout_bus_pll_div2", mout_bus_pll_div2_p,
+			MUX_SEL_MIF0, 24, 1),
+	MUX(CLK_MOUT_MEM1_PLL_DIV2, "mout_mem1_pll_div2", mout_mem1_pll_div2_p,
+			MUX_SEL_MIF0, 20, 1),
+	MUX(CLK_MOUT_MEM0_PLL_DIV2, "mout_mem0_pll_div2", mout_mem0_pll_div2_p,
+			MUX_SEL_MIF0, 16, 1),
+	MUX(CLK_MOUT_MFC_PLL, "mout_mfc_pll", mout_mfc_pll_p, MUX_SEL_MIF0,
+			12, 1),
+	MUX(CLK_MOUT_BUS_PLL, "mout_bus_pll", mout_bus_pll_p, MUX_SEL_MIF0,
+			8, 1),
+	MUX(CLK_MOUT_MEM1_PLL, "mout_mem1_pll", mout_mem1_pll_p, MUX_SEL_MIF0,
+			4, 1),
+	MUX(CLK_MOUT_MEM0_PLL, "mout_mem0_pll", mout_mem0_pll_p, MUX_SEL_MIF0,
+			0, 1),
+
+	/* MUX_SEL_MIF1 */
+	MUX(CLK_MOUT_CLK2X_PHY_C, "mout_clk2x_phy_c", mout_clk2x_phy_c_p,
+			MUX_SEL_MIF1, 24, 1),
+	MUX(CLK_MOUT_CLK2X_PHY_B, "mout_clk2x_phy_b", mout_clk2x_phy_b_p,
+			MUX_SEL_MIF1, 20, 1),
+	MUX(CLK_MOUT_CLK2X_PHY_A, "mout_clk2x_phy_a", mout_clk2x_phy_a_p,
+			MUX_SEL_MIF1, 16, 1),
+	MUX(CLK_MOUT_CLKM_PHY_C, "mout_clkm_phy_c", mout_clkm_phy_c_p,
+			MUX_SEL_MIF1, 12, 1),
+	MUX(CLK_MOUT_CLKM_PHY_B, "mout_clkm_phy_b", mout_clkm_phy_b_p,
+			MUX_SEL_MIF1, 8, 1),
+	MUX(CLK_MOUT_CLKM_PHY_A, "mout_clkm_phy_a", mout_clkm_phy_a_p,
+			MUX_SEL_MIF1, 4, 1),
+
+	/* MUX_SEL_MIF2 */
+	MUX(CLK_MOUT_ACLK_MIFNM_200, "mout_aclk_mifnm_200",
+			mout_aclk_mifnm_200_p, MUX_SEL_MIF2, 8, 1),
+	MUX(CLK_MOUT_ACLK_MIFNM_400, "mout_aclk_mifnm_400",
+			mout_aclk_mifnm_400_p, MUX_SEL_MIF2, 0, 1),
+
+	/* MUX_SEL_MIF3 */
+	MUX(CLK_MOUT_ACLK_DISP_333_B, "mout_aclk_disp_333_b",
+			mout_aclk_disp_333_b_p, MUX_SEL_MIF3, 4, 1),
+	MUX(CLK_MOUT_ACLK_DISP_333_A, "mout_aclk_disp_333_a",
+			mout_aclk_disp_333_a_p, MUX_SEL_MIF3, 0, 1),
+
+	/* MUX_SEL_MIF4 */
+	MUX(CLK_MOUT_SCLK_DECON_VCLK_C, "mout_sclk_decon_vclk_c",
+			mout_sclk_decon_vclk_c_p, MUX_SEL_MIF4, 24, 1),
+	MUX(CLK_MOUT_SCLK_DECON_VCLK_B, "mout_sclk_decon_vclk_b",
+			mout_sclk_decon_vclk_b_p, MUX_SEL_MIF4, 20, 1),
+	MUX(CLK_MOUT_SCLK_DECON_VCLK_A, "mout_sclk_decon_vclk_a",
+			mout_sclk_decon_vclk_a_p, MUX_SEL_MIF4, 16, 1),
+	MUX(CLK_MOUT_SCLK_DECON_ECLK_C, "mout_sclk_decon_eclk_c",
+			mout_sclk_decon_eclk_c_p, MUX_SEL_MIF4, 8, 1),
+	MUX(CLK_MOUT_SCLK_DECON_ECLK_B, "mout_sclk_decon_eclk_b",
+			mout_sclk_decon_eclk_b_p, MUX_SEL_MIF4, 4, 1),
+	MUX(CLK_MOUT_SCLK_DECON_ECLK_A, "mout_sclk_decon_eclk_a",
+			mout_sclk_decon_eclk_a_p, MUX_SEL_MIF4, 0, 1),
+
+	/* MUX_SEL_MIF5 */
+	MUX(CLK_MOUT_SCLK_DECON_TV_ECLK_C, "mout_sclk_decon_tv_eclk_c",
+			mout_sclk_decon_tv_eclk_c_p, MUX_SEL_MIF5, 24, 1),
+	MUX(CLK_MOUT_SCLK_DECON_TV_ECLK_B, "mout_sclk_decon_tv_eclk_b",
+			mout_sclk_decon_tv_eclk_b_p, MUX_SEL_MIF5, 20, 1),
+	MUX(CLK_MOUT_SCLK_DECON_TV_ECLK_A, "mout_sclk_decon_tv_eclk_a",
+			mout_sclk_decon_tv_eclk_a_p, MUX_SEL_MIF5, 16, 1),
+	MUX(CLK_MOUT_SCLK_DSD_C, "mout_sclk_dsd_c", mout_sclk_dsd_c_p,
+			MUX_SEL_MIF5, 8, 1),
+	MUX(CLK_MOUT_SCLK_DSD_B, "mout_sclk_dsd_b", mout_sclk_dsd_b_p,
+			MUX_SEL_MIF5, 4, 1),
+	MUX(CLK_MOUT_SCLK_DSD_A, "mout_sclk_dsd_a", mout_sclk_dsd_a_p,
+			MUX_SEL_MIF5, 0, 1),
+
+	/* MUX_SEL_MIF6 */
+	MUX(CLK_MOUT_SCLK_DSIM0_C, "mout_sclk_dsim0_c", mout_sclk_dsim0_c_p,
+			MUX_SEL_MIF6, 8, 1),
+	MUX(CLK_MOUT_SCLK_DSIM0_B, "mout_sclk_dsim0_b", mout_sclk_dsim0_b_p,
+			MUX_SEL_MIF6, 4, 1),
+	MUX(CLK_MOUT_SCLK_DSIM0_A, "mout_sclk_dsim0_a", mout_sclk_dsim0_a_p,
+			MUX_SEL_MIF6, 0, 1),
+
+	/* MUX_SEL_MIF7 */
+	MUX(CLK_MOUT_SCLK_DECON_TV_VCLK_C, "mout_sclk_decon_tv_vclk_c",
+			mout_sclk_decon_tv_vclk_c_p, MUX_SEL_MIF7, 24, 1),
+	MUX(CLK_MOUT_SCLK_DECON_TV_VCLK_B, "mout_sclk_decon_tv_vclk_b",
+			mout_sclk_decon_tv_vclk_b_p, MUX_SEL_MIF7, 20, 1),
+	MUX(CLK_MOUT_SCLK_DECON_TV_VCLK_A, "mout_sclk_decon_tv_vclk_a",
+			mout_sclk_decon_tv_vclk_a_p, MUX_SEL_MIF7, 16, 1),
+	MUX(CLK_MOUT_SCLK_DSIM1_C, "mout_sclk_dsim1_c", mout_sclk_dsim1_c_p,
+			MUX_SEL_MIF7, 8, 1),
+	MUX(CLK_MOUT_SCLK_DSIM1_B, "mout_sclk_dsim1_b", mout_sclk_dsim1_b_p,
+			MUX_SEL_MIF7, 4, 1),
+	MUX(CLK_MOUT_SCLK_DSIM1_A, "mout_sclk_dsim1_a", mout_sclk_dsim1_a_p,
+			MUX_SEL_MIF7, 0, 1),
+};
+
+static struct samsung_div_clock mif_div_clks[] __initdata = {
+	/* DIV_MIF1 */
+	DIV(CLK_DIV_SCLK_HPM_MIF, "div_sclk_hpm_mif", "div_clk2x_phy",
+			DIV_MIF1, 16, 2),
+	DIV(CLK_DIV_ACLK_DREX1, "div_aclk_drex1", "div_clk2x_phy", DIV_MIF1,
+			12, 2),
+	DIV(CLK_DIV_ACLK_DREX0, "div_aclk_drex0", "div_clk2x_phy", DIV_MIF1,
+			8, 2),
+	DIV(CLK_DIV_CLK2XPHY, "div_clk2x_phy", "mout_clk2x_phy_c", DIV_MIF1,
+			4, 4),
+
+	/* DIV_MIF2 */
+	DIV(CLK_DIV_ACLK_MIF_266, "div_aclk_mif_266", "mout_bus_pll_div2",
+			DIV_MIF2, 20, 3),
+	DIV(CLK_DIV_ACLK_MIFND_133, "div_aclk_mifnd_133", "div_mif_pre",
+			DIV_MIF2, 16, 4),
+	DIV(CLK_DIV_ACLK_MIF_133, "div_aclk_mif_133", "div_mif_pre",
+			DIV_MIF2, 12, 4),
+	DIV(CLK_DIV_ACLK_MIFNM_200, "div_aclk_mifnm_200",
+			"mout_aclk_mifnm_200", DIV_MIF2, 8, 3),
+	DIV(CLK_DIV_ACLK_MIF_200, "div_aclk_mif_200", "div_aclk_mif_400",
+			DIV_MIF2, 4, 2),
+	DIV(CLK_DIV_ACLK_MIF_400, "div_aclk_mif_400", "mout_aclk_mifnm_400",
+			DIV_MIF2, 0, 3),
+
+	/* DIV_MIF3 */
+	DIV(CLK_DIV_ACLK_BUS2_400, "div_aclk_bus2_400", "div_mif_pre",
+			DIV_MIF3, 16, 4),
+	DIV(CLK_DIV_ACLK_DISP_333, "div_aclk_disp_333", "mout_aclk_disp_333_b",
+			DIV_MIF3, 4, 3),
+	DIV(CLK_DIV_ACLK_CPIF_200, "div_aclk_cpif_200", "mout_aclk_mifnm_200",
+			DIV_MIF3, 0, 3),
+
+	/* DIV_MIF4 */
+	DIV(CLK_DIV_SCLK_DSIM1, "div_sclk_dsim1", "mout_sclk_dsim1_c",
+			DIV_MIF4, 24, 4),
+	DIV(CLK_DIV_SCLK_DECON_TV_VCLK, "div_sclk_decon_tv_vclk",
+			"mout_sclk_decon_tv_vclk_c", DIV_MIF4, 20, 4),
+	DIV(CLK_DIV_SCLK_DSIM0, "div_sclk_dsim0", "mout_sclk_dsim0_c",
+			DIV_MIF4, 16, 4),
+	DIV(CLK_DIV_SCLK_DSD, "div_sclk_dsd", "mout_sclk_dsd_c",
+			DIV_MIF4, 12, 4),
+	DIV(CLK_DIV_SCLK_DECON_TV_ECLK, "div_sclk_decon_tv_eclk",
+			"mout_sclk_decon_tv_eclk_c", DIV_MIF4, 8, 4),
+	DIV(CLK_DIV_SCLK_DECON_VCLK, "div_sclk_decon_vclk",
+			"mout_sclk_decon_vclk_c", DIV_MIF4, 4, 4),
+	DIV(CLK_DIV_SCLK_DECON_ECLK, "div_sclk_decon_eclk",
+			"mout_sclk_decon_eclk_c", DIV_MIF4, 0, 4),
+
+	/* DIV_MIF5 */
+	DIV(CLK_DIV_MIF_PRE, "div_mif_pre", "mout_bus_pll_div2", DIV_MIF5,
+			0, 3),
+};
+
+static struct samsung_gate_clock mif_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_MIF0 */
+	GATE(CLK_CLK2X_PHY1, "clk2k_phy1", "div_clk2x_phy", ENABLE_ACLK_MIF0,
+			19, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_CLK2X_PHY0, "clk2x_phy0", "div_clk2x_phy", ENABLE_ACLK_MIF0,
+			18, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_CLKM_PHY1, "clkm_phy1", "mout_clkm_phy_c", ENABLE_ACLK_MIF0,
+			17, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_CLKM_PHY0, "clkm_phy0", "mout_clkm_phy_c", ENABLE_ACLK_MIF0,
+			16, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_RCLK_DREX1, "rclk_drex1", "fin_pll", ENABLE_ACLK_MIF0,
+			15, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_RCLK_DREX0, "rclk_drex0", "fin_pll", ENABLE_ACLK_MIF0,
+			14, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX1_TZ, "aclk_drex1_tz", "div_aclk_drex1",
+			ENABLE_ACLK_MIF0, 13, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX0_TZ, "aclk_drex0_tz", "div_aclk_drex0",
+			ENABLE_ACLK_MIF0, 12, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX1_PEREV, "aclk_drex1_perev", "div_aclk_drex1",
+			ENABLE_ACLK_MIF0, 11, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX0_PEREV, "aclk_drex0_perev", "div_aclk_drex0",
+			ENABLE_ACLK_MIF0, 10, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX1_MEMIF, "aclk_drex1_memif", "div_aclk_drex1",
+			ENABLE_ACLK_MIF0, 9, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX0_MEMIF, "aclk_drex0_memif", "div_aclk_drex0",
+			ENABLE_ACLK_MIF0, 8, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX1_SCH, "aclk_drex1_sch", "div_aclk_drex1",
+			ENABLE_ACLK_MIF0, 7, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX0_SCH, "aclk_drex0_sch", "div_aclk_drex0",
+			ENABLE_ACLK_MIF0, 6, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX1_BUSIF, "aclk_drex1_busif", "div_aclk_drex1",
+			ENABLE_ACLK_MIF0, 5, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX0_BUSIF, "aclk_drex0_busif", "div_aclk_drex0",
+			ENABLE_ACLK_MIF0, 4, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX1_BUSIF_RD, "aclk_drex1_busif_rd", "div_aclk_drex1",
+			ENABLE_ACLK_MIF0, 3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX0_BUSIF_RD, "aclk_drex0_busif_rd", "div_aclk_drex0",
+			ENABLE_ACLK_MIF0, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX1, "aclk_drex1", "div_aclk_drex1",
+			ENABLE_ACLK_MIF0, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DREX0, "aclk_drex0", "div_aclk_drex0",
+			ENABLE_ACLK_MIF0, 1, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_ACLK_MIF1 */
+	GATE(CLK_ACLK_ASYNCAXIS_MIF_IMEM, "aclk_asyncaxis_mif_imem",
+			"div_aclk_mif_200", ENABLE_ACLK_MIF1, 28,
+			CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIS_NOC_P_CCI, "aclk_asyncaxis_noc_p_cci",
+			"div_aclk_mif_200", ENABLE_ACLK_MIF1,
+			27, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIM_NOC_P_CCI, "aclk_asyncaxim_noc_p_cci",
+			"div_aclk_mif_133", ENABLE_ACLK_MIF1,
+			26, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIS_CP1, "aclk_asyncaxis_cp1",
+			"div_aclk_mifnm_200", ENABLE_ACLK_MIF1,
+			25, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIM_CP1, "aclk_asyncaxim_cp1",
+			"div_aclk_drex1", ENABLE_ACLK_MIF1,
+			24, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIS_CP0, "aclk_asyncaxis_cp0",
+			"div_aclk_mifnm_200", ENABLE_ACLK_MIF1,
+			23, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIM_CP0, "aclk_asyncaxim_cp0",
+			"div_aclk_drex0", ENABLE_ACLK_MIF1,
+			22, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIS_DREX1_3, "aclk_asyncaxis_drex1_3",
+			"div_aclk_mif_133", ENABLE_ACLK_MIF1,
+			21, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIM_DREX1_3, "aclk_asyncaxim_drex1_3",
+			"div_aclk_drex1", ENABLE_ACLK_MIF1,
+			20, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIS_DREX1_1, "aclk_asyncaxis_drex1_1",
+			"div_aclk_mif_133", ENABLE_ACLK_MIF1,
+			19, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIM_DREX1_1, "aclk_asyncaxim_drex1_1",
+			"div_aclk_drex1", ENABLE_ACLK_MIF1,
+			18, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIS_DREX1_0, "aclk_asyncaxis_drex1_0",
+			"div_aclk_mif_133", ENABLE_ACLK_MIF1,
+			17, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIM_DREX1_0, "aclk_asyncaxim_drex1_0",
+			"div_aclk_drex1", ENABLE_ACLK_MIF1,
+			16, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIS_DREX0_3, "aclk_asyncaxis_drex0_3",
+			"div_aclk_mif_133", ENABLE_ACLK_MIF1,
+			15, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIM_DREX0_3, "aclk_asyncaxim_drex0_3",
+			"div_aclk_drex0", ENABLE_ACLK_MIF1,
+			14, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIS_DREX0_1, "aclk_asyncaxis_drex0_1",
+			"div_aclk_mif_133", ENABLE_ACLK_MIF1,
+			13, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIM_DREX0_1, "aclk_asyncaxim_drex0_1",
+			"div_aclk_drex0", ENABLE_ACLK_MIF1,
+			12, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIS_DREX0_0, "aclk_asyncaxis_drex0_0",
+			"div_aclk_mif_133", ENABLE_ACLK_MIF1,
+			11, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAXIM_DREX0_0, "aclk_asyncaxim_drex0_0",
+			"div_aclk_drex0", ENABLE_ACLK_MIF1,
+			10, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB2APB_MIF2P, "aclk_ahb2apb_mif2p", "div_aclk_mif_133",
+			ENABLE_ACLK_MIF1, 9, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB2APB_MIF1P, "aclk_ahb2apb_mif1p", "div_aclk_mif_133",
+			ENABLE_ACLK_MIF1, 8, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB2APB_MIF0P, "aclk_ahb2apb_mif0p", "div_aclk_mif_133",
+			ENABLE_ACLK_MIF1, 7, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_IXIU_CCI, "aclk_ixiu_cci", "div_aclk_mif_400",
+			ENABLE_ACLK_MIF1, 6, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_XIU_MIFSFRX, "aclk_xiu_mifsfrx", "div_aclk_mif_200",
+			ENABLE_ACLK_MIF1, 5, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_MIFNP_133, "aclk_mifnp_133", "div_aclk_mif_133",
+			ENABLE_ACLK_MIF1, 4, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_MIFNM_200, "aclk_mifnm_200", "div_aclk_mifnm_200",
+			ENABLE_ACLK_MIF1, 3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_MIFND_133, "aclk_mifnd_133", "div_aclk_mifnd_133",
+			ENABLE_ACLK_MIF1, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_MIFND_400, "aclk_mifnd_400", "div_aclk_mif_400",
+			ENABLE_ACLK_MIF1, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_CCI, "aclk_cci", "div_aclk_mif_400", ENABLE_ACLK_MIF1,
+			0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_ACLK_MIF2 */
+	GATE(CLK_ACLK_MIFND_266, "aclk_mifnd_266", "div_aclk_mif_266",
+			ENABLE_ACLK_MIF2, 20, 0, 0),
+	GATE(CLK_ACLK_PPMU_DREX1S3, "aclk_ppmu_drex1s3", "div_aclk_drex1",
+			ENABLE_ACLK_MIF2, 17, 0, 0),
+	GATE(CLK_ACLK_PPMU_DREX1S1, "aclk_ppmu_drex1s1", "div_aclk_drex1",
+			ENABLE_ACLK_MIF2, 16, 0, 0),
+	GATE(CLK_ACLK_PPMU_DREX1S0, "aclk_ppmu_drex1s0", "div_aclk_drex1",
+			ENABLE_ACLK_MIF2, 15, 0, 0),
+	GATE(CLK_ACLK_PPMU_DREX0S3, "aclk_ppmu_drex0s3", "div_aclk_drex0",
+			ENABLE_ACLK_MIF2, 14, 0, 0),
+	GATE(CLK_ACLK_PPMU_DREX0S1, "aclk_ppmu_drex0s1", "div_aclk_drex0",
+			ENABLE_ACLK_MIF2, 13, 0, 0),
+	GATE(CLK_ACLK_PPMU_DREX0S0, "aclk_ppmu_drex0s0", "div_aclk_drex0",
+			ENABLE_ACLK_MIF2, 12, 0, 0),
+	GATE(CLK_ACLK_AXIDS_CCI_MIFSFRX, "aclk_axids_cci_mifsfrx",
+			"div_aclk_mif_200", ENABLE_ACLK_MIF2, 7,
+			CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AXISYNCDNS_CCI, "aclk_axisyncdns_cci",
+			"div_aclk_mif_400", ENABLE_ACLK_MIF2,
+			5, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AXISYNCDN_CCI, "aclk_axisyncdn_cci", "div_aclk_mif_400",
+			ENABLE_ACLK_MIF2, 4, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AXISYNCDN_NOC_D, "aclk_axisyncdn_noc_d",
+			"div_aclk_mif_200", ENABLE_ACLK_MIF2,
+			3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_ASYNCAPBS_MIF_CSSYS, "aclk_asyncapbs_mif_cssys",
+			"div_aclk_mifnd_133", ENABLE_ACLK_MIF2, 0, 0, 0),
+
+	/* ENABLE_ACLK_MIF3 */
+	GATE(CLK_ACLK_BUS2_400, "aclk_bus2_400", "div_aclk_bus2_400",
+			ENABLE_ACLK_MIF3, 4, 0, 0),
+	GATE(CLK_ACLK_DISP_333, "aclk_disp_333", "div_aclk_disp_333",
+			ENABLE_ACLK_MIF3, 1, 0, 0),
+	GATE(CLK_ACLK_CPIF_200, "aclk_cpif_200", "div_aclk_cpif_200",
+			ENABLE_ACLK_MIF3, 0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_PCLK_MIF */
+	GATE(CLK_PCLK_PPMU_DREX1S3, "pclk_ppmu_drex1s3", "div_aclk_drex1",
+			ENABLE_PCLK_MIF, 29, 0, 0),
+	GATE(CLK_PCLK_PPMU_DREX1S1, "pclk_ppmu_drex1s1", "div_aclk_drex1",
+			ENABLE_PCLK_MIF, 28, 0, 0),
+	GATE(CLK_PCLK_PPMU_DREX1S0, "pclk_ppmu_drex1s0", "div_aclk_drex1",
+			ENABLE_PCLK_MIF, 27, 0, 0),
+	GATE(CLK_PCLK_PPMU_DREX0S3, "pclk_ppmu_drex0s3", "div_aclk_drex0",
+			ENABLE_PCLK_MIF, 26, 0, 0),
+	GATE(CLK_PCLK_PPMU_DREX0S1, "pclk_ppmu_drex0s1", "div_aclk_drex0",
+			ENABLE_PCLK_MIF, 25, 0, 0),
+	GATE(CLK_PCLK_PPMU_DREX0S0, "pclk_ppmu_drex0s0", "div_aclk_drex0",
+			ENABLE_PCLK_MIF, 24, 0, 0),
+	GATE(CLK_PCLK_ASYNCAXI_NOC_P_CCI, "pclk_asyncaxi_noc_p_cci",
+			"div_aclk_mif_133", ENABLE_PCLK_MIF, 21,
+			CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_ASYNCAXI_CP1, "pclk_asyncaxi_cp1", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF, 19, 0, 0),
+	GATE(CLK_PCLK_ASYNCAXI_CP0, "pclk_asyncaxi_cp0", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF, 18, 0, 0),
+	GATE(CLK_PCLK_ASYNCAXI_DREX1_3, "pclk_asyncaxi_drex1_3",
+			"div_aclk_mif_133", ENABLE_PCLK_MIF, 17, 0, 0),
+	GATE(CLK_PCLK_ASYNCAXI_DREX1_1, "pclk_asyncaxi_drex1_1",
+			"div_aclk_mif_133", ENABLE_PCLK_MIF, 16, 0, 0),
+	GATE(CLK_PCLK_ASYNCAXI_DREX1_0, "pclk_asyncaxi_drex1_0",
+			"div_aclk_mif_133", ENABLE_PCLK_MIF, 15, 0, 0),
+	GATE(CLK_PCLK_ASYNCAXI_DREX0_3, "pclk_asyncaxi_drex0_3",
+			"div_aclk_mif_133", ENABLE_PCLK_MIF, 14, 0, 0),
+	GATE(CLK_PCLK_ASYNCAXI_DREX0_1, "pclk_asyncaxi_drex0_1",
+			"div_aclk_mif_133", ENABLE_PCLK_MIF, 13, 0, 0),
+	GATE(CLK_PCLK_ASYNCAXI_DREX0_0, "pclk_asyncaxi_drex0_0",
+			"div_aclk_mif_133", ENABLE_PCLK_MIF, 12, 0, 0),
+	GATE(CLK_PCLK_MIFSRVND_133, "pclk_mifsrvnd_133", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF, 11, 0, 0),
+	GATE(CLK_PCLK_PMU_MIF, "pclk_pmu_mif", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF, 10, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_MIF, "pclk_sysreg_mif", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF, 9, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_GPIO_ALIVE, "pclk_gpio_alive", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF, 8, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_ABB, "pclk_abb", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF, 7, 0, 0),
+	GATE(CLK_PCLK_PMU_APBIF, "pclk_pmu_apbif", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF, 6, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_DDR_PHY1, "pclk_ddr_phy1", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF, 5, 0, 0),
+	GATE(CLK_PCLK_DREX1, "pclk_drex1", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF, 3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_DDR_PHY0, "pclk_ddr_phy0", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF, 2, 0, 0),
+	GATE(CLK_PCLK_DREX0, "pclk_drex0", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF, 0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_PCLK_MIF_SECURE_DREX0_TZ */
+	GATE(CLK_PCLK_DREX0_TZ, "pclk_drex0_tz", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF_SECURE_DREX0_TZ, 0, 0, 0),
+
+	/* ENABLE_PCLK_MIF_SECURE_DREX1_TZ */
+	GATE(CLK_PCLK_DREX1_TZ, "pclk_drex1_tz", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF_SECURE_DREX1_TZ, 0, 0, 0),
+
+	/* ENABLE_PCLK_MIF_SECURE_MONOTONIC_CNT */
+	GATE(CLK_PCLK_MONOTONIC_CNT, "pclk_monotonic_cnt", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF_SECURE_RTC, 0, 0, 0),
+
+	/* ENABLE_PCLK_MIF_SECURE_RTC */
+	GATE(CLK_PCLK_RTC, "pclk_rtc", "div_aclk_mif_133",
+			ENABLE_PCLK_MIF_SECURE_RTC, 0, 0, 0),
+
+	/* ENABLE_SCLK_MIF */
+	GATE(CLK_SCLK_DSIM1_DISP, "sclk_dsim1_disp", "div_sclk_dsim1",
+			ENABLE_SCLK_MIF, 15, 0, 0),
+	GATE(CLK_SCLK_DECON_TV_VCLK_DISP, "sclk_decon_tv_vclk_disp",
+			"div_sclk_decon_tv_vclk", ENABLE_SCLK_MIF, 14, 0, 0),
+	GATE(CLK_SCLK_DSIM0_DISP, "sclk_dsim0_disp", "div_sclk_dsim0",
+			ENABLE_SCLK_MIF, 9, 0, 0),
+	GATE(CLK_SCLK_DSD_DISP, "sclk_dsd_disp", "div_sclk_dsd",
+			ENABLE_SCLK_MIF, 8, 0, 0),
+	GATE(CLK_SCLK_DECON_TV_ECLK_DISP, "sclk_decon_tv_eclk_disp",
+			"div_sclk_decon_tv_eclk", ENABLE_SCLK_MIF, 7, 0, 0),
+	GATE(CLK_SCLK_DECON_VCLK_DISP, "sclk_decon_vclk_disp",
+			"div_sclk_decon_vclk", ENABLE_SCLK_MIF, 6, 0, 0),
+	GATE(CLK_SCLK_DECON_ECLK_DISP, "sclk_decon_eclk_disp",
+			"div_sclk_decon_eclk", ENABLE_SCLK_MIF, 5, 0, 0),
+	GATE(CLK_SCLK_HPM_MIF, "sclk_hpm_mif", "div_sclk_hpm_mif",
+			ENABLE_SCLK_MIF, 4, 0, 0),
+};
+
 static struct samsung_cmu_info mif_cmu_info __initdata = {
 	.pll_clks		= mif_pll_clks,
 	.nr_pll_clks		= ARRAY_SIZE(mif_pll_clks),
+	.mux_clks		= mif_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(mif_mux_clks),
+	.div_clks		= mif_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(mif_div_clks),
+	.gate_clks		= mif_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(mif_gate_clks),
+	.fixed_factor_clks	= mif_fixed_factor_clks,
+	.nr_fixed_factor_clks	= ARRAY_SIZE(mif_fixed_factor_clks),
 	.nr_clk_ids		= MIF_NR_CLK,
 	.clk_regs		= mif_clk_regs,
 	.nr_clk_regs		= ARRAY_SIZE(mif_clk_regs),
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index 054f767..3fb1f32 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -149,8 +149,196 @@
 #define CLK_FOUT_MEM1_PLL		2
 #define CLK_FOUT_BUS_PLL		3
 #define CLK_FOUT_MFC_PLL		4
+#define CLK_DOUT_MFC_PLL		5
+#define CLK_DOUT_BUS_PLL		6
+#define CLK_DOUT_MEM1_PLL		7
+#define CLK_DOUT_MEM0_PLL		8
 
-#define MIF_NR_CLK			5
+#define CLK_MOUT_MFC_PLL_DIV2		10
+#define CLK_MOUT_BUS_PLL_DIV2		11
+#define CLK_MOUT_MEM1_PLL_DIV2		12
+#define CLK_MOUT_MEM0_PLL_DIV2		13
+#define CLK_MOUT_MFC_PLL		14
+#define CLK_MOUT_BUS_PLL		15
+#define CLK_MOUT_MEM1_PLL		16
+#define CLK_MOUT_MEM0_PLL		17
+#define CLK_MOUT_CLK2X_PHY_C		18
+#define CLK_MOUT_CLK2X_PHY_B		19
+#define CLK_MOUT_CLK2X_PHY_A		20
+#define CLK_MOUT_CLKM_PHY_C		21
+#define CLK_MOUT_CLKM_PHY_B		22
+#define CLK_MOUT_CLKM_PHY_A		23
+#define CLK_MOUT_ACLK_MIFNM_200		24
+#define CLK_MOUT_ACLK_MIFNM_400		25
+#define CLK_MOUT_ACLK_DISP_333_B	26
+#define CLK_MOUT_ACLK_DISP_333_A	27
+#define CLK_MOUT_SCLK_DECON_VCLK_C	28
+#define CLK_MOUT_SCLK_DECON_VCLK_B	29
+#define CLK_MOUT_SCLK_DECON_VCLK_A	30
+#define CLK_MOUT_SCLK_DECON_ECLK_C	31
+#define CLK_MOUT_SCLK_DECON_ECLK_B	32
+#define CLK_MOUT_SCLK_DECON_ECLK_A	33
+#define CLK_MOUT_SCLK_DECON_TV_ECLK_C	34
+#define CLK_MOUT_SCLK_DECON_TV_ECLK_B	35
+#define CLK_MOUT_SCLK_DECON_TV_ECLK_A	36
+#define CLK_MOUT_SCLK_DSD_C		37
+#define CLK_MOUT_SCLK_DSD_B		38
+#define CLK_MOUT_SCLK_DSD_A		39
+#define CLK_MOUT_SCLK_DSIM0_C		40
+#define CLK_MOUT_SCLK_DSIM0_B		41
+#define CLK_MOUT_SCLK_DSIM0_A		42
+#define CLK_MOUT_SCLK_DECON_TV_VCLK_C	46
+#define CLK_MOUT_SCLK_DECON_TV_VCLK_B	47
+#define CLK_MOUT_SCLK_DECON_TV_VCLK_A	48
+#define CLK_MOUT_SCLK_DSIM1_C		49
+#define CLK_MOUT_SCLK_DSIM1_B		50
+#define CLK_MOUT_SCLK_DSIM1_A		51
+
+#define CLK_DIV_SCLK_HPM_MIF		55
+#define CLK_DIV_ACLK_DREX1		56
+#define CLK_DIV_ACLK_DREX0		57
+#define CLK_DIV_CLK2XPHY		58
+#define CLK_DIV_ACLK_MIF_266		59
+#define CLK_DIV_ACLK_MIFND_133		60
+#define CLK_DIV_ACLK_MIF_133		61
+#define CLK_DIV_ACLK_MIFNM_200		62
+#define CLK_DIV_ACLK_MIF_200		63
+#define CLK_DIV_ACLK_MIF_400		64
+#define CLK_DIV_ACLK_BUS2_400		65
+#define CLK_DIV_ACLK_DISP_333		66
+#define CLK_DIV_ACLK_CPIF_200		67
+#define CLK_DIV_SCLK_DSIM1		68
+#define CLK_DIV_SCLK_DECON_TV_VCLK	69
+#define CLK_DIV_SCLK_DSIM0		70
+#define CLK_DIV_SCLK_DSD		71
+#define CLK_DIV_SCLK_DECON_TV_ECLK	72
+#define CLK_DIV_SCLK_DECON_VCLK		73
+#define CLK_DIV_SCLK_DECON_ECLK		74
+#define CLK_DIV_MIF_PRE			75
+
+#define CLK_CLK2X_PHY1			80
+#define CLK_CLK2X_PHY0			81
+#define CLK_CLKM_PHY1			82
+#define CLK_CLKM_PHY0			83
+#define CLK_RCLK_DREX1			84
+#define CLK_RCLK_DREX0			85
+#define CLK_ACLK_DREX1_TZ		86
+#define CLK_ACLK_DREX0_TZ		87
+#define CLK_ACLK_DREX1_PEREV		88
+#define CLK_ACLK_DREX0_PEREV		89
+#define CLK_ACLK_DREX1_MEMIF		90
+#define CLK_ACLK_DREX0_MEMIF		91
+#define CLK_ACLK_DREX1_SCH		92
+#define CLK_ACLK_DREX0_SCH		93
+#define CLK_ACLK_DREX1_BUSIF		94
+#define CLK_ACLK_DREX0_BUSIF		95
+#define CLK_ACLK_DREX1_BUSIF_RD		96
+#define CLK_ACLK_DREX0_BUSIF_RD		97
+#define CLK_ACLK_DREX1			98
+#define CLK_ACLK_DREX0			99
+#define CLK_ACLK_ASYNCAXIM_ATLAS_CCIX	100
+#define CLK_ACLK_ASYNCAXIS_ATLAS_MIF	101
+#define CLK_ACLK_ASYNCAXIM_ATLAS_MIF	102
+#define CLK_ACLK_ASYNCAXIS_MIF_IMEM	103
+#define CLK_ACLK_ASYNCAXIS_NOC_P_CCI	104
+#define CLK_ACLK_ASYNCAXIM_NOC_P_CCI	105
+#define CLK_ACLK_ASYNCAXIS_CP1		106
+#define CLK_ACLK_ASYNCAXIM_CP1		107
+#define CLK_ACLK_ASYNCAXIS_CP0		108
+#define CLK_ACLK_ASYNCAXIM_CP0		109
+#define CLK_ACLK_ASYNCAXIS_DREX1_3	110
+#define CLK_ACLK_ASYNCAXIM_DREX1_3	111
+#define CLK_ACLK_ASYNCAXIS_DREX1_1	112
+#define CLK_ACLK_ASYNCAXIM_DREX1_1	113
+#define CLK_ACLK_ASYNCAXIS_DREX1_0	114
+#define CLK_ACLK_ASYNCAXIM_DREX1_0	115
+#define CLK_ACLK_ASYNCAXIS_DREX0_3	116
+#define CLK_ACLK_ASYNCAXIM_DREX0_3	117
+#define CLK_ACLK_ASYNCAXIS_DREX0_1	118
+#define CLK_ACLK_ASYNCAXIM_DREX0_1	119
+#define CLK_ACLK_ASYNCAXIS_DREX0_0	120
+#define CLK_ACLK_ASYNCAXIM_DREX0_0	121
+#define CLK_ACLK_AHB2APB_MIF2P		122
+#define CLK_ACLK_AHB2APB_MIF1P		123
+#define CLK_ACLK_AHB2APB_MIF0P		124
+#define CLK_ACLK_IXIU_CCI		125
+#define CLK_ACLK_XIU_MIFSFRX		126
+#define CLK_ACLK_MIFNP_133		127
+#define CLK_ACLK_MIFNM_200		128
+#define CLK_ACLK_MIFND_133		129
+#define CLK_ACLK_MIFND_400		130
+#define CLK_ACLK_CCI			131
+#define CLK_ACLK_MIFND_266		132
+#define CLK_ACLK_PPMU_DREX1S3		133
+#define CLK_ACLK_PPMU_DREX1S1		134
+#define CLK_ACLK_PPMU_DREX1S0		135
+#define CLK_ACLK_PPMU_DREX0S3		136
+#define CLK_ACLK_PPMU_DREX0S1		137
+#define CLK_ACLK_PPMU_DREX0S0		138
+#define CLK_ACLK_BTS_APOLLO		139
+#define CLK_ACLK_BTS_ATLAS		140
+#define CLK_ACLK_ACE_SEL_APOLL		141
+#define CLK_ACLK_ACE_SEL_ATLAS		142
+#define CLK_ACLK_AXIDS_CCI_MIFSFRX	143
+#define CLK_ACLK_AXIUS_ATLAS_CCI	144
+#define CLK_ACLK_AXISYNCDNS_CCI		145
+#define CLK_ACLK_AXISYNCDN_CCI		146
+#define CLK_ACLK_AXISYNCDN_NOC_D	147
+#define CLK_ACLK_ASYNCACEM_APOLLO_CCI	148
+#define CLK_ACLK_ASYNCACEM_ATLAS_CCI	149
+#define CLK_ACLK_ASYNCAPBS_MIF_CSSYS	150
+#define CLK_ACLK_BUS2_400		151
+#define CLK_ACLK_DISP_333		152
+#define CLK_ACLK_CPIF_200		153
+#define CLK_PCLK_PPMU_DREX1S3		154
+#define CLK_PCLK_PPMU_DREX1S1		155
+#define CLK_PCLK_PPMU_DREX1S0		156
+#define CLK_PCLK_PPMU_DREX0S3		157
+#define CLK_PCLK_PPMU_DREX0S1		158
+#define CLK_PCLK_PPMU_DREX0S0		159
+#define CLK_PCLK_BTS_APOLLO		160
+#define CLK_PCLK_BTS_ATLAS		161
+#define CLK_PCLK_ASYNCAXI_NOC_P_CCI	162
+#define CLK_PCLK_ASYNCAXI_CP1		163
+#define CLK_PCLK_ASYNCAXI_CP0		164
+#define CLK_PCLK_ASYNCAXI_DREX1_3	165
+#define CLK_PCLK_ASYNCAXI_DREX1_1	166
+#define CLK_PCLK_ASYNCAXI_DREX1_0	167
+#define CLK_PCLK_ASYNCAXI_DREX0_3	168
+#define CLK_PCLK_ASYNCAXI_DREX0_1	169
+#define CLK_PCLK_ASYNCAXI_DREX0_0	170
+#define CLK_PCLK_MIFSRVND_133		171
+#define CLK_PCLK_PMU_MIF		172
+#define CLK_PCLK_SYSREG_MIF		173
+#define CLK_PCLK_GPIO_ALIVE		174
+#define CLK_PCLK_ABB			175
+#define CLK_PCLK_PMU_APBIF		176
+#define CLK_PCLK_DDR_PHY1		177
+#define CLK_PCLK_DREX1			178
+#define CLK_PCLK_DDR_PHY0		179
+#define CLK_PCLK_DREX0			180
+#define CLK_PCLK_DREX0_TZ		181
+#define CLK_PCLK_DREX1_TZ		182
+#define CLK_PCLK_MONOTONIC_CNT		183
+#define CLK_PCLK_RTC			184
+#define CLK_SCLK_DSIM1_DISP		185
+#define CLK_SCLK_DECON_TV_VCLK_DISP	186
+#define CLK_SCLK_FREQ_DET_BUS_PLL	187
+#define CLK_SCLK_FREQ_DET_MFC_PLL	188
+#define CLK_SCLK_FREQ_DET_MEM0_PLL	189
+#define CLK_SCLK_FREQ_DET_MEM1_PLL	190
+#define CLK_SCLK_DSIM0_DISP		191
+#define CLK_SCLK_DSD_DISP		192
+#define CLK_SCLK_DECON_TV_ECLK_DISP	193
+#define CLK_SCLK_DECON_VCLK_DISP	194
+#define CLK_SCLK_DECON_ECLK_DISP	195
+#define CLK_SCLK_HPM_MIF		196
+#define CLK_SCLK_MFC_PLL_MIF		197
+#define CLK_SCLK_BUS_PLL		198
+#define CLK_SCLK_BUS_PLL_APOLLO		199
+#define CLK_SCLK_BUS_PLL_ATLAS		200
+
+#define MIF_NR_CLK			201
 
 /* CMU_PERIC */
 #define CLK_PCLK_SPI2			1
-- 
1.8.5.5

