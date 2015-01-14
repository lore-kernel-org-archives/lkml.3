Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbbANBRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 20:17:50 -0500
Received: from m12-17.163.com ([220.181.12.17]:48236 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbbANBRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 20:17:49 -0500
X-Coremail-DSSMTP: 117.88.247.19
From: weiyj_lk@163.com
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH -next] clk: shmobile: fix sparse NULL pointer warning
Date: Wed, 14 Jan 2015 09:16:23 +0800
Message-Id: <1421198183-17417-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EcCowECZAkZow7VUYx3GAQ--.32S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7WryUGw4DAF17KFW8uw4rKrg_yoW3trg_uF
	y7JFsrZryfA340vF17Gw1fArySv3Z8ZF1kXF4vqa42y3sY9r1UZrZYgF43Gr1Ut3y09Fsx
	JwnIgrW7Cr1rGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU06BT7UUUUU==
X-Originating-IP: [117.88.247.19]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiowqB1lD+YxGDqQAAsI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

drivers/clk/shmobile/clk-sh73a0.c:57:17: warning:
 Using plain integer as NULL pointer

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/clk/shmobile/clk-sh73a0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/shmobile/clk-sh73a0.c b/drivers/clk/shmobile/clk-sh73a0.c
index 8574a6d..cd529cf 100644
--- a/drivers/clk/shmobile/clk-sh73a0.c
+++ b/drivers/clk/shmobile/clk-sh73a0.c
@@ -54,7 +54,7 @@ static struct div4_clk div4_clks[] = {
 	{ "m2", "pll1", CPG_FRQCRA,  0 },
 	{ "zx", "pll1", CPG_FRQCRB, 12 },
 	{ "hp", "pll1", CPG_FRQCRB,  4 },
-	{ NULL, 0, 0, 0 },
+	{ NULL, NULL, 0, 0 },
 };
 
 static const struct clk_div_table div4_div_table[] = {

