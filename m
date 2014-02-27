Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaB0LgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:36:19 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9024 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaB0LgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:36:16 -0500
X-AuditID: cbfee68f-b7f156d00000276c-10-530f232f0d60
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Graeme Gregory'" <gg@slimlogic.co.uk>
Subject: [PATCH 1/2] extcon: palmas: Use SIMPLE_DEV_PM_OPS macro
Date: Thu, 27 Feb 2014 20:36:15 +0900
Message-id: <000801cf33b0$1f9876e0$5ec964a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8zsB9vKpqotdqpRImP5zt9se4Hag==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zY119Zf5gg59PNCyuf3nOatG/xcXi
	8sJLrBaXd81hs7jduILNgdWjb8sqRo+pU/4yenzeJBfAHMVlk5Kak1mWWqRvl8CVsXLbZtaC
	DWwV8z5OZWlg3MTaxcjJISFgIjFv8id2CFtM4sK99WwgtpDAMkaJUw/4uxg5wGpebq6ACE9n
	lGhaHdLFyAVk/2aUWNrTzwiSYBNQk/jy5TDYHBEBLYmJnTOZQIqYBWYwSqx6MROoiJ1DWMBB
	4rcKSAmLgKrEv4M7wVbxCthKzD1/kBnCFpT4MfkeC4jNDDRm/c7jTBC2vMTmNW+ZIc5Rl3j0
	Vxdik57Evv+fGSFKRCT2vXjHCLJVQmATu8SmXXvYIXYJSHybfIgFoldWYtMBZohvJSUOrrjB
	MoFRbBaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJrv4djHcP
	WB9iTAZaP5FZSjQ5HxideSXxhsZmRhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qBcVHRSlF21Uf9FipvdASrdAXubM/b42r35bq1WZStuNaStopY6QfBqRzH
	XwYE3mi/+myjVuKSo+aMEtxPJ5j88chj1Xli+/DPoYTUWeU3Nqsm1O6T+xBopmi9nN81YMMf
	sxfvVC5dn/jYfBNPf+8llZtCs4O263LIfHPTXqV1+HT78j+nOg60K7EUZyQaajEXFScCAIkN
	k9PEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoK6+Mn+wwbm3KhbXvzxntejf4mJx
	eeElVovLu+awWdxuXMHmwOrRt2UVo8fUKX8ZPT5vkgtgjmpgtMlITUxJLVJIzUvOT8nMS7dV
	8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWqmkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxjzFi5bTNrwQa2inkfp7I0MG5i7WLk4JAQMJF4ubmii5ETyBSTuHBv
	PRuILSQwnVGiaXVIFyMXkP2bUWJpTz8jSIJNQE3iy5fD7CC2iICWxMTOmUwgRcwCMxglVr2Y
	CVTEziEs4CDxWwWkhEVAVeLfwZ1gM3kFbCXmnj/IDGELSvyYfI8FxGYGGrN+53EmCFteYvOa
	t8wQp6lLPPqrC7FJT2Lf/8+MECUiEvtevGOcwCgwC8mkWUgmzUIyaRaSlgWMLKsYRVMLkguK
	k9JzDfWKE3OLS/PS9ZLzczcxgqP3mdQOxpUNFocYBTgYlXh4Fdj4goVYE8uKK3MPMUpwMCuJ
	8K5n4g8W4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgYskriTc0NjEzsjQyszAyMTcnTVhJ
	nPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsbZ/lveX/y/XvJJzCfB7lzZdIat7AeZon2irXzV
	Hj5c7KZVeUHgVhwDfxdLeEVJvpjdr/sPdn936Ve+5qVv8iNHUioq7EPP30/ayY3hVjmFmj9Z
	tt45Ih67Z0KQSGaLs+yp+2xi+QUHLk5Ov82bUuZg5CU9PW3f/6fe85QWf38sv71xxZPIbUos
	xRmJhlrMRcWJAHRbLr4iAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/extcon/extcon-palmas.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 2aea4bc..ddff2b7 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -271,10 +271,7 @@ static int palmas_usb_resume(struct device *dev)
 };
 #endif
 
-static const struct dev_pm_ops palmas_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(palmas_usb_suspend,
-				palmas_usb_resume)
-};
+static SIMPLE_DEV_PM_OPS(palmas_pm_ops, palmas_usb_suspend, palmas_usb_resume);
 
 static struct of_device_id of_palmas_match_tbl[] = {
 	{ .compatible = "ti,palmas-usb", },
-- 
1.7.10.4


