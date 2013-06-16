Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab3FPXiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 19:38:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60815 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3FPXiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 19:38:23 -0400
X-AuditID: cbfee691-b7fef6d000002d62-d7-51be4c6d4e7f
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Paul Walmsley'" <paul@pwsan.com>,
        "'Jean-Philippe Francois'" <jp.francois@cynove.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] ARM: omap3: clock: fix wrong container_of in
 clock36xx.c
Date: Mon, 17 Jun 2013 08:38:15 +0900
Message-id: <008d01ce6aea$96291790$c27b46b0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkhkJMAQebi3w
Content-language: ko
x-cr-hashedpuzzle: AW3l BTxr FRLp IIEb RQq6 SBpK WG1X bEmG b5cL fl10 gq6N g4pB
 jutd lNqj 0X5/
 1c95;5;agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAagBwAC4AZgByAGEAbgBjAG8AaQBzAEAAYwB5AG4AbwB2AGUALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBwAGEAdQBsAEAAcAB3AHMAYQBuAC4AYwBvAG0AOwBzAHQAYQBiAGwAZQBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{AFD91766-AE80-4A7E-BC1C-2E35126FF096};agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Sun,
 16 Jun 2013 23:37:38
 GMT;WwBQAEEAVABDAEgAIAAzAC4AOQAtAHMAdABhAGIAbABlAF0AIABBAFIATQA6ACAAbwBtAGEAcAAzADoAIABjAGwAbwBjAGsAOgAgAGYAaQB4ACAAdwByAG8AbgBnACAAYwBvAG4AdABhAGkAbgBlAHIAXwBvAGYAIABpAG4AIABjAGwAbwBjAGsAMwA2AHgAeAAuAGMA
x-cr-puzzleid: {AFD91766-AE80-4A7E-BC1C-2E35126FF096}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zA91cn32BBts3ylssaea2WNx8gsni
	8q45bBYfdvxltliw8RGjA6vHg9YZzB43fveye/RtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
	0V9L2QpmC1esnXGGsYHxL38XIyeHhICJxLfpR5ghbDGJC/fWs3UxcnEICSxjlDjVe4kZpmj/
	t1PMEIlFjBJtN/qYIJy/jBJLns5gBaliE9CVOLZ+C5gtIuAtcWrKL7BuZoFCiV9XOxi7GDmA
	GrglVjcHgYQ5BXgk1v3pBCsRFgiT2DqllR3EZhFQlXi9+xlYnFfATuLx4142CFtQ4sfkeywQ
	I7Uk1u88zgRhy0tsXvOWGWS8hIC6xKO/uiCniQi0MEoc2PGfDaJGRGLfi3eMIAkJgR+sEmcn
	dUN9Zirxels/G0TiI7vEtdPtbBBXCEh8m3yIBWKqrMSmA1D1khIHV9xgmcAoNQvJTbOQ3DQL
	yU2zkOxewMiyilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMkoifuYLx/wPoQYzLQ+onMUqLJ
	+cCEkFcSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	RpvqO+0KD3xEf827xlbc8H3+6Uv2L++uOhGtZeYp6Wr4evaVsweF+FeFrr1zuvNE8Uy+306H
	H7TtOvJuy3SPP5lbNGam8m/omMz7ID/o/czt5sYezDk7Mk1emS174bWxOWBPjfqP26/k3C46
	z764pmPa96pKTjX1ishVr49uiinmK1t4xDX05g8lluKMREMt5qLiRAAkBFY8/gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jAd1cn32BBo2fpCyWNHNbLG4+wWRx
	edccNosPO/4yWyzY+IjRgdXjQesMZo8bv3vZPfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdor5JCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsI4x4+ivpWwFs4Ur1s44w9jA+Je/i5GTQ0LARGL/t1PMELaY
	xIV769m6GLk4hAQWMUq03ehjgnD+MkoseTqDFaSKTUBX4tj6LWC2iIC3xKkpv8C6mQUKJX5d
	7WDsYuQAauCWWN0cBBLmFOCRWPenE6xEWCBMYuuUVnYQm0VAVeL17mdgcV4BO4nHj3vZIGxB
	iR+T77FAjNSSWL/zOBOELS+xec1bZpDxEgLqEo/+6oKcJiLQwihxYMd/NogaEYl9L94xgiQk
	BH6wSpyd1A31manE6239bBMYRWYh2TELyY5ZSHbMQjJrASPLKkbR1ILkguKk9FxDveLE3OLS
	vHS95PzcTYzgdPFMagfjygaLQ4wCHIxKPLwSonsDhVgTy4orcw8xSnAwK4nwGi0DCvGmJFZW
	pRblxxeV5qQWH2JMBgbBRGYp0eR8YCrLK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJ
	anZqakFqEcwWJg5OqQZGEe5d0smcE4v95yzXeOXBn7vO531MQYjd0YVxzc9N5/Hzf88qrXfU
	sJ8r0SfXuV2r3+jPPdUHudIevvoeGSarJpqr1C6XOm206Klop26cYrZ5guay3QdKPD1UuT8u
	e2J9U3K+nH+5xKGHj332l8XKHtT4tLj/dl7256NXl9QKWam+uSRx7okSS3FGoqEWc1FxIgCj
	CIomWwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Jean-Philippe Francois <jp.francois@cynove.com>"

commit a93d8a1cea0899982993e9a93404c6f78b123697 upstream

omap36xx_pwrdn_clk_enable_with_hsdiv_restore expects the parent hw of
the clock to be a clk_hw_omap. However, looking at cclock3xxx_data.c,
all concerned clock have parent defined as clk_divider.  Fix the
function to use clk_divider.  Tested with 3.9 on dm3730.

Signed-off-by: Jean-Philippe Francois <jp.francois@cynove.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/mach-omap2/clock36xx.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-omap2/clock36xx.c
b/arch/arm/mach-omap2/clock36xx.c
index 8f3bf4e..bbd6a3f 100644
--- a/arch/arm/mach-omap2/clock36xx.c
+++ b/arch/arm/mach-omap2/clock36xx.c
@@ -20,11 +20,12 @@
 
 #include <linux/kernel.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/io.h>
 
 #include "clock.h"
 #include "clock36xx.h"
-
+#define to_clk_divider(_hw) container_of(_hw, struct clk_divider, hw)
 
 /**
  * omap36xx_pwrdn_clk_enable_with_hsdiv_restore - enable clocks suffering
@@ -39,29 +40,28 @@
  */
 int omap36xx_pwrdn_clk_enable_with_hsdiv_restore(struct clk_hw *clk)
 {
-	struct clk_hw_omap *parent;
+	struct clk_divider *parent;
 	struct clk_hw *parent_hw;
-	u32 dummy_v, orig_v, clksel_shift;
+	u32 dummy_v, orig_v;
 	int ret;
 
 	/* Clear PWRDN bit of HSDIVIDER */
 	ret = omap2_dflt_clk_enable(clk);
 
 	parent_hw = __clk_get_hw(__clk_get_parent(clk->clk));
-	parent = to_clk_hw_omap(parent_hw);
+	parent = to_clk_divider(parent_hw);
 
 	/* Restore the dividers */
 	if (!ret) {
-		clksel_shift = __ffs(parent->clksel_mask);
-		orig_v = __raw_readl(parent->clksel_reg);
+		orig_v = __raw_readl(parent->reg);
 		dummy_v = orig_v;
 
 		/* Write any other value different from the Read value */
-		dummy_v ^= (1 << clksel_shift);
-		__raw_writel(dummy_v, parent->clksel_reg);
+		dummy_v ^= (1 << parent->shift);
+		__raw_writel(dummy_v, parent->reg);
 
 		/* Write the original divider */
-		__raw_writel(orig_v, parent->clksel_reg);
+		__raw_writel(orig_v, parent->reg);
 	}
 
 	return ret;
-- 
1.7.9.5

