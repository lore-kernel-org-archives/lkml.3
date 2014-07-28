Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaG1N2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:28:34 -0400
Received: from m12-15.163.com ([220.181.12.15]:51249 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbaG1N2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:28:33 -0400
X-Coremail-DSSMTP: 121.225.181.73
From: weiyj_lk@163.com
To: emilio@elopez.com.ar, mturquette@linaro.org,
        maxime.ripard@free-electrons.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH -next] clk: sunxi: sun6i-apb0: fix sparse non static symbol warning
Date: Mon, 28 Jul 2014 21:27:43 +0800
Message-Id: <1406554063-30350-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: D8CowECpD2HQT9ZTkRb6CQ--.161S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7WryUGw4DAF1xJF1DGw4kZwb_yoWDGwb_Ca
	47Xr4xCryfAFWvyFyUJF12y34SvFnYvryDXF12kasxta48ur43GrZYkw1Syry5XrWDGrWD
	Zw1qg3yj9an8tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUY75r3UUUUU==
X-Originating-IP: [121.225.181.73]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiGRPW1lEANioBRgAAsA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

drivers/clk/sunxi/clk-sun6i-apb0.c:60:27: warning:
 symbol 'sun6i_a31_apb0_clk_dt_ids' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/clk/sunxi/clk-sun6i-apb0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi/clk-sun6i-apb0.c b/drivers/clk/sunxi/clk-sun6i-apb0.c
index 11f17c3..1fa2337 100644
--- a/drivers/clk/sunxi/clk-sun6i-apb0.c
+++ b/drivers/clk/sunxi/clk-sun6i-apb0.c
@@ -57,7 +57,7 @@ static int sun6i_a31_apb0_clk_probe(struct platform_device *pdev)
 	return of_clk_add_provider(np, of_clk_src_simple_get, clk);
 }
 
-const struct of_device_id sun6i_a31_apb0_clk_dt_ids[] = {
+static const struct of_device_id sun6i_a31_apb0_clk_dt_ids[] = {
 	{ .compatible = "allwinner,sun6i-a31-apb0-clk" },
 	{ /* sentinel */ }
 };

