Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaG1N2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:28:15 -0400
Received: from m12-13.163.com ([220.181.12.13]:33475 "EHLO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaG1N2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:28:14 -0400
X-Coremail-DSSMTP: 121.225.181.73
From: weiyj_lk@163.com
To: emilio@elopez.com.ar, mturquette@linaro.org,
        maxime.ripard@free-electrons.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH -next] clk: sunxi: sun6i-apb0-gates: fix sparse non static symbol warning
Date: Mon, 28 Jul 2014 21:27:14 +0800
Message-Id: <1406554034-30266-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DcCowEAZO160T9ZT2WlpAA--.1122S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7WryUGw4DAF17KF48GrWfXwb_yoWkArb_Ca
	47Xr4xCryUCFZYyF15CFnIy34Sv3Z5ZF97XF129ay5tay8ur13GrWv9w4xAryrtrWUG39F
	vw1Dt34jvw1DtjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUY4OJ7UUUUU==
X-Originating-IP: [121.225.181.73]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiowzW1lD+Vi84xQAAsF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

drivers/clk/sunxi/clk-sun6i-apb0-gates.c:82:27: warning:
 symbol 'sun6i_a31_apb0_gates_clk_dt_ids' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/clk/sunxi/clk-sun6i-apb0-gates.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
index ef5e419..e10d052 100644
--- a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
+++ b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
@@ -29,7 +29,7 @@ static const struct gates_data sun8i_a23_apb0_gates __initconst = {
 	.mask = {0x5D},
 };
 
-const struct of_device_id sun6i_a31_apb0_gates_clk_dt_ids[] = {
+static const struct of_device_id sun6i_a31_apb0_gates_clk_dt_ids[] = {
 	{ .compatible = "allwinner,sun6i-a31-apb0-gates-clk", .data = &sun6i_a31_apb0_gates },
 	{ .compatible = "allwinner,sun8i-a23-apb0-gates-clk", .data = &sun8i_a23_apb0_gates },
 	{ /* sentinel */ }

