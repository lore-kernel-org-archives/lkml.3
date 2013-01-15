Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab3AONer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:34:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53547 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab3AONen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:34:43 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-f3-50f55ad9c26d
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, dianders@chromium.org, jg1.han@samsung.com
Subject: [PATCH v4 3/4] ARM: Exynos5250: Add clock information for dwc3-exynos
Date: Tue, 15 Jan 2013 19:08:31 +0530
Message-id: <1358257112-19595-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWyRsSkRvdm1NcAgyPTjC0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgypg39xRLwSn+ii/PpBoYN/F0MXJySAiYSDxc
	cp8JwhaTuHBvPVsXIxeHkMBSRonfyy+zwBSdfdfDApFYxCjR9nsWI4QzmUliw7tfjCBVbAK6
	Ek1vd4HZIgKqEp/bFrCD2MwChxglTk11B7GFBfwkfu/uBZvKAlQz8eQnsNW8Ah4STzp3s0Js
	U5B4c/sZcxcjBwengKfEg6leIKYQUMmMxc4QnQIS3yYfYgEJSwjISmw6wAxyjYTAfTaJZdfu
	QU2RlDi44gbLBEbhBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzECQ/L0v2dSOxhXNlgc
	YhTgYFTi4b2p+yVAiDWxrLgyF+h0DmYlEV4No68BQrwpiZVVqUX58UWlOanFhxh9gC6ZyCwl
	mpwPjJe8knhDYxNzU2NTSyMjM1NTHMJK4ryMp54ECAmkJ5akZqemFqQWwYxj4uAExkua3/YY
	CQmf46YBcZNXzKuN3iT1oelXs8v0g3P3xalNm5ylwGl90qDjF2eTyNkezuXFk1YvWTjp/JW1
	PhPNyn5u5GyZ5ZXIJry592WzWb+ZrPGPPasru26bLP/pf3b+l3Vnl/vwzn36WMx8w51vsZY+
	LZrnTFz6L+ayTeecZmfs/Mu3MEfl4l0lluKMREMt5qLiRAAlrwOCdgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAd2bUV8DDCbd17C4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj3txT
	LAWn+Cu+PJNqYNzE08XIySEhYCJx9l0PC4QtJnHh3nq2LkYuDiGBRYwSbb9nMUI4k5kkNrz7
	xQhSxSagK9H0dheYLSKgKvG5bQE7iM0scIhR4tRUdxBbWMBP4vfuXrCpLEA1E09+YgKxeQU8
	JJ507maF2KYg8eb2M+YuRg4OTgFPiQdTvUBMIaCSGYudJzDyLmBkWMUomlqQXFCclJ5rqFec
	mFtcmpeul5yfu4kRHPDPpHYwrmywOMQowMGoxMN7U/dLgBBrYllxZS7QKRzMSiK8GkZfA4R4
	UxIrq1KL8uOLSnNSiw8x+gDdNJFZSjQ5HxiNeSXxhsYm5qbGppYmFiZmljiElcR5GU89CRAS
	SE8sSc1OTS1ILYIZx8TBCQzO1T+ksgLy7T5p1Bza6GbLvK3Dx+oi+5LqHdMPF29aslHpfUGM
	T/cbo2af7F1L446G7vAw6CnXznN//v/TZYnPqio7zBN7/8cnyXYzH78V2R9ZsGT18qAHR3sy
	M6Z8vB229oZMZETMKr/cSeaFdScPVl4+t1bCj9/pi8LRIxJ8St+72EwaT79UYinOSDTUYi4q
	TgQAgcJKuaUCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding necessary device clock to exynos5 needed for
the DWC3 controller.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/mach-exynos/clock-exynos5.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index 0208c3a..13af020 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -757,6 +757,11 @@ static struct clk exynos5_init_clocks_off[] = {
 		.enable		= exynos5_clk_ip_fsys_ctrl ,
 		.ctrlbit	= (1 << 18),
 	}, {
+		.name		= "usbdrd30",
+		.parent		= &exynos5_clk_aclk_200.clk,
+		.enable		= exynos5_clk_ip_fsys_ctrl,
+		.ctrlbit	= (1 << 19),
+	}, {
 		.name		= "usbotg",
 		.enable		= exynos5_clk_ip_fsys_ctrl,
 		.ctrlbit	= (1 << 7),
@@ -1035,6 +1040,16 @@ static struct clksrc_sources exynos5_clkset_group = {
 	.nr_sources	= ARRAY_SIZE(exynos5_clkset_group_list),
 };
 
+struct clk *exynos5_clkset_usbdrd30_list[] = {
+	[0] = &exynos5_clk_mout_mpll.clk,
+	[1] = &exynos5_clk_mout_cpll.clk,
+};
+
+struct clksrc_sources exynos5_clkset_usbdrd30 = {
+	.sources        = exynos5_clkset_usbdrd30_list,
+	.nr_sources     = ARRAY_SIZE(exynos5_clkset_usbdrd30_list),
+};
+
 /* Possible clock sources for aclk_266_gscl_sub Mux */
 static struct clk *clk_src_gscl_266_list[] = {
 	[0] = &clk_ext_xtal_mux,
@@ -1329,6 +1344,15 @@ static struct clksrc_clk exynos5_clksrcs[] = {
 			.parent		= &exynos5_clk_mout_cpll.clk,
 		},
 		.reg_div = { .reg = EXYNOS5_CLKDIV_GEN, .shift = 4, .size = 3 },
+	}, {
+		.clk    = {
+			.name           = "sclk_usbdrd30",
+			.enable         = exynos5_clksrc_mask_fsys_ctrl,
+			.ctrlbit        = (1 << 28),
+		},
+		.sources = &exynos5_clkset_usbdrd30,
+		.reg_src = { .reg = EXYNOS5_CLKSRC_FSYS, .shift = 28, .size = 1 },
+		.reg_div = { .reg = EXYNOS5_CLKDIV_FSYS0, .shift = 24, .size = 4 },
 	},
 };
 
-- 
1.7.6.5

