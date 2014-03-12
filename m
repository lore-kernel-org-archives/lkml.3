Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbaCLHIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 03:08:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62053 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbaCLHIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 03:08:51 -0400
X-AuditID: cbfee690-b7f266d00000287c-6b-532007df1c30
From: Chanwoo Choi <cw00.choi@samsung.com>
To: t.figa@samsung.com, a.hajda@samsung.com, mturquette@linaro.org,
        kgene.kim@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] clk: exynos4: Add clock ID for ppmuleft/right
Date: Wed, 12 Mar 2014 16:08:10 +0900
Message-id: <1394608090-25362-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSrPuAXSHY4McpZotb686xWlz/8pzV
	Yv4RIKv/zUJWi3OvVjJa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaLpdcvMlk8nXCRzWLC
	9LUsFutnvGZx4PNYM28No8flvl4mj5XLv7B53Lm2h81j85J6j74tqxg9Pm+SC2CP4rJJSc3J
	LEst0rdL4Mr4vuIke8EhoYp/zx4yNTCe5u9i5OSQEDCR2LzpHSOELSZx4d56ti5GLg4hgaWM
	Env+7WGEKdq+bAYjRGI6o8Ss9lusEE4jk8SMWdfAqtgEtCT2v7jBBmKLCERLnJp7DayIWWAt
	k8SLuzPBioQF7CT2T+sEs1kEVCWmzH3AAmLzCrhK3Pj9nwlinZzEhz2P2EGaJQT2sUtM27eM
	CaJBQOLb5ENADRxACVmJTQeYIeolJQ6uuMEygVFwASPDKkbR1ILkguKk9CITveLE3OLSvHS9
	5PzcTYzAmDj979mEHYz3DlgfYkwGGjeRWUo0OR8YU3kl8YbGZkYWpiamxkbmlmakCSuJ86o9
	SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwDgp4HkJ37VLAdLqBkzC5d3Nuz8K3w9ff7v7
	SNwxPq6cc0uXHrp6gOHIbumWpxuEjqmXiD/blC/xKiBd/cBrJ7vnnNYnLffvd9uw7mORmsJv
	yRnal5sPRuUrL21eFxprcjji6Um2tEa51Fs9S6/kXfR//Um66iuj/aSsjOuzJ93YxOTQXTJp
	/h4lluKMREMt5qLiRACJJr7ynwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jQd377ArBBv/vm1vcWneO1eL6l+es
	FvOPAFn9bxayWpx7tZLRonfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZLL1+kcni6YSLbBYT
	pq9lsVg/4zWLA5/HmnlrGD0u9/Uyeaxc/oXN4861PWwem5fUe/RtWcXo8XmTXAB7VAOjTUZq
	YkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QzUoKZYk5pUCh
	gMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjO8rTrIXHBKq+PfsIVMD42n+LkZODgkB
	E4nty2YwQthiEhfurWfrYuTiEBKYzigxq/0WK4TTyCQxY9Y1sCo2AS2J/S9usIHYIgLREqfm
	XgMrYhZYyyTx4u5MsCJhATuJ/dM6wWwWAVWJKXMfsIDYvAKuEjd+/2eCWCcn8WHPI/YJjNwL
	GBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH3DPpHYyrGiwOMQpwMCrx8C7UlA8WYk0s
	K67MPcQowcGsJML7ESTEm5JYWZValB9fVJqTWnyIMRlo+0RmKdHkfGAyyCuJNzQ2MTOyNDI3
	tDAyNidNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxvkF02Y2Lbg4rTVXPozx4K03Nocv
	FwidnZfGqXlG2buJt133f1ze9Sl+1l9e63zKeGP38v9XSf/P3pcCj07ONhbl7dUNKWFP/ZWd
	dkj1z437HyZLz5196GdcUTOT734z8ZwK5gJepyj3j0krXB7H+ChvVPlwrfPfffbWqOld15d+
	6lbNUrzlpMRSnJFoqMVcVJwIAH1NQ9f8AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no gate for the PPMU Left/Right to the LEFT/RIGHTBUS block.
So, this patch add ppmuleft/right clock which is used to calculate memory bus
utilization by using PPMU(Performance Profiling Monitoring Unit).

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/clk/samsung/clk-exynos4.c   |  2 ++
 include/dt-bindings/clock/exynos4.h | 26 ++++++++++++++------------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 010f071..3819485 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -717,6 +717,8 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 			0, 0),
 	GATE(CLK_AC97, "ac97", "aclk100", GATE_IP_PERIL, 27,
 			0, 0),
+	GATE(CLK_PPMULEFT, "ppmuleft", "aclk200", GATE_IP_LEFTBUS, 1, 0, 0),
+	GATE(CLK_PPMURIGHT, "ppmuright", "aclk200", GATE_IP_RIGHTBUS, 1, 0, 0),
 };
 
 /* list of gate clocks supported in exynos4210 soc */
diff --git a/include/dt-bindings/clock/exynos4.h b/include/dt-bindings/clock/exynos4.h
index 75aff33..cd7fecf 100644
--- a/include/dt-bindings/clock/exynos4.h
+++ b/include/dt-bindings/clock/exynos4.h
@@ -215,20 +215,22 @@
 #define CLK_SPI1_ISP_SCLK	381 /* Exynos4x12 only */
 #define CLK_UART_ISP_SCLK	382 /* Exynos4x12 only */
 #define CLK_TMU_APBIF		383
+#define CLK_PPMULEFT		384
+#define CLK_PPMURIGHT		385
 
 /* mux clocks */
-#define CLK_MOUT_FIMC0		384
-#define CLK_MOUT_FIMC1		385
-#define CLK_MOUT_FIMC2		386
-#define CLK_MOUT_FIMC3		387
-#define CLK_MOUT_CAM0		388
-#define CLK_MOUT_CAM1		389
-#define CLK_MOUT_CSIS0		390
-#define CLK_MOUT_CSIS1		391
-#define CLK_MOUT_G3D0		392
-#define CLK_MOUT_G3D1		393
-#define CLK_MOUT_G3D		394
-#define CLK_ACLK400_MCUISP	395 /* Exynos4x12 only */
+#define CLK_MOUT_FIMC0		386
+#define CLK_MOUT_FIMC1		387
+#define CLK_MOUT_FIMC2		388
+#define CLK_MOUT_FIMC3		389
+#define CLK_MOUT_CAM0		390
+#define CLK_MOUT_CAM1		391
+#define CLK_MOUT_CSIS0		392
+#define CLK_MOUT_CSIS1		393
+#define CLK_MOUT_G3D0		394
+#define CLK_MOUT_G3D1		395
+#define CLK_MOUT_G3D		396
+#define CLK_ACLK400_MCUISP	397 /* Exynos4x12 only */
 
 /* div clocks */
 #define CLK_DIV_ISP0		450 /* Exynos4x12 only */
-- 
1.8.0

