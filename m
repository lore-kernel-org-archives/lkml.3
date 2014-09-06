Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaIFNIC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 09:08:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53461 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaIFNH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 09:07:57 -0400
X-AuditID: cbfee68d-f79c46d000000b84-2e-540b072b680b
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, s.nawrocki@samsung.com,
        mturquette@linaro.org, naushad@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] clk: samsung: exynos3250: fix mout_cam_blk parent list
Date: Sat, 06 Sep 2014 18:33:33 +0530
Message-id: <1410008613-20861-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkRlebnTvE4P0hbYveBVfZLDY9vsZq
	cXnXHDaLGef3MVk8nXCRzeLT0f+sFou2fmG3OPymndVi1a4/jA6cHjtn3WX3uHNtD5vH5iX1
	Hn1bVjF6fN4kF8AaxWWTkpqTWZZapG+XwJWxd14LS8Fbtorz+xayNjAeZe1i5OSQEDCRWHHo
	AAuELSZx4d56ti5GLg4hgaWMEi9P7QFyOMCKzhyug4gvYpT4NOcjC4QzgUniaM9kNpBuNgFd
	iSfv5zKD2CIC2RL9t1eDFTELLGSU2HX3Gtg6YQF3iY3X7oLZLAKqEm+urmAF2cAr4CGxr9cC
	YpmCxJxJNiCtEgLd7BJtzQ3MEOUCEt8mH2KBqJGV2HSAGeJoSYmDK26wTGAUXMDIsIpRNLUg
	uaA4Kb3IUK84Mbe4NC9dLzk/dxMjMIxP/3vWu4Px9gHrQ4wCHIxKPLwnnLhChFgTy4orcw8x
	mgJtmMgsJZqcD4yWvJJ4Q2MzIwtTE1NjI3NLMyVxXkWpn8FCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGK+b+n372BbjWXPyc2nEq3lHL1gul2bXVtpRNK0kTyd32swntrGR59jyDCOa2n5H
	8+v8NZQxmKdY59+dz6G3RGnZ/K535xuMjx7M7G0VWpGx6d6PPvG3BS8EOUsedk620Dd+8mpd
	1Euj+FOvMpNeiP2TFM38u7471kBa8brQnvVKPoHRDmdslViKMxINtZiLihMByosbrF4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jAV1tdu4QgxeLlSx6F1xls9j0+Bqr
	xeVdc9gsZpzfx2TxdMJFNotPR/+zWiza+oXd4vCbdlaLVbv+MDpweuycdZfd4861PWwem5fU
	e/RtWcXo8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjL3zWlgK
	3rJVnN+3kLWB8ShrFyMHh4SAicSZw3VdjJxAppjEhXvr2boYuTiEBBYxSnya85EFwpnAJHG0
	ZzIbSBWbgK7Ek/dzmUFsEYFsif7bq8GKmAUWMkrsunuNFSQhLOAusfHaXTCbRUBV4s3VFWDb
	eAU8JPb1WkAsVpCYM8lmAiP3AkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBUfJMegfj
	qgaLQ4wCHIxKPLyFDlwhQqyJZcWVuYcYJTiYlUR4OyYDhXhTEiurUovy44tKc1KLDzGaAu2e
	yCwlmpwPjOC8knhDYxNzU2NTSxMLEzNLJXHeg63WgUIC6YklqdmpqQWpRTB9TBycUg2MFidz
	XY/MMquNiz9qtqNi73LBo1qVq2ZYBIhN+MNY8uJLfH12ALPcwlms7AEiDWcfhosfYXpsH3xv
	bqd00atdsfM+nZu/Z/ZUk2zpes/6+zoTDvnJyN849OCl0ALndWcPt635+9dVrcqhfN/Vb34O
	21WKkhlC2jUdArU4uoqd4/93/Oq7v2+pEktxRqKhFnNRcSIAlw7896gCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per user manual of Exynos3250 SRC_CAM can select
div_cam_blk_320 if it's value is 0xC, so placing
div_cam_blk_320 at proper index in parent list of mout_cam_blk.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/samsung/clk-exynos3250.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
index e1cb464..ba8f073f 100644
--- a/drivers/clk/samsung/clk-exynos3250.c
+++ b/drivers/clk/samsung/clk-exynos3250.c
@@ -248,6 +248,7 @@ PNAME(group_sclk_cam_blk_p)	= { "xxti", "xusbxti",
 				    "none", "none", "none",
 				    "none", "div_mpll_pre",
 				    "mout_epll_user", "mout_vpll",
+				    "none", "none", "none",
 				    "div_cam_blk_320", };
 PNAME(group_sclk_fimd0_p)	= { "xxti", "xusbxti",
 				    "m_bitclkhsdiv4_2l", "none",
-- 
1.7.9.5

