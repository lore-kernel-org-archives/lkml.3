Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822Ab3FSATK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:19:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26538 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab3FSATH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:19:07 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-2f-51c0f8f9d2fb
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Jay Agarwal'" <jagarwal@nvidia.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] ARM: tegra30: clocks: Fix pciex clock registration
Date: Wed, 19 Jun 2013 09:19:04 +0900
Message-id: <003501ce6c82$9be49440$d3adbcc0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkhkJMAQebi3wAAAo4zAAZZSxgA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zfd2fPw4EGmxpt7B4MWsOs8WSZm6L
	y7vmsFks2PiI0YHFo7f5HZtH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZazZsIip4CVvxaQT
	c1kaGE9zdzFyckgImEjsXfKNBcIWk7hwbz0biC0ksIxRomdzKEzN+tZnUPFFjBIz36V0MXIB
	2X8ZJTYeXQTWzCagK3Fs/RZWEFtEwFvi1JRfzF2MHBzMAvYSp/cGg5hCAtwSq5uDQCo4BXgk
	1v3pZAaxhQX8JD5d6QKbwiKgKjH5/zMwm1fATuLa/iZGCFtQ4sfke2BxZgEtifU7jzNB2PIS
	m9e8BdskIaAu8eivLshlIgJTGCWuN85ig6gRkdj34h0jSEJC4Bi7xPY796CWCUh8m3yIBaJZ
	VmLTAWaIdyUlDq64wTKBUWIWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y0StOzC0uzUvX
	S87P3cQIicIJOxjvHbA+xJgMtH4is5Rocj4wivNK4g2NzYwsTE1MjY3MLc1IE1YS51VvsQ4U
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwDjpbOcu+2Wsa3aqPmY/8bq/0/DW2S1HDfNuhAkX
	Kib2KtvtTtPRKJX7sltz+5ni+JxpDHHG3SFnvcukchQWynp8v6fq/Hhiw/xjnhME7+zRMnp8
	tk7P4GpixFK2NQZd187Ht4YvKUk71JZiEjtxiplsTqK9xhn73frfZ299xvPQtiTP+HxVnRJL
	cUaioRZzUXEiACpsStPYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAd2fPw4EGvz9Y2zxYtYcZoslzdwW
	l3fNYbNYsPERowOLR2/zOzaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8xYs2ERU8FL3opJJ+ayNDCe5u5i5OSQEDCRWN/6jA3CFpO4cG89mC0ksIhR
	Yua7lC5GLiD7L6PExqOLWEASbAK6EsfWb2EFsUUEvCVOTfnF3MXIwcEsYC9xem8wiCkkwC2x
	ujkIpIJTgEdi3Z9OZhBbWMBP4tOVLrApLAKqEpP/PwOzeQXsJK7tb2KEsAUlfky+BxZnFtCS
	WL/zOBOELS+xec1bsE0SAuoSj/7qglwmIjCFUeJ64yw2iBoRiX0v3jFOYBSahWTULCSjZiEZ
	NQtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwVH+TGoH48oGi0OMAhyMSjy8DSsP
	BAqxJpYVV+YeYpTgYFYS4dV8BBTiTUmsrEotyo8vKs1JLT7EmAz06URmKdHkfGACyiuJNzQ2
	MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRs7DHS9OmOU8mJJUtLu9
	sbtUXGbFW4bO1xJO94oiJvq2LZnpWXf8BbvmbgZOpUQBlhcNhidm7Ug5nfpRn2WdY0rb93eO
	XFtLTjzKZ2CfoSm38ILvbIdea4k1z+O3vFlvmLJUZVXx4jd78j/dqIoWW/AjRWebs+hJy/Vz
	l7BGrnl6rYWnf2VJuxJLcUaioRZzUXEiAGe7jcw2AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Jay Agarwal <jagarwal@nvidia.com>"

commit ff49fad1d9bf2c49f52817b04cde8e4412434637 upstream

Registering pciex as peripheral clock instead of fixed clock
as tegra_perih_reset_assert(deassert) api of this clock api
gives warning and ultimately does not succeed to assert(deassert)

Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/clk/tegra/clk-tegra30.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c
b/drivers/clk/tegra/clk-tegra30.c
index ba6f51b..1f8595b 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1592,6 +1592,12 @@ static void __init tegra30_periph_clk_init(void)
 	clk_register_clkdev(clk, "afi", "tegra-pcie");
 	clks[afi] = clk;
 
+	/* pciex */
+	clk = tegra_clk_register_periph_gate("pciex", "pll_e", 0, clk_base,
0,
+				    74, &periph_u_regs,
periph_clk_enb_refcnt);
+	clk_register_clkdev(clk, "pciex", "tegra-pcie");
+	clks[pciex] = clk;
+
 	/* kfuse */
 	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
@@ -1710,11 +1716,6 @@ static void __init tegra30_fixed_clk_init(void)
 				1, 0, &cml_lock);
 	clk_register_clkdev(clk, "cml1", NULL);
 	clks[cml1] = clk;
-
-	/* pciex */
-	clk = clk_register_fixed_rate(NULL, "pciex", "pll_e", 0, 100000000);
-	clk_register_clkdev(clk, "pciex", NULL);
-	clks[pciex] = clk;
 }
 
 static void __init tegra30_osc_clk_init(void)
-- 
1.7.9.5

