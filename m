Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbbAUGwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:52:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50252 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbbAUGwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:52:07 -0500
X-AuditID: cbfee68d-f79296d000004278-62-54bf4c944ece
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: mturquette@linaro.org, kgene@kernel.org, pankaj.dubey@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        sw0312.kim@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] clk: samsung: exynos5433: Add missing clocks for
 CMU_FSYS domain
Date: Wed, 21 Jan 2015 15:51:58 +0900
Message-id: <1421823120-11448-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWyRsSkUHeKz/4Qg3+LVSwu79e2uP7lOavF
	pPsTWCz6H79mtri8aw6bxYzz+5gsnk64yGaxaOsXdovDb9pZLWZMfslmsWrXH0YHbo+ds+6y
	e2xa1cnmcefaHjaPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyvix+TBbwZ2NjBVzdr9nbmDs
	mM3YxcjJISFgItE0s58VwhaTuHBvPVsXIxeHkMBSRol/9zbDFT042ssMYgsJLGKUeLY8DaKo
	iUli+vU3bCAJNgEtif0vbgDZHBwiAoYSNw8pgdQwC7xhlOh+/xtsg7BApMTb6c1MIDaLgKrE
	5pl3wIbyCrhK9HT/h7pCQWLZ8pmsIHM4geLtt5lATCEBF4lzW0pARkoI7GKXuHl6E9QYAYlv
	kw+xgNRICMhKbDrADDFFUuLgihssExiFFzAyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQI
	jIbT/5717mC8fcD6EKMAB6MSD+8Lxf0hQqyJZcWVuYcYTYE2TGSWEk3OB8ZcXkm8obGZkYWp
	iamxkbmlmZI4r6LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjDH7S6b5Xg6YG2d7b5/m
	9AWMSSVLb/ofun5g3bIMDavbwQc6WlLqbG0P33ofsX6K+uL6hMkJTIcFLLjdFTpLPZQf7ay9
	Xu7xnbH3+7OnN5saVj68deTz0XV5hsUPN127u2+N4T1/aYZFM9R3+N8v/HnHzXj+bXO25Lov
	r3ZuYdWf+873Gat44m4lluKMREMt5qLiRACsgSragQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd0pPvtDDCZ3illc3q9tcf3Lc1aL
	SfcnsFj0P37NbHF51xw2ixnn9zFZPJ1wkc1i0dYv7BaH37SzWsyY/JLNYtWuP4wO3B47Z91l
	99i0qpPN4861PWwefVtWMXp83iQXwBrVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhr
	aGlhrqSQl5ibaqvk4hOg65aZA3SakkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMD
	NJCwhjHjx+bDbAV3NjJWzNn9nrmBsWM2YxcjJ4eEgInEg6O9zBC2mMSFe+vZQGwhgUWMEs+W
	p3UxcgHZTUwS06+/AUuwCWhJ7H9xA8jm4BARMJS4eUgJpIZZ4A2jRPf736wgNcICkRJvpzcz
	gdgsAqoSm2feAVvAK+Aq0dP9nxVimYLEsuUzWUHmcALF228zgZhCAi4S57aUTGDkXcDIsIpR
	NLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjONaeSe1gXNlgcYhRgINRiYf3heL+ECHWxLLiytxD
	jBIczEoivIoSQCHelMTKqtSi/Pii0pzU4kOMpkA3TWSWEk3OB6aBvJJ4Q2MTMyNLI3NDCyNj
	cyVxXiX7thAhgfTEktTs1NSC1CKYPiYOTqkGxtWhwhY9gpz8fDY7avbEe24Nmc0afrprkZR1
	vVvZ8rQldpUiPiwnns/dNcUx6/a6RnHTtlm5v30y/k5yblJdFbZJeMt3k3lnjK9kcV7UlNhS
	e8b7wN3f78+8jJxZkh0y233GD/s36aviV/DFdl/fuenWiok3Ztcxr9lW9YTxXMTkMunN9x/O
	P6PEUpyRaKjFXFScCAD+EywnywIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the mux/divider/gate clocks for CMU_FSYS domain which
contains the clocks of USB/UFS/SDMMC/TSI/PDMA IPs.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/clk/samsung/clk-exynos5433.c   | 302 +++++++++++++++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h |  96 ++++++++++-
 2 files changed, 395 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index e79edd7..fa39e6c 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -462,6 +462,16 @@ static struct samsung_div_clock top_div_clks[] __initdata = {
 	DIV(CLK_DIV_SCLK_MMC2_A, "div_sclk_mmc2_a", "mout_sclk_mmc2_b",
 			DIV_TOP_FSYS1, 0, 4),
 
+	/* DIV_TOP_FSYS2 */
+	DIV(CLK_DIV_SCLK_PCIE_100, "div_sclk_pcie_100", "mout_sclk_pcie_100",
+			DIV_TOP_FSYS2, 12, 3),
+	DIV(CLK_DIV_SCLK_USBHOST30, "div_sclk_usbhost30",
+			"mout_sclk_usbhost30", DIV_TOP_FSYS2, 8, 4),
+	DIV(CLK_DIV_SCLK_UFSUNIPRO, "div_sclk_ufsunipro",
+			"mout_sclk_ufsunipro", DIV_TOP_FSYS2, 4, 4),
+	DIV(CLK_DIV_SCLK_USBDRD30, "div_sclk_usbdrd30", "mout_sclk_usbdrd30",
+			DIV_TOP_FSYS2, 0, 4),
+
 	/* DIV_TOP_PERIC0 */
 	DIV(CLK_DIV_SCLK_SPI1_B, "div_sclk_spi1_b", "div_sclk_spi1_a",
 			DIV_TOP_PERIC0, 16, 8),
@@ -543,12 +553,23 @@ static struct samsung_gate_clock top_gate_clks[] __initdata = {
 			CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
 
 	/* ENABLE_SCLK_TOP_FSYS */
+	GATE(CLK_SCLK_PCIE_100_FSYS, "sclk_pcie_100_fsys", "div_sclk_pcie_100",
+			ENABLE_SCLK_TOP_FSYS, 7, 0, 0),
 	GATE(CLK_SCLK_MMC2_FSYS, "sclk_mmc2_fsys", "div_sclk_mmc2_b",
 			ENABLE_SCLK_TOP_FSYS, 6, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_MMC1_FSYS, "sclk_mmc1_fsys", "div_sclk_mmc1_b",
 			ENABLE_SCLK_TOP_FSYS, 5, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_MMC0_FSYS, "sclk_mmc0_fsys", "div_sclk_mmc0_b",
 			ENABLE_SCLK_TOP_FSYS, 4, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_UFSUNIPRO_FSYS, "sclk_ufsunipro_fsys",
+			"div_sclk_ufsunipro", ENABLE_SCLK_TOP_FSYS,
+			3, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_USBHOST30_FSYS, "sclk_usbhost30_fsys",
+			"div_sclk_usbhost30", ENABLE_SCLK_TOP_FSYS,
+			1, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_USBDRD30_FSYS, "sclk_usbdrd30_fsys",
+			"div_sclk_usbdrd30", ENABLE_SCLK_TOP_FSYS,
+			0, CLK_SET_RATE_PARENT, 0),
 
 	/* ENABLE_SCLK_TOP_PERIC */
 	GATE(CLK_SCLK_SPI4_PERIC, "sclk_spi4_peric", "div_sclk_spi4_b",
@@ -1832,10 +1853,45 @@ CLK_OF_DECLARE(exynos5433_cmu_peris, "samsung,exynos5433-cmu-peris",
 #define ENABLE_IP_FSYS1			0x0b04
 
 /* list of all parent clock list */
+PNAME(mout_sclk_ufs_mphy_user_p)	= { "fin_pll", "sclk_ufs_mphy", };
 PNAME(mout_aclk_fsys_200_user_p)	= { "fin_pll", "div_aclk_fsys_200", };
+PNAME(mout_sclk_pcie_100_user_p)	= { "fin_pll", "sclk_pcie_100_fsys",};
+PNAME(mout_sclk_ufsunipro_user_p)	= { "fin_pll", "sclk_ufsunipro_fsys",};
 PNAME(mout_sclk_mmc2_user_p)		= { "fin_pll", "sclk_mmc2_fsys", };
 PNAME(mout_sclk_mmc1_user_p)		= { "fin_pll", "sclk_mmc1_fsys", };
 PNAME(mout_sclk_mmc0_user_p)		= { "fin_pll", "sclk_mmc0_fsys", };
+PNAME(mout_sclk_usbhost30_user_p)	= { "fin_pll", "sclk_usbhost30_fsys",};
+PNAME(mout_sclk_usbdrd30_user_p)	= { "fin_pll", "sclk_usbdrd30_fsys", };
+
+PNAME(mout_phyclk_usbhost30_uhost30_pipe_pclk_user_p)
+		= { "fin_pll", "phyclk_usbhost30_uhost30_pipe_pclk_phy", };
+PNAME(mout_phyclk_usbhost30_uhost30_phyclock_user_p)
+		= { "fin_pll", "phyclk_usbhost30_uhost30_phyclock_phy", };
+PNAME(mout_phyclk_usbhost20_phy_hsic1_p)
+		= { "fin_pll", "phyclk_usbhost20_phy_hsic1_phy", };
+PNAME(mout_phyclk_usbhost20_phy_clk48mohci_user_p)
+		= { "fin_pll", "phyclk_usbhost20_phy_clk48mohci_phy", };
+PNAME(mout_phyclk_usbhost20_phy_phyclock_user_p)
+		= { "fin_pll", "phyclk_usbhost20_phy_phyclock_phy", };
+PNAME(mout_phyclk_usbhost20_phy_freeclk_user_p)
+		= { "fin_pll", "phyclk_usbhost20_phy_freeclk_phy", };
+PNAME(mout_phyclk_usbdrd30_udrd30_pipe_pclk_p)
+		= { "fin_pll", "phyclk_usbdrd30_udrd30_pipe_pclk_phy", };
+PNAME(mout_phyclk_usbdrd30_udrd30_phyclock_user_p)
+		= { "fin_pll", "phyclk_usbdrd30_udrd30_phyclock_phy", };
+PNAME(mout_phyclk_ufs_rx1_symbol_user_p)
+		= { "fin_pll", "phyclk_ufs_rx1_symbol_phy", };
+PNAME(mout_phyclk_ufs_rx0_symbol_user_p)
+		= { "fin_pll", "phyclk_ufs_rx0_symbol_phy", };
+PNAME(mout_phyclk_ufs_tx1_symbol_user_p)
+		= { "fin_pll", "phyclk_ufs_tx1_symbol_phy", };
+PNAME(mout_phyclk_ufs_tx0_symbol_user_p)
+		= { "fin_pll", "phyclk_ufs_tx0_symbol_phy", };
+PNAME(mout_phyclk_lli_mphy_to_ufs_user_p)
+		= { "fin_pll", "phyclk_lli_mphy_to_ufs_phy", };
+PNAME(mout_sclk_mphy_p)
+		= { "mout_sclk_ufs_mphy_user",
+			    "mout_phyclk_lli_mphy_to_ufs_user", };
 
 static unsigned long fsys_clk_regs[] __initdata = {
 	MUX_SEL_FSYS0,
@@ -1863,18 +1919,130 @@ static unsigned long fsys_clk_regs[] __initdata = {
 	ENABLE_IP_FSYS1,
 };
 
+static struct samsung_fixed_rate_clock fsys_fixed_clks[] __initdata = {
+	/* PHY clocks from USBDRD30_PHY */
+	FRATE(CLK_PHYCLK_USBDRD30_UDRD30_PHYCLOCK_PHY,
+			"phyclk_usbdrd30_udrd30_phyclock_phy", NULL,
+			CLK_IS_ROOT, 60000000),
+	FRATE(CLK_PHYCLK_USBDRD30_UDRD30_PIPE_PCLK_PHY,
+			"phyclk_usbdrd30_udrd30_pipe_pclk_phy", NULL,
+			CLK_IS_ROOT, 125000000),
+	/* PHY clocks from USBHOST30_PHY */
+	FRATE(CLK_PHYCLK_USBHOST30_UHOST30_PHYCLOCK_PHY,
+			"phyclk_usbhost30_uhost30_phyclock_phy", NULL,
+			CLK_IS_ROOT, 60000000),
+	FRATE(CLK_PHYCLK_USBHOST30_UHOST30_PIPE_PCLK_PHY,
+			"phyclk_usbhost30_uhost30_pipe_pclk_phy", NULL,
+			CLK_IS_ROOT, 125000000),
+	/* PHY clocks from USBHOST20_PHY */
+	FRATE(CLK_PHYCLK_USBHOST20_PHY_FREECLK_PHY,
+			"phyclk_usbhost20_phy_freeclk_phy", NULL, CLK_IS_ROOT,
+			60000000),
+	FRATE(CLK_PHYCLK_USBHOST20_PHY_PHYCLOCK_PHY,
+			"phyclk_usbhost20_phy_phyclock_phy", NULL, CLK_IS_ROOT,
+			60000000),
+	FRATE(CLK_PHYCLK_USBHOST20_PHY_CLK48MOHCI_PHY,
+			"phyclk_usbhost20_phy_clk48mohci_phy", NULL,
+			CLK_IS_ROOT, 48000000),
+	FRATE(CLK_PHYCLK_USBHOST20_PHY_HSIC1_PHY,
+			"phyclk_usbhost20_phy_hsic1_phy", NULL, CLK_IS_ROOT,
+			60000000),
+	/* PHY clocks from UFS_PHY */
+	FRATE(CLK_PHYCLK_UFS_TX0_SYMBOL_PHY, "phyclk_ufs_tx0_symbol_phy",
+			NULL, CLK_IS_ROOT, 300000000),
+	FRATE(CLK_PHYCLK_UFS_RX0_SYMBOL_PHY, "phyclk_ufs_rx0_symbol_phy",
+			NULL, CLK_IS_ROOT, 300000000),
+	FRATE(CLK_PHYCLK_UFS_TX1_SYMBOL_PHY, "phyclk_ufs_tx1_symbol_phy",
+			NULL, CLK_IS_ROOT, 300000000),
+	FRATE(CLK_PHYCLK_UFS_RX1_SYMBOL_PHY, "phyclk_ufs_rx1_symbol_phy",
+			NULL, CLK_IS_ROOT, 300000000),
+	/* PHY clocks from LLI_PHY */
+	FRATE(CLK_PHYCLK_LLI_MPHY_TO_UFS_PHY, "phyclk_lli_mphy_to_ufs_phy",
+			NULL, CLK_IS_ROOT, 26000000),
+};
+
 static struct samsung_mux_clock fsys_mux_clks[] __initdata = {
 	/* MUX_SEL_FSYS0 */
+	MUX(CLK_MOUT_SCLK_UFS_MPHY_USER, "mout_sclk_ufs_mphy_user",
+			mout_sclk_ufs_mphy_user_p, MUX_SEL_FSYS0, 4, 1),
 	MUX(CLK_MOUT_ACLK_FSYS_200_USER, "mout_aclk_fsys_200_user",
 			mout_aclk_fsys_200_user_p, MUX_SEL_FSYS0, 0, 1),
 
 	/* MUX_SEL_FSYS1 */
+	MUX(CLK_MOUT_SCLK_PCIE_100_USER, "mout_sclk_pcie_100_user",
+			mout_sclk_pcie_100_user_p, MUX_SEL_FSYS1, 28, 1),
+	MUX(CLK_MOUT_SCLK_UFSUNIPRO_USER, "mout_sclk_ufsunipro_user",
+			mout_sclk_ufsunipro_user_p, MUX_SEL_FSYS1, 24, 1),
 	MUX(CLK_MOUT_SCLK_MMC2_USER, "mout_sclk_mmc2_user",
 			mout_sclk_mmc2_user_p, MUX_SEL_FSYS1, 20, 1),
 	MUX(CLK_MOUT_SCLK_MMC1_USER, "mout_sclk_mmc1_user",
 			mout_sclk_mmc1_user_p, MUX_SEL_FSYS1, 16, 1),
 	MUX(CLK_MOUT_SCLK_MMC0_USER, "mout_sclk_mmc0_user",
 			mout_sclk_mmc0_user_p, MUX_SEL_FSYS1, 12, 1),
+	MUX(CLK_MOUT_SCLK_USBHOST30_USER, "mout_sclk_usbhost30_user",
+			mout_sclk_usbhost30_user_p, MUX_SEL_FSYS1, 4, 1),
+	MUX(CLK_MOUT_SCLK_USBDRD30_USER, "mout_sclk_usbdrd30_user",
+			mout_sclk_usbdrd30_user_p, MUX_SEL_FSYS1, 0, 1),
+
+	/* MUX_SEL_FSYS2 */
+	MUX(CLK_MOUT_PHYCLK_USBHOST30_UHOST30_PIPE_PCLK_USER,
+			"mout_phyclk_usbhost30_uhost30_pipe_pclk_user",
+			mout_phyclk_usbhost30_uhost30_pipe_pclk_user_p,
+			MUX_SEL_FSYS2, 28, 1),
+	MUX(CLK_MOUT_PHYCLK_USBHOST30_UHOST30_PHYCLOCK_USER,
+			"mout_phyclk_usbhost30_uhost30_phyclock_user",
+			mout_phyclk_usbhost30_uhost30_phyclock_user_p,
+			MUX_SEL_FSYS2, 24, 1),
+	MUX(CLK_MOUT_PHYCLK_USBHOST20_PHY_HSIC1_USER,
+			"mout_phyclk_usbhost20_phy_hsic1",
+			mout_phyclk_usbhost20_phy_hsic1_p,
+			MUX_SEL_FSYS2, 20, 1),
+	MUX(CLK_MOUT_PHYCLK_USBHOST20_PHY_CLK48MOHCI_USER,
+			"mout_phyclk_usbhost20_phy_clk48mohci_user",
+			mout_phyclk_usbhost20_phy_clk48mohci_user_p,
+			MUX_SEL_FSYS2, 16, 1),
+	MUX(CLK_MOUT_PHYCLK_USBHOST20_PHY_PHYCLOCK_USER,
+			"mout_phyclk_usbhost20_phy_phyclock_user",
+			mout_phyclk_usbhost20_phy_phyclock_user_p,
+			MUX_SEL_FSYS2, 12, 1),
+	MUX(CLK_MOUT_PHYCLK_USBHOST20_PHY_PHY_FREECLK_USER,
+			"mout_phyclk_usbhost20_phy_freeclk_user",
+			mout_phyclk_usbhost20_phy_freeclk_user_p,
+			MUX_SEL_FSYS2, 8, 1),
+	MUX(CLK_MOUT_PHYCLK_USBDRD30_UDRD30_PIPE_PCLK_USER,
+			"mout_phyclk_usbdrd30_udrd30_pipe_pclk_user",
+			mout_phyclk_usbdrd30_udrd30_pipe_pclk_p,
+			MUX_SEL_FSYS2, 4, 1),
+	MUX(CLK_MOUT_PHYCLK_USBDRD30_UDRD30_PHYCLOCK_USER,
+			"mout_phyclk_usbdrd30_udrd30_phyclock_user",
+			mout_phyclk_usbdrd30_udrd30_phyclock_user_p,
+			MUX_SEL_FSYS2, 0, 1),
+
+	/* MUX_SEL_FSYS3 */
+	MUX(CLK_MOUT_PHYCLK_UFS_RX1_SYMBOL_USER,
+			"mout_phyclk_ufs_rx1_symbol_user",
+			mout_phyclk_ufs_rx1_symbol_user_p,
+			MUX_SEL_FSYS3, 16, 1),
+	MUX(CLK_MOUT_PHYCLK_UFS_RX0_SYMBOL_USER,
+			"mout_phyclk_ufs_rx0_symbol_user",
+			mout_phyclk_ufs_rx0_symbol_user_p,
+			MUX_SEL_FSYS3, 12, 1),
+	MUX(CLK_MOUT_PHYCLK_UFS_TX1_SYMBOL_USER,
+			"mout_phyclk_ufs_tx1_symbol_user",
+			mout_phyclk_ufs_tx1_symbol_user_p,
+			MUX_SEL_FSYS3, 8, 1),
+	MUX(CLK_MOUT_PHYCLK_UFS_TX0_SYMBOL_USER,
+			"mout_phyclk_ufs_tx0_symbol_user",
+			mout_phyclk_ufs_tx0_symbol_user_p,
+			MUX_SEL_FSYS3, 4, 1),
+	MUX(CLK_MOUT_PHYCLK_LLI_MPHY_TO_UFS_USER,
+			"mout_phyclk_lli_mphy_to_ufs_user",
+			mout_phyclk_lli_mphy_to_ufs_user_p,
+			MUX_SEL_FSYS3, 0, 1),
+
+	/* MUX_SEL_FSYS4 */
+	MUX(CLK_MOUT_SCLK_MPHY, "mout_sclk_mphy", mout_sclk_mphy_p,
+			MUX_SEL_FSYS4, 0, 1),
 };
 
 static struct samsung_gate_clock fsys_gate_clks[] __initdata = {
@@ -1902,13 +2070,145 @@ static struct samsung_gate_clock fsys_gate_clks[] __initdata = {
 	GATE(CLK_ACLK_PDMA0, "aclk_pdma0", "mout_aclk_fsys_200_user",
 			ENABLE_ACLK_FSYS0, 0, CLK_IGNORE_UNUSED, 0),
 
+	/* ENABLE_ACLK_FSYS1 */
+	GATE(CLK_ACLK_XIU_FSYSPX, "aclk_xiu_fsyspx", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS1, 27, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB_USBLINKH1, "aclk_ahb_usblinkh1",
+			"mout_aclk_fsys_200_user", ENABLE_ACLK_FSYS1,
+			26, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_SMMU_PDMA1, "aclk_smmu_pdma1", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS1, 25, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BTS_PCIE, "aclk_bts_pcie", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS1, 24, 0, 0),
+	GATE(CLK_ACLK_AXIUS_PDMA1, "aclk_axius_pdma1",
+			"mout_aclk_fsys_200_user", ENABLE_ACLK_FSYS1,
+			22, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_SMMU_PDMA0, "aclk_smmu_pdma0", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS1, 17, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BTS_UFS, "aclk_bts_ufs", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS1, 14, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BTS_USBHOST30, "aclk_bts_usbhost30",
+			"mout_aclk_fsys_200_user", ENABLE_ACLK_FSYS1,
+			13, 0, 0),
+	GATE(CLK_ACLK_BTS_USBDRD30, "aclk_bts_usbdrd30",
+			"mout_aclk_fsys_200_user", ENABLE_ACLK_FSYS1,
+			12, 0, 0),
+	GATE(CLK_ACLK_AXIUS_PDMA0, "aclk_axius_pdma0",
+			"mout_aclk_fsys_200_user", ENABLE_ACLK_FSYS1,
+			11, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AXIUS_USBHS, "aclk_axius_usbhs",
+			"mout_aclk_fsys_200_user", ENABLE_ACLK_FSYS1,
+			10, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AXIUS_FSYSSX, "aclk_axius_fsyssx",
+			"mout_aclk_fsys_200_user", ENABLE_ACLK_FSYS1,
+			9, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB2APB_FSYSP, "aclk_ahb2apb_fsysp",
+			"mout_aclk_fsys_200_user", ENABLE_ACLK_FSYS1,
+			8, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB2AXI_USBHS, "aclk_ahb2axi_usbhs",
+			"mout_aclk_fsys_200_user", ENABLE_ACLK_FSYS1,
+			7, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB_USBLINKH0, "aclk_ahb_usblinkh0",
+			"mout_aclk_fsys_200_user", ENABLE_ACLK_FSYS1,
+			6, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB_USBHS, "aclk_ahb_usbhs", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS1, 5, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB_FSYSH, "aclk_ahb_fsysh", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS1, 4, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_XIU_FSYSX, "aclk_xiu_fsysx", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS1, 3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_XIU_FSYSSX, "aclk_xiu_fsyssx", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS1, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_FSYSNP_200, "aclk_fsysnp_200", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS1, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_FSYSND_200, "aclk_fsysnd_200", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS1, 0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_PCLK_FSYS */
+	GATE(CLK_PCLK_PCIE_CTRL, "pclk_pcie_ctrl", "mout_aclk_fsys_200_user",
+			ENABLE_PCLK_FSYS, 17, 0, 0),
+	GATE(CLK_PCLK_SMMU_PDMA1, "pclk_smmu_pdma1", "mout_aclk_fsys_200_user",
+			ENABLE_PCLK_FSYS, 16, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_PCIE_PHY, "pclk_pcie_phy", "mout_aclk_fsys_200_user",
+			ENABLE_PCLK_FSYS, 14, 0, 0),
+	GATE(CLK_PCLK_BTS_PCIE, "pclk_bts_pcie", "mout_aclk_fsys_200_user",
+			ENABLE_PCLK_FSYS, 13, 0, 0),
+	GATE(CLK_PCLK_SMMU_PDMA0, "pclk_smmu_pdma0", "mout_aclk_fsys_200_user",
+			ENABLE_PCLK_FSYS, 8, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_BTS_UFS, "pclk_bts_ufs", "mout_aclk_fsys_200_user",
+			ENABLE_PCLK_FSYS, 5, 0, 0),
+	GATE(CLK_PCLK_BTS_USBHOST30, "pclk_bts_usbhost30",
+			"mout_aclk_fsys_200_user", ENABLE_PCLK_FSYS, 4, 0, 0),
+	GATE(CLK_PCLK_BTS_USBDRD30, "pclk_bts_usbdrd30",
+			"mout_aclk_fsys_200_user", ENABLE_PCLK_FSYS, 3, 0, 0),
+	GATE(CLK_PCLK_GPIO_FSYS, "pclk_gpio_fsys", "mout_aclk_fsys_200_user",
+			ENABLE_PCLK_FSYS, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_PMU_FSYS, "pclk_pmu_fsys", "mout_aclk_fsys_200_user",
+			ENABLE_PCLK_FSYS, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_FSYS, "pclk_sysreg_fsys",
+			"mout_aclk_fsys_200_user", ENABLE_PCLK_FSYS,
+			0, CLK_IGNORE_UNUSED, 0),
+
 	/* ENABLE_SCLK_FSYS */
+	GATE(CLK_SCLK_PCIE_100, "sclk_pcie_100", "mout_sclk_pcie_100_user",
+			ENABLE_SCLK_FSYS, 21, 0, 0),
+	GATE(CLK_PHYCLK_USBHOST30_UHOST30_PIPE_PCLK,
+			"phyclk_usbhost30_uhost30_pipe_pclk",
+			"mout_phyclk_usbhost30_uhost30_pipe_pclk_user",
+			ENABLE_SCLK_FSYS, 18, 0, 0),
+	GATE(CLK_PHYCLK_USBHOST30_UHOST30_PHYCLOCK,
+			"phyclk_usbhost30_uhost30_phyclock",
+			"mout_phyclk_usbhost30_uhost30_phyclock_user",
+			ENABLE_SCLK_FSYS, 17, 0, 0),
+	GATE(CLK_PHYCLK_UFS_RX1_SYMBOL, "phyclk_ufs_rx1_symbol",
+			"mout_phyclk_ufs_rx1_symbol_user", ENABLE_SCLK_FSYS,
+			16, 0, 0),
+	GATE(CLK_PHYCLK_UFS_RX0_SYMBOL, "phyclk_ufs_rx0_symbol",
+			"mout_phyclk_ufs_rx0_symbol_user", ENABLE_SCLK_FSYS,
+			15, 0, 0),
+	GATE(CLK_PHYCLK_UFS_TX1_SYMBOL, "phyclk_ufs_tx1_symbol",
+			"mout_phyclk_ufs_tx1_symbol_user", ENABLE_SCLK_FSYS,
+			14, 0, 0),
+	GATE(CLK_PHYCLK_UFS_TX0_SYMBOL, "phyclk_ufs_tx0_symbol",
+			"mout_phyclk_ufs_tx0_symbol_user", ENABLE_SCLK_FSYS,
+			13, 0, 0),
+	GATE(CLK_PHYCLK_USBHOST20_PHY_HSIC1, "phyclk_usbhost20_phy_hsic1",
+			"mout_phyclk_usbhost20_phy_hsic1", ENABLE_SCLK_FSYS,
+			12, 0, 0),
+	GATE(CLK_PHYCLK_USBHOST20_PHY_CLK48MOHCI,
+			"phyclk_usbhost20_phy_clk48mohci",
+			"mout_phyclk_usbhost20_phy_clk48mohci_user",
+			ENABLE_SCLK_FSYS, 11, 0, 0),
+	GATE(CLK_PHYCLK_USBHOST20_PHY_PHYCLOCK,
+			"phyclk_usbhost20_phy_phyclock",
+			"mout_phyclk_usbhost20_phy_phyclock_user",
+			ENABLE_SCLK_FSYS, 10, 0, 0),
+	GATE(CLK_PHYCLK_USBHOST20_PHY_FREECLK,
+			"phyclk_usbhost20_phy_freeclk",
+			"mout_phyclk_usbhost20_phy_freeclk_user",
+			ENABLE_SCLK_FSYS, 9, 0, 0),
+	GATE(CLK_PHYCLK_USBDRD30_UDRD30_PIPE_PCLK,
+			"phyclk_usbdrd30_udrd30_pipe_pclk",
+			"mout_phyclk_usbdrd30_udrd30_pipe_pclk_user",
+			ENABLE_SCLK_FSYS, 8, 0, 0),
+	GATE(CLK_PHYCLK_USBDRD30_UDRD30_PHYCLOCK,
+			"phyclk_usbdrd30_udrd30_phyclock",
+			"mout_phyclk_usbdrd30_udrd30_phyclock_user",
+			ENABLE_SCLK_FSYS, 7, 0, 0),
+	GATE(CLK_SCLK_MPHY, "sclk_mphy", "mout_sclk_mphy",
+			ENABLE_SCLK_FSYS, 6, 0, 0),
+	GATE(CLK_SCLK_UFSUNIPRO, "sclk_ufsunipro", "mout_sclk_ufsunipro_user",
+			ENABLE_SCLK_FSYS, 5, 0, 0),
 	GATE(CLK_SCLK_MMC2, "sclk_mmc2", "mout_sclk_mmc2_user",
 			ENABLE_SCLK_FSYS, 4, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_MMC1, "sclk_mmc1", "mout_sclk_mmc1_user",
 			ENABLE_SCLK_FSYS, 3, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_MMC0, "sclk_mmc0", "mout_sclk_mmc0_user",
 			ENABLE_SCLK_FSYS, 2, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_USBHOST30, "sclk_usbhost30", "mout_sclk_usbhost30_user",
+			ENABLE_SCLK_FSYS, 1, 0, 0),
+	GATE(CLK_SCLK_USBDRD30, "sclk_usbdrd30", "mout_sclk_usbdrd30_user",
+			ENABLE_SCLK_FSYS, 0, 0, 0),
 
 	/* ENABLE_IP_FSYS0 */
 	GATE(CLK_PDMA1, "pdma1", "aclk_pdma1", ENABLE_IP_FSYS0, 15, 0, 0),
@@ -1920,6 +2220,8 @@ static struct samsung_cmu_info fsys_cmu_info __initdata = {
 	.nr_mux_clks		= ARRAY_SIZE(fsys_mux_clks),
 	.gate_clks		= fsys_gate_clks,
 	.nr_gate_clks		= ARRAY_SIZE(fsys_gate_clks),
+	.fixed_clks		= fsys_fixed_clks,
+	.nr_fixed_clks		= ARRAY_SIZE(fsys_fixed_clks),
 	.nr_clk_ids		= FSYS_NR_CLK,
 	.clk_regs		= fsys_clk_regs,
 	.nr_clk_regs		= ARRAY_SIZE(fsys_clk_regs),
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index 6bc7f51..bd445d2 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -110,6 +110,10 @@
 #define CLK_DIV_ACLK_G3D_400		137
 #define CLK_DIV_ACLK_BUS0_400		138
 #define CLK_DIV_ACLK_BUS1_400		139
+#define CLK_DIV_SCLK_PCIE_100		140
+#define CLK_DIV_SCLK_USBHOST30		141
+#define CLK_DIV_SCLK_UFSUNIPRO		142
+#define CLK_DIV_SCLK_USBDRD30		143
 
 #define CLK_ACLK_PERIC_66		200
 #define CLK_ACLK_PERIS_66		201
@@ -139,8 +143,12 @@
 #define CLK_ACLK_BUS1_400		225
 #define CLK_ACLK_IMEM_200		226
 #define CLK_ACLK_IMEM_266		227
+#define CLK_SCLK_PCIE_100_FSYS		228
+#define CLK_SCLK_UFSUNIPRO_FSYS		229
+#define CLK_SCLK_USBHOST30_FSYS		230
+#define CLK_SCLK_USBDRD30_FSYS		231
 
-#define TOP_NR_CLK			228
+#define TOP_NR_CLK			232
 
 /* CMU_CPIF */
 #define CLK_FOUT_MPHY_PLL		1
@@ -473,6 +481,39 @@
 #define CLK_MOUT_SCLK_MMC2_USER		2
 #define CLK_MOUT_SCLK_MMC1_USER		3
 #define CLK_MOUT_SCLK_MMC0_USER		4
+#define CLK_MOUT_SCLK_UFS_MPHY_USER	5
+#define CLK_MOUT_SCLK_PCIE_100_USER	6
+#define CLK_MOUT_SCLK_UFSUNIPRO_USER	7
+#define CLK_MOUT_SCLK_USBHOST30_USER	8
+#define CLK_MOUT_SCLK_USBDRD30_USER	9
+#define CLK_MOUT_PHYCLK_USBHOST30_UHOST30_PIPE_PCLK_USER	10
+#define CLK_MOUT_PHYCLK_USBHOST30_UHOST30_PHYCLOCK_USER		11
+#define CLK_MOUT_PHYCLK_USBHOST20_PHY_HSIC1_USER		12
+#define CLK_MOUT_PHYCLK_USBHOST20_PHY_CLK48MOHCI_USER		13
+#define CLK_MOUT_PHYCLK_USBHOST20_PHY_PHYCLOCK_USER		14
+#define CLK_MOUT_PHYCLK_USBHOST20_PHY_PHY_FREECLK_USER		15
+#define CLK_MOUT_PHYCLK_USBDRD30_UDRD30_PIPE_PCLK_USER		16
+#define CLK_MOUT_PHYCLK_USBDRD30_UDRD30_PHYCLOCK_USER		17
+#define CLK_MOUT_PHYCLK_UFS_RX1_SYMBOL_USER			18
+#define CLK_MOUT_PHYCLK_UFS_RX0_SYMBOL_USER			19
+#define CLK_MOUT_PHYCLK_UFS_TX1_SYMBOL_USER			20
+#define CLK_MOUT_PHYCLK_UFS_TX0_SYMBOL_USER			21
+#define CLK_MOUT_PHYCLK_LLI_MPHY_TO_UFS_USER			22
+#define CLK_MOUT_SCLK_MPHY					23
+
+#define CLK_PHYCLK_USBDRD30_UDRD30_PHYCLOCK_PHY			25
+#define CLK_PHYCLK_USBDRD30_UDRD30_PIPE_PCLK_PHY		26
+#define CLK_PHYCLK_USBHOST30_UHOST30_PHYCLOCK_PHY		27
+#define CLK_PHYCLK_USBHOST30_UHOST30_PIPE_PCLK_PHY		28
+#define CLK_PHYCLK_USBHOST20_PHY_FREECLK_PHY			29
+#define CLK_PHYCLK_USBHOST20_PHY_PHYCLOCK_PHY			30
+#define CLK_PHYCLK_USBHOST20_PHY_CLK48MOHCI_PHY			31
+#define CLK_PHYCLK_USBHOST20_PHY_HSIC1_PHY			32
+#define CLK_PHYCLK_UFS_TX0_SYMBOL_PHY				33
+#define CLK_PHYCLK_UFS_RX0_SYMBOL_PHY				34
+#define CLK_PHYCLK_UFS_TX1_SYMBOL_PHY				35
+#define CLK_PHYCLK_UFS_RX1_SYMBOL_PHY				36
+#define CLK_PHYCLK_LLI_MPHY_TO_UFS_PHY				37
 
 #define CLK_ACLK_PCIE			50
 #define CLK_ACLK_PDMA1			51
@@ -490,8 +531,57 @@
 #define CLK_SCLK_MMC0			63
 #define CLK_PDMA1			64
 #define CLK_PDMA0			65
-
-#define FSYS_NR_CLK			66
+#define CLK_ACLK_XIU_FSYSPX		66
+#define CLK_ACLK_AHB_USBLINKH1		67
+#define CLK_ACLK_SMMU_PDMA1		68
+#define CLK_ACLK_BTS_PCIE		69
+#define CLK_ACLK_AXIUS_PDMA1		70
+#define CLK_ACLK_SMMU_PDMA0		71
+#define CLK_ACLK_BTS_UFS		72
+#define CLK_ACLK_BTS_USBHOST30		73
+#define CLK_ACLK_BTS_USBDRD30		74
+#define CLK_ACLK_AXIUS_PDMA0		75
+#define CLK_ACLK_AXIUS_USBHS		76
+#define CLK_ACLK_AXIUS_FSYSSX		77
+#define CLK_ACLK_AHB2APB_FSYSP		78
+#define CLK_ACLK_AHB2AXI_USBHS		79
+#define CLK_ACLK_AHB_USBLINKH0		80
+#define CLK_ACLK_AHB_USBHS		81
+#define CLK_ACLK_AHB_FSYSH		82
+#define CLK_ACLK_XIU_FSYSX		83
+#define CLK_ACLK_XIU_FSYSSX		84
+#define CLK_ACLK_FSYSNP_200		85
+#define CLK_ACLK_FSYSND_200		86
+#define CLK_PCLK_PCIE_CTRL		87
+#define CLK_PCLK_SMMU_PDMA1		88
+#define CLK_PCLK_PCIE_PHY		89
+#define CLK_PCLK_BTS_PCIE		90
+#define CLK_PCLK_SMMU_PDMA0		91
+#define CLK_PCLK_BTS_UFS		92
+#define CLK_PCLK_BTS_USBHOST30		93
+#define CLK_PCLK_BTS_USBDRD30		94
+#define CLK_PCLK_GPIO_FSYS		95
+#define CLK_PCLK_PMU_FSYS		96
+#define CLK_PCLK_SYSREG_FSYS		97
+#define CLK_SCLK_PCIE_100		98
+#define CLK_PHYCLK_USBHOST30_UHOST30_PIPE_PCLK	99
+#define CLK_PHYCLK_USBHOST30_UHOST30_PHYCLOCK	100
+#define CLK_PHYCLK_UFS_RX1_SYMBOL		101
+#define CLK_PHYCLK_UFS_RX0_SYMBOL		102
+#define CLK_PHYCLK_UFS_TX1_SYMBOL		103
+#define CLK_PHYCLK_UFS_TX0_SYMBOL		104
+#define CLK_PHYCLK_USBHOST20_PHY_HSIC1		105
+#define CLK_PHYCLK_USBHOST20_PHY_CLK48MOHCI	106
+#define CLK_PHYCLK_USBHOST20_PHY_PHYCLOCK	107
+#define CLK_PHYCLK_USBHOST20_PHY_FREECLK	108
+#define CLK_PHYCLK_USBDRD30_UDRD30_PIPE_PCLK	109
+#define CLK_PHYCLK_USBDRD30_UDRD30_PHYCLOCK	110
+#define CLK_SCLK_MPHY			111
+#define CLK_SCLK_UFSUNIPRO		112
+#define CLK_SCLK_USBHOST30		113
+#define CLK_SCLK_USBDRD30		114
+
+#define FSYS_NR_CLK			115
 
 /* CMU_G2D */
 #define CLK_MUX_ACLK_G2D_266_USER	1
-- 
1.8.5.5

