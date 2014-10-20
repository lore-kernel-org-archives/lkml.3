Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaJTMJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:09:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61630 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaJTMIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:08:51 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-b0-5444fb4fb07c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, thomas.ab@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCHv4 2/4] clk: samsung: exynos3250: Update clock flags related to
 CPU to use cpu-clock type
Date: Mon, 20 Oct 2014 21:08:40 +0900
Message-id: <1413806922-22722-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1413806922-22722-1-git-send-email-cw00.choi@samsung.com>
References: <1413806922-22722-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkSNf/t0uIwfs1khbXvzxntZh0fwKL
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8ni8Jt2VouOZYwWq3b9YbTY+NXDgcdj
	56y77B53ru1h89i8pN6jb8sqRo/Pm+QCWKO4bFJSczLLUov07RK4Mh6+qy6YJF7R/esZewPj
	b+EuRk4OCQETiYML/zBC2GISF+6tZ+ti5OIQEljKKLFg/W42mKIHV5dDJaYzSsyfu5IRwmli
	krj4/zdYO5uAlsT+FzfAOkQEjCRW7VzKCmIzC+xlkrjw166LkYNDWCBL4tVeY5Awi4CqxIYD
	B8HKeQVcJTY17WKGWCYn8WHPI3YQm1PATWLN/VlgthBQza2eJlaQvRIC29glrk9uZYIYJCDx
	bfIhFpD5EgKyEpsOQM2RlDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzEC
	I+L0v2cTdjDeO2B9iFGAg1GJh3eHmUuIEGtiWXFl7iFGU6ANE5mlRJPzgXGXVxJvaGxmZGFq
	YmpsZG5ppiTO+1rqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxjliKzfaSapJfxF/oVqb
	minzNvHItFlCzmy5YgvX6Tkb5F5J53z7RnXC1o1bRC++7TKs1jqzp+iCuueuuf2zTOMFn12T
	OiydvtWje7v8yvQe2RijySfcfU62OylN+cgzo/YB7zfTCKXjHuUJrGznYxUdzn/bGpa37VIB
	y8VrNp/bLmkZz3UPUmIpzkg01GIuKk4EADdhL2yDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQV3/3y4hBpdP8Ftc//Kc1WLS/Qks
	Fr0LrrJZnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLw2/aWS06ljFarNr1h9Fi41cPBx6P
	nbPusnvcubaHzWPzknqPvi2rGD0+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBc
	j5EBGkhYw5jx8F11wSTxiu5fz9gbGH8LdzFyckgImEg8uLqcDcIWk7hwbz2QzcUhJDCdUWL+
	3JWMEE4Tk8TF/78ZQarYBLQk9r+4AdYhImAksWrnUlYQm1lgL5PEhb92XYwcHMICWRKv9hqD
	hFkEVCU2HDgIVs4r4CqxqWkXM8QyOYkPex6xg9icAm4Sa+7PArOFgGpu9TSxTmDkXcDIsIpR
	NLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjON6eSe9gXNVgcYhRgINRiYd3h5lLiBBrYllxZe4h
	RgkOZiUR3qhvQCHelMTKqtSi/Pii0pzU4kOMpkBXTWSWEk3OB6aCvJJ4Q2MTMyNLI3NDCyNj
	cyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjH7XNMqWzX2nIdbmO4kz7LZXe5+8U/Lm+ywV
	ldl26kripj8nxW5sNjBy9Mh0nn415/t/+cVN2wo7Dxx8EqL46Ep9na+xU92ch9lcC5Svcn8N
	SVust7BuvgSD/yON6Fc+bNuXhTE2iQTf1TfdePXZFgledolnP41rdG0fnO0MlD99NkAktn2K
	EktxRqKhFnNRcSIAfWQkOc0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch update clock flags related to CPU with read only flag
to use cpu-clock type.

Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/clk/samsung/clk-exynos3250.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
index aa55218..21e70ed 100644
--- a/drivers/clk/samsung/clk-exynos3250.c
+++ b/drivers/clk/samsung/clk-exynos3250.c
@@ -378,8 +378,10 @@ static struct samsung_mux_clock mux_clks[] __initdata = {
 	MUX(CLK_MOUT_MPLL_USER_C, "mout_mpll_user_c", mout_mpll_user_p,
 	    SRC_CPU, 24, 1),
 	MUX(CLK_MOUT_HPM, "mout_hpm", mout_hpm_p, SRC_CPU, 20, 1),
-	MUX(CLK_MOUT_CORE, "mout_core", mout_core_p, SRC_CPU, 16, 1),
-	MUX(CLK_MOUT_APLL, "mout_apll", mout_apll_p, SRC_CPU, 0, 1),
+	MUX_F(CLK_MOUT_CORE, "mout_core", mout_core_p, SRC_CPU, 16, 1, 0,
+			CLK_MUX_READ_ONLY),
+	MUX_F(CLK_MOUT_APLL, "mout_apll", mout_apll_p, SRC_CPU, 0, 1,
+			CLK_SET_RATE_PARENT, 0),
 };
 
 static struct samsung_div_clock div_clks[] __initdata = {
@@ -467,16 +469,24 @@ static struct samsung_div_clock div_clks[] __initdata = {
 	DIV(CLK_DIV_I2S, "div_i2s", "div_audio", DIV_PERIL5, 8, 6),
 
 	/* DIV_CPU0 */
-	DIV(CLK_DIV_CORE2, "div_core2", "div_core", DIV_CPU0, 28, 3),
-	DIV(CLK_DIV_APLL, "div_apll", "mout_apll", DIV_CPU0, 24, 3),
-	DIV(CLK_DIV_PCLK_DBG, "div_pclk_dbg", "div_core2", DIV_CPU0, 20, 3),
-	DIV(CLK_DIV_ATB, "div_atb", "div_core2", DIV_CPU0, 16, 3),
-	DIV(CLK_DIV_COREM, "div_corem", "div_core2", DIV_CPU0, 4, 3),
-	DIV(CLK_DIV_CORE, "div_core", "mout_core", DIV_CPU0, 0, 3),
+	DIV_F(CLK_DIV_CORE2, "div_core2", "div_core", DIV_CPU0, 28, 3,
+			CLK_GET_RATE_NOCACHE, CLK_DIVIDER_READ_ONLY),
+	DIV_F(CLK_DIV_APLL, "div_apll", "mout_apll", DIV_CPU0, 24, 3,
+			CLK_GET_RATE_NOCACHE, CLK_DIVIDER_READ_ONLY),
+	DIV_F(CLK_DIV_PCLK_DBG, "div_pclk_dbg", "div_core2", DIV_CPU0, 20, 3,
+			CLK_GET_RATE_NOCACHE, CLK_DIVIDER_READ_ONLY),
+	DIV_F(CLK_DIV_ATB, "div_atb", "div_core2", DIV_CPU0, 16, 3,
+			CLK_GET_RATE_NOCACHE, CLK_DIVIDER_READ_ONLY),
+	DIV_F(CLK_DIV_COREM, "div_corem", "div_core2", DIV_CPU0, 4, 3,
+			CLK_GET_RATE_NOCACHE, CLK_DIVIDER_READ_ONLY),
+	DIV_F(CLK_DIV_CORE, "div_core", "mout_core", DIV_CPU0, 0, 3,
+			CLK_GET_RATE_NOCACHE, CLK_DIVIDER_READ_ONLY),
 
 	/* DIV_CPU1 */
-	DIV(CLK_DIV_HPM, "div_hpm", "div_copy", DIV_CPU1, 4, 3),
-	DIV(CLK_DIV_COPY, "div_copy", "mout_hpm", DIV_CPU1, 0, 3),
+	DIV_F(CLK_DIV_HPM, "div_hpm", "div_copy", DIV_CPU1, 4, 3,
+			CLK_GET_RATE_NOCACHE, CLK_DIVIDER_READ_ONLY),
+	DIV_F(CLK_DIV_COPY, "div_copy", "mout_hpm", DIV_CPU1, 0, 3,
+			CLK_GET_RATE_NOCACHE, CLK_DIVIDER_READ_ONLY),
 };
 
 static struct samsung_gate_clock gate_clks[] __initdata = {
-- 
1.8.0

