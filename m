Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaBGFYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:24:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57081 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaBGFYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:24:34 -0500
X-AuditID: cbfee690-b7f266d00000287c-61-52f46e0fddc3
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 5/9 v6] clk: samsung exynos5250/5420: Add gate clock for SSS
 module
Date: Fri, 07 Feb 2014 10:54:14 +0530
Message-id: <1391750654-27401-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
References: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkSpc/70uQwbEmDouXhzQtul/JWPQu
	uMpmcf/eTyaLy7vmsFnMOL+PyWLRtv/MFmfnHGJy4PDYOesuu8e2A6oefVtWMXp83iQXwBLF
	ZZOSmpNZllqkb5fAlfF14hWWghtiFbMWfWFuYPwn1MXIySEhYCLRf/k2E4QtJnHh3nq2LkYu
	DiGBpYwSz/onMsIUnb9xihUisYhR4m3vUWaQhJBAP5PE3FNGIDabgJnEwUWr2UFsEQFnid/N
	a1hBbGaBlYwSi9bagNjCAqES284/AxvKIqAq8Xn3LqDNHBy8Aq4SPz+ogZgSAgoScyaBVXMK
	uEm8/L0DapOrxItpN8FukxCYxy6x6cc5VogxAhLfJh9igeiVldh0gBniZEmJgytusExgFF7A
	yLCKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIzC4T/97NmEH470D1ocYk4HGTWSWEk3OB0ZH
	Xkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw1uRy
	BXxi3njRTsOUtTFyt9jZnXN0JjjqpV5JmSd1ZRPL5nMNHMEa7Lftr/3jfs+R131mwYoVqn+K
	uxILm/pNk1b/iHijuo5ZV/dl5rwM688Zu/4v72aVkPqxSG+qtrT6ytcNN8pMbC/PuCf1Ztfl
	Vdk8a8PPf5Z1d9e6WPGbf8ftFQczc2InKrEUZyQaajEXFScCAK31umeEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t9jAV3+vC9BBnceM1q8PKRp0f1KxqJ3
	wVU2i/v3fjJZXN41h81ixvl9TBaLtv1ntjg75xCTA4fHzll32T22HVD16NuyitHj8ya5AJao
	BkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKAjlBTK
	EnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZXydeYSm4IVYxa9EX5gbGf0Jd
	jJwcEgImEudvnGKFsMUkLtxbz9bFyMUhJLCIUeJt71FmkISQQD+TxNxTRiA2m4CZxMFFq9lB
	bBEBZ4nfzWvAmpkFVjJKLFprA2ILC4RKbDv/jBHEZhFQlfi8exdTFyMHB6+Aq8TPD2ogpoSA
	gsScSWDVnAJuEi9/74Da5CrxYtpNtgmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525i
	BMfOM+kdjKsaLA4xCnAwKvHwnlj6OUiINbGsuDL3EKMEB7OSCC93wpcgId6UxMqq1KL8+KLS
	nNTiQ4zJQDdNZJYSTc4HxnVeSbyhsYm5qbGppYmFiZklacJK4rwHW60DhQTSE0tSs1NTC1KL
	YLYwcXBKAaNd2uLsEv01U/K9VR5ve9t+82GE1o4l2w5y+VpXNUuf7e791y1uZ7vh7/QpZgWi
	4uprY5eJBzO1B6ssP6HubBFU4cT3VsLw95RVn4rOWDHvNL7yoPB9q5zPidzLBm8+TzyUnPfk
	dOT0+mfnZ+nWxmRIa5cJTGy/Z9+55GxK9zdj75X8rG+mtCixFGckGmoxFxUnAgBZeRhH4QIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds gating clock for SSS(Security SubSystem)
module on Exynos5250/5420.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
TO: <linux-samsung-soc@vger.kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-crypto@vger.kernel.org>
---
changes since v5:
1. Added Reviewed-by: Tomasz Figa <t.figa@samsung.com>

 .../devicetree/bindings/clock/exynos5250-clock.txt |    1 +
 drivers/clk/samsung/clk-exynos5250.c               |    1 +
 drivers/clk/samsung/clk-exynos5420.c               |    4 ++++
 include/dt-bindings/clock/exynos5250.h             |    1 +
 4 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
index 72ce617..87f1539 100644
--- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
@@ -162,6 +162,7 @@ clock which they consume.
   g2d			345
   mdma0			346
   smmu_mdma0		347
+  sss			348
 
 
    [Clock Muxes]
diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index ff4beeb..2c52fe1 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -387,6 +387,7 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	 * CMU_ACP
 	 */
 	GATE(CLK_MDMA0, "mdma0", "div_aclk266", GATE_IP_ACP, 1, 0, 0),
+	GATE(CLK_SSS, "sss", "div_aclk266", GATE_IP_ACP, 2, 0, 0),
 	GATE(CLK_G2D, "g2d", "div_aclk200", GATE_IP_ACP, 3, 0, 0),
 	GATE(CLK_SMMU_MDMA0, "smmu_mdma0", "div_aclk266", GATE_IP_ACP, 5, 0, 0),
 
diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index ab4f2f7..c93d4d5 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -26,6 +26,7 @@
 #define DIV_CPU1		0x504
 #define GATE_BUS_CPU		0x700
 #define GATE_SCLK_CPU		0x800
+#define GATE_IP_G2D		0x8800
 #define CPLL_LOCK		0x10020
 #define DPLL_LOCK		0x10030
 #define EPLL_LOCK		0x10040
@@ -702,6 +703,9 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
 		0),
 	GATE(CLK_SMMU_MIXER, "smmu_mixer", "aclk200_disp1", GATE_IP_DISP1, 9, 0,
 		0),
+
+	/* SSS */
+	GATE(CLK_SSS, "sss", "aclk266_g2d", GATE_IP_G2D, 2, 0, 0),
 };
 
 static struct samsung_pll_clock exynos5420_plls[nr_plls] __initdata = {
diff --git a/include/dt-bindings/clock/exynos5250.h b/include/dt-bindings/clock/exynos5250.h
index 922f2dc..f9b452b 100644
--- a/include/dt-bindings/clock/exynos5250.h
+++ b/include/dt-bindings/clock/exynos5250.h
@@ -150,6 +150,7 @@
 #define CLK_G2D			345
 #define CLK_MDMA0		346
 #define CLK_SMMU_MDMA0		347
+#define CLK_SSS			348
 
 /* mux clocks */
 #define CLK_MOUT_HDMI		1024
-- 
1.7.9.5

