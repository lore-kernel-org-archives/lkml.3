Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaEGHzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:55:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44605 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaEGHzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:55:12 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-3b-5369e6df1a90
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Philipp Zabel'" <p.zabel@pengutronix.de>,
        "'Shawn Guo'" <shawn.guo@linaro.org>
Subject: [PATCH 1/5] regulator: anatop: Make of_device_id array const
Date: Wed, 07 May 2014 16:55:10 +0900
Message-id: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pyau3FkiFWFjRR4iSx3x0aUKqEQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zA937zzKDDWY94rWY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF3XsnWCyerlvC7MDmsXPWXXaPTas62TzuXNvD5tH/18Cjb8sqRo/Pm+QC
	2KK4bFJSczLLUov07RK4MlbM2sNa0MRWMa1DtYGxg7WLkZNDQsBE4ticdcwQtpjEhXvr2boY
	uTiEBJYxSrR+3c8EU3Tq8j8WiMR0RomJS+5BVf1mlOjcsA2sik1ATeLLl8PsXYwcHCICqhL/
	X7mD1DAL7GWUOH18GjtIjbCAq8SXRUfB6lmAahqntrKA2LwCthL/V/WyQtiCEj8m3wOLMwto
	SazfeZwJwpaX2LzmLTPIfAkBdYlHf3VBwiICehIbLj6GKhGR2PfiHSPE0ZfYJeY3KkGsEpD4
	NvkQC0SrrMSmA1APS0ocXHGDZQKj2Cwki2chWTwLyeJZSDYsYGRZxSiaWpBcUJyUXmSkV5yY
	W1yal66XnJ+7iRESiX07GG8esD7EmAy0fiKzlGhyPjCS80riDY3NjCxMTUyNjcwtzUgTVhLn
	XfQwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo05s0GHenRynH/GtOc8e7DyZd7lBw59X
	H6YmL6t77CDYvTBw7q8lrIGmytMrDrXNudXx8bdp5S2F8+dvTw7sNy2/qrE87MgJi+dtkw7M
	zt3JcMXk/vaG9v930oMr1tTfj1Ta90Eg3CXnsc+Uhnsyx8o7Jr2ZbXXpp+DP969Wv0prflDR
	8Zf99DwlluKMREMt5qLiRADDPejD2gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jQd37zzKDDR6fYbeY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF3XsnWCyerlvC7MDmsXPWXXaPTas62TzuXNvD5tH/18Cjb8sqRo/Pm+QC
	2KIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWasmLWHtaCJrWJah2oDYwdr
	FyMnh4SAicSpy/9YIGwxiQv31rN1MXJxCAlMZ5SYuOQelPObUaJzwzYmkCo2ATWJL18Os3cx
	cnCICKhK/H/lDlLDLLCXUeL08WnsIDXCAq4SXxYdBatnAappnNoKtoFXwFbi/6peVghbUOLH
	5HtgcWYBLYn1O48zQdjyEpvXvGUGmS8hoC7x6K8uSFhEQE9iw8XHUCUiEvtevGOcwCgwC8mk
	WUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgiP9mdQOxpUNFocYBTgY
	lXh4Ld5mBAuxJpYVV+YeYpTgYFYS4d11MTNYiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OB
	SSivJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhj1zj5eUd3E
	NO3AhiDOQNdlFpdKY+yq4u99iDb/1rM+SfyZ1eUra2Yfe7Wx1Ck8OZszzzPBmE3sxYkZskxm
	qys5JCdyZX7Wn2LouG3KhaVpL96uUBKftdx85q+UGyVvTk3oZnrIbZ6a6Bby07pjfcDSL17S
	WdI5W97JZhuXHljB1HBzpVNeuLoSS3FGoqEWc1FxIgAMWU9EOAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions
handle it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/anatop-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 7c397bb..4f730af 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -300,7 +300,7 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id of_anatop_regulator_match_tbl[] = {
+static const struct of_device_id of_anatop_regulator_match_tbl[] = {
 	{ .compatible = "fsl,anatop-regulator", },
 	{ /* end */ }
 };
-- 
1.7.10.4


