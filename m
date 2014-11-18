Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaKRI74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:59:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25027 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaKRI7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:59:52 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-6e-546b0a806b29
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 3/5] clk: s2mps11: Add the support for S2MPS13 PMIC clock
Date: Tue, 18 Nov 2014 17:59:41 +0900
Message-id: <1416301183-10478-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
References: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSotvAlR1icLFb02LJxavsFlMfPmGz
	uP7lOavF/CPnWC3+TGhls5h0fwKLxesXhhZnm96wW9z/epTR4tuVDiaLy7vmsFk8nXCRzeJ0
	N6vFxRVfmBz4PHbOusvusWlVJ5vHnWt72DzmnQz06NuyitFj+ryfTB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZexc/pql4I1Axac93cwNjI18XYycHBICJhIvp/9hg7DFJC7cWw9kc3EICSxllPj6
	eD4TTNGVOWugEtMZJSb8/skE4TQxSWxs+sIIUsUmoCWx/8UNsFEiAtESx58eZwQpYhboYZJ4
	37sRrEhYwFvixeJZrCA2i4CqxJ6p98FW8Aq4Shy6eQxqnYLEsuUzwWo4BdwkDhxfDDZUCKjm
	dOdBZpChEgKX2CUOdV2FGiQg8W3yIZYuRg6ghKzEpgPMEHMkJQ6uuMEygVF4ASPDKkbR1ILk
	guKk9CITveLE3OLSvHS95PzcTYzA+Dn979mEHYz3DlgfYhTgYFTi4U2cmhUixJpYVlyZe4jR
	FGjDRGYp0eR8YJTmlcQbGpsZWZiamBobmVuaKYnzvpb6GSwkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qBUTl7YtQx652aGide7/p9cVZM3ZrOPxeO+817/f7APbW8/st3324TYA5IX3W9bXG6
	qc1SjekBhnvOm8j/686Nvx6pq3DVIoW5ueOs0eZZh6ZzTPr7X29Xmvsxqd0SBjF22vWZT+3r
	5xWtO+ux6VqNyqsouWrGvxeSCtmNFs5bcWSCqJNQ+LeTOkosxRmJhlrMRcWJAHzie0aaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd0GruwQg2d9ihZLLl5lt5j68Amb
	xfUvz1kt5h85x2rxZ0Irm8Wk+xNYLF6/MLQ42/SG3eL+16OMFt+udDBZXN41h83i6YSLbBan
	u1ktLq74wuTA57Fz1l12j02rOtk87lzbw+Yx72SgR9+WVYwe0+f9ZPL4vEkugD2qgdEmIzUx
	JbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hiJYWyxJxSoFBA
	YnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGzuWvWQreCFR82tPN3MDYyNfFyMkhIWAi
	cWXOGjYIW0ziwr31QDYXh5DAdEaJCb9/MkE4TUwSG5u+MIJUsQloSex/cQOsQ0QgWuL40+OM
	IEXMAj1MEu97N4IVCQt4S7xYPIsVxGYRUJXYM/U+E4jNK+AqcejmMSaIdQoSy5bPBKvhFHCT
	OHB8MdhQIaCa050HmScw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERydz6R3MK5q
	sDjEKMDBqMTDmzg1K0SINbGsuDL3EKMEB7OSCO+5bqAQb0piZVVqUX58UWlOavEhRlOgqyYy
	S4km5wMTR15JvKGxiZmRpZG5oYWRsbmSOO/BVutAIYH0xJLU7NTUgtQimD4mDk6pBkad4GOf
	I3oSS/z8lntarspbLFRoyLSr6OiNb8XhpvXCBxmsXPYketm25x0u3XYw8YxtfUTWXV+720/C
	PigKsNkK2mz77KucfaSLk6vD70JDZ+2+WSeS6/ZopIWde79qq9iJYouu9dsZbFV1bim8U73b
	yCJvdiIn/oWF44FFhvZqBRJy27OmKrEUZyQaajEXFScCAI+CG3bkAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for S2MPS13 PMIC clock which is same with existing
S2MPS14 RTC IP. But, S2MPS13 uses all of clocks (32khz_{ap|bt|cp}).

Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/clk-s2mps11.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index b7797fb..7bb13af 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -23,6 +23,7 @@
 #include <linux/clk-provider.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/samsung/s2mps11.h>
+#include <linux/mfd/samsung/s2mps13.h>
 #include <linux/mfd/samsung/s2mps14.h>
 #include <linux/mfd/samsung/s5m8767.h>
 #include <linux/mfd/samsung/core.h>
@@ -120,6 +121,24 @@ static struct clk_init_data s2mps11_clks_init[S2MPS11_CLKS_NUM] = {
 	},
 };
 
+static struct clk_init_data s2mps13_clks_init[S2MPS11_CLKS_NUM] = {
+	[S2MPS11_CLK_AP] = {
+		.name = "s2mps13_ap",
+		.ops = &s2mps11_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+	[S2MPS11_CLK_CP] = {
+		.name = "s2mps13_cp",
+		.ops = &s2mps11_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+	[S2MPS11_CLK_BT] = {
+		.name = "s2mps13_bt",
+		.ops = &s2mps11_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+};
+
 static struct clk_init_data s2mps14_clks_init[S2MPS11_CLKS_NUM] = {
 	[S2MPS11_CLK_AP] = {
 		.name = "s2mps14_ap",
@@ -184,6 +203,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 		s2mps11_reg = S2MPS11_REG_RTC_CTRL;
 		clks_init = s2mps11_clks_init;
 		break;
+	case S2MPS13X:
+		s2mps11_reg = S2MPS13_REG_RTCCTRL;
+		clks_init = s2mps13_clks_init;
+		break;
 	case S2MPS14X:
 		s2mps11_reg = S2MPS14_REG_RTCCTRL;
 		clks_init = s2mps14_clks_init;
@@ -279,6 +302,7 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
 
 static const struct platform_device_id s2mps11_clk_id[] = {
 	{ "s2mps11-clk", S2MPS11X},
+	{ "s2mps13-clk", S2MPS13X},
 	{ "s2mps14-clk", S2MPS14X},
 	{ "s5m8767-clk", S5M8767X},
 	{ },
-- 
1.8.5.5

