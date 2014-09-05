Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaIEL7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:59:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25198 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaIEL7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:59:30 -0400
X-AuditID: cbfee690-f79ce6d00000115a-4f-5409a5894467
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, s.nawrocki@samsung.com,
        mturquette@linaro.org, naushad@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] clk: samsung: exynos3250: fix width field of mout_mmc0/1
Date: Fri, 05 Sep 2014 17:24:41 +0530
Message-id: <1409918081-2464-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkTrdzKWeIwb0fkha9C66yWWx6fI3V
	4vKuOWwWM87vY7J4OuEim8Wno/9ZLRZt/cJucfhNO6vFql1/GB04PXbOusvucefaHjaPzUvq
	Pfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSvj99cLjAU32SveTmhmbWA8ydbFyMkhIWAi0fF1
	EhOELSZx4d56sLiQwFJGiQV3o2FqensnMHcxcgHFpzNKHNlxgAXCmcAksWvndrBuNgFdiSfv
	5zKD2CIC2RL9t1eDFTELLGSU2HX3GmsXIweHsICnRNteeZAaFgFVietvtzGC2LwC7hI3t89g
	BCmREFCQmDPJBqRVQqCfXaLvwE9WiHoBiW+TD7FA1MhKbDrADHGcpMTBFTdYJjAKLmBkWMUo
	mlqQXFCclF5kolecmFtcmpeul5yfu4kRGMan/z2bsIPx3gHrQ4wCHIxKPLw/vnKECLEmlhVX
	5h5iNAXaMJFZSjQ5HxgteSXxhsZmRhamJqbGRuaWZkrivK+lfgYLCaQnlqRmp6YWpBbFF5Xm
	pBYfYmTi4JRqYGxdO4O37IFwlFNff9Hyv+3iX6PPln90rF+6VWPF2qeMl2oCN/yacmDD3UjD
	iYxlvKvnliTuaeHXsbmguFej0lWzRvbilJc/X0q5FKcInKk1qrPXlkhcdXnW74nSRjM//au5
	V8htt/DqrKWn7xwpr2AN2O9dov13n92bI8mnp/V7VgTKarS0vFNiKc5INNRiLipOBACohWQv
	XgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jQd3OpZwhBqseCVr0LrjKZrHp8TVW
	i8u75rBZzDi/j8ni6YSLbBafjv5ntVi09Qu7xeE37awWq3b9YXTg9Ng56y67x51re9g8Ni+p
	9+jbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGb+/XmAs
	uMle8XZCM2sD40m2LkZODgkBE4ne3gnMELaYxIV764HiXBxCAtMZJY7sOMAC4Uxgkti1czsT
	SBWbgK7Ek/dzwTpEBLIl+m+vBitiFljIKLHr7jXWLkYODmEBT4m2vfIgNSwCqhLX325jBLF5
	Bdwlbm6fwQhSIiGgIDFnks0ERu4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLj5JnU
	DsaVDRaHGAU4GJV4eBd85ggRYk0sK67MPcQowcGsJMLrPoUzRIg3JbGyKrUoP76oNCe1+BCj
	KdDyicxSosn5wBjOK4k3NDYxNzU2tTSxMDGzVBLnPdBqHSgkkJ5YkpqdmlqQWgTTx8TBKdXA
	2HhtH7vHX0N+9rV+pt4CX2LEnwczOIUGKYoaiX3b9c4zWHNReedGiTsvcpZ/sizbKRYb/L3C
	jVFmqmCqhfStZyeNwt/p5O5am2VRU++X8/Ze9lzFaTYhAtz2Cx9nsc+e63Pr3b+Kt/kq6YlX
	/7p1Kz7ZPHkr846fBdyXy9o2Lc/N7brWu4lFiaU4I9FQi7moOBEAccHOZ6kCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per Exynos3250 user manual mmc0/1 mux selection has 4 bit wide.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/samsung/clk-exynos3250.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
index 7a17bd4..e1cb464 100644
--- a/drivers/clk/samsung/clk-exynos3250.c
+++ b/drivers/clk/samsung/clk-exynos3250.c
@@ -335,8 +335,8 @@ static struct samsung_mux_clock mux_clks[] __initdata = {
 
 	/* SRC_FSYS */
 	MUX(CLK_MOUT_TSADC, "mout_tsadc", group_sclk_p, SRC_FSYS, 28, 4),
-	MUX(CLK_MOUT_MMC1, "mout_mmc1", group_sclk_p, SRC_FSYS, 4, 3),
-	MUX(CLK_MOUT_MMC0, "mout_mmc0", group_sclk_p, SRC_FSYS, 0, 3),
+	MUX(CLK_MOUT_MMC1, "mout_mmc1", group_sclk_p, SRC_FSYS, 4, 4),
+	MUX(CLK_MOUT_MMC0, "mout_mmc0", group_sclk_p, SRC_FSYS, 0, 4),
 
 	/* SRC_PERIL0 */
 	MUX(CLK_MOUT_UART1, "mout_uart1", group_sclk_p, SRC_PERIL0, 4, 4),
-- 
1.7.9.5

