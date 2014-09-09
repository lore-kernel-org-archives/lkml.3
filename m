Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaIIL7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:59:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26900 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaIIL7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:59:39 -0400
X-AuditID: cbfee68e-f79536d000000fd1-34-540eeba956d4
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, s.nawrocki@samsung.com,
        mturquette@linaro.org, naushad@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] clk: samsung: exynos3250: fix width and shift of div_spi0_isp
 clock
Date: Tue, 09 Sep 2014 17:24:57 +0530
Message-id: <1410263697-768-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWyRsSkSnfla74Qg4czZS16F1xls9j0+Bqr
	xeVdc9gsZpzfx2TxdMJFNotPR/+zWiza+oXd4vCbdlaLVbv+MDpweuycdZfd4861PWwem5fU
	e/RtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfGxY2fGQuusVd8bJ/D1MB4jq2LkYNDQsBEYmYP
	XxcjJ5ApJnHh3nqgMBeHkMBSRonueccYIRImEtd6pzKB2EICixgl5h6MhiiawCSx9c8UsCI2
	AV2JJ+/nMoPYIgLZEv23V7OAFDELLGSU2HX3GitIQlggTOLr5XlgRSwCqhL/d05lB7mCV8BN
	YlJrOcRBChJzJtmAtEoI9LNLTHy3CqpcQOLb5EMsEDWyEpsOMEPcJilxcMUNlgmMggsYGVYx
	iqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBAbx6X/P+nYw3jxgfYhRgINRiYc3I5gvRIg1say4
	MvcQoynQhonMUqLJ+cBYySuJNzQ2M7IwNTE1NjK3NFMS502Q+hksJJCeWJKanZpakFoUX1Sa
	k1p8iJGJg1OqgVH6yvTvfD+0FB9efls9IdAlTvDt8qb+cOmiaVJeSzsWz+ObbbNmtVH5Rsmy
	+3zTf5X39QnJXI7e0VmRevP46/M/K1uaPjGE//Z8dY3bbKqD6UqbkgnlH7V++uns+CqSqbTk
	+iKfHce/hW1p+hSQuzV4uuSHWZv9b0T+dH7Mv6pC3XJmZ80PK2UlluKMREMt5qLiRABvf3PM
	XQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jAd2Vr/lCDNrPiVj0LrjKZrHp8TVW
	i8u75rBZzDi/j8ni6YSLbBafjv5ntVi09Qu7xeE37awWq3b9YXTg9Ng56y67x51re9g8Ni+p
	9+jbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGRc3fmYs
	uMZe8bF9DlMD4zm2LkZODgkBE4lrvVOZIGwxiQv31oPFhQQWMUrMPRjdxcgFZE9gktj6Zwoj
	SIJNQFfiyfu5zCC2iEC2RP/t1SwgRcwCCxkldt29xgqSEBYIk/h6eR5YEYuAqsT/nVPZuxg5
	OHgF3CQmtZaDmBICChJzJtlMYORewMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Sp5J
	7WBc2WBxiFGAg1GJhzcjmC9EiDWxrLgy9xCjBAezkgiv9QugEG9KYmVValF+fFFpTmrxIUZT
	oN0TmaVEk/OBEZxXEm9obGJuamxqaWJhYmapJM57oNU6UEggPbEkNTs1tSC1CKaPiYNTqoFR
	M9JHT3XLLU39q3Ncpsfqt6+5lWUhMrHtctgqRr/1jr6Xt29du0a3j1ejZZ6m48vvDFutMs6e
	Zbherf5yU7nk7EXznee/VPHKrVrqHFCufcF84fMJpY++3tE4cGIV07z26plCB+tOfOeSPXYw
	+vN7JecZ5wUaXzczzO+eOE3i+QbfprUHJLxfKLEUZyQaajEXFScCACVdm3GoAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update shift and width field of div_spi0_isp clock as per Exynos3250
user manual.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/samsung/clk-exynos3250.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
index ba8f073f..a3dee34 100644
--- a/drivers/clk/samsung/clk-exynos3250.c
+++ b/drivers/clk/samsung/clk-exynos3250.c
@@ -406,7 +406,7 @@ static struct samsung_div_clock div_clks[] __initdata = {
 	DIV(CLK_DIV_SPI1_ISP, "div_spi1_isp", "mout_spi1_isp", DIV_ISP, 16, 4),
 	DIV_F(CLK_DIV_SPI0_ISP_PRE, "div_spi0_isp_pre", "div_spi0_isp",
 		DIV_ISP, 8, 8, CLK_SET_RATE_PARENT, 0),
-	DIV(CLK_DIV_SPI0_ISP, "div_spi0_isp", "mout_spi0_isp", DIV_ISP, 0, 4),
+	DIV(CLK_DIV_SPI0_ISP, "div_spi0_isp", "mout_spi0_isp", DIV_ISP, 4, 4),
 
 	/* DIV_FSYS0 */
 	DIV_F(CLK_DIV_TSADC_PRE, "div_tsadc_pre", "div_tsadc", DIV_FSYS0, 8, 8,
-- 
1.7.9.5

