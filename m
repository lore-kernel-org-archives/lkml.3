Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaKJM6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:58:47 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:54209 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaKJM6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:58:45 -0500
From: Bintian Wang <bintian.wang@huawei.com>
To: <mturquette@linaro.org>, <haojian.zhuang@linaro.org>,
        <zhangfei.gao@linaro.org>, <arnd@arndb.de>, <jh80.chung@samsung.com>,
        <li.xin@linaro.org>, <linux-kernel@vger.kernel.org>,
        <huxinwei@huawei.com>
CC: <bintian.wang@huawei.com>
Subject: [PATCH] clk: hi3620: Move const initdata into correct code section
Date: Mon, 10 Nov 2014 20:58:31 +0800
Message-ID: <1415624311-18980-1-git-send-email-bintian.wang@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.111.68.244]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __initconst instead of __initdata for constant init data.

Signed-off-by: Bintian Wang <bintian.wang@huawei.com>
---
 drivers/clk/hisilicon/clk-hi3620.c | 70 +++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/clk/hisilicon/clk-hi3620.c b/drivers/clk/hisilicon/clk-hi3620.c
index 339945d..640ea33 100644
--- a/drivers/clk/hisilicon/clk-hi3620.c
+++ b/drivers/clk/hisilicon/clk-hi3620.c
@@ -38,44 +38,44 @@
 #include "clk.h"
 
 /* clock parent list */
-static const char *timer0_mux_p[] __initdata = { "osc32k", "timerclk01", };
-static const char *timer1_mux_p[] __initdata = { "osc32k", "timerclk01", };
-static const char *timer2_mux_p[] __initdata = { "osc32k", "timerclk23", };
-static const char *timer3_mux_p[] __initdata = { "osc32k", "timerclk23", };
-static const char *timer4_mux_p[] __initdata = { "osc32k", "timerclk45", };
-static const char *timer5_mux_p[] __initdata = { "osc32k", "timerclk45", };
-static const char *timer6_mux_p[] __initdata = { "osc32k", "timerclk67", };
-static const char *timer7_mux_p[] __initdata = { "osc32k", "timerclk67", };
-static const char *timer8_mux_p[] __initdata = { "osc32k", "timerclk89", };
-static const char *timer9_mux_p[] __initdata = { "osc32k", "timerclk89", };
-static const char *uart0_mux_p[] __initdata = { "osc26m", "pclk", };
-static const char *uart1_mux_p[] __initdata = { "osc26m", "pclk", };
-static const char *uart2_mux_p[] __initdata = { "osc26m", "pclk", };
-static const char *uart3_mux_p[] __initdata = { "osc26m", "pclk", };
-static const char *uart4_mux_p[] __initdata = { "osc26m", "pclk", };
-static const char *spi0_mux_p[] __initdata = { "osc26m", "rclk_cfgaxi", };
-static const char *spi1_mux_p[] __initdata = { "osc26m", "rclk_cfgaxi", };
-static const char *spi2_mux_p[] __initdata = { "osc26m", "rclk_cfgaxi", };
+static const char *timer0_mux_p[] __initconst = { "osc32k", "timerclk01", };
+static const char *timer1_mux_p[] __initconst = { "osc32k", "timerclk01", };
+static const char *timer2_mux_p[] __initconst = { "osc32k", "timerclk23", };
+static const char *timer3_mux_p[] __initconst = { "osc32k", "timerclk23", };
+static const char *timer4_mux_p[] __initconst = { "osc32k", "timerclk45", };
+static const char *timer5_mux_p[] __initconst = { "osc32k", "timerclk45", };
+static const char *timer6_mux_p[] __initconst = { "osc32k", "timerclk67", };
+static const char *timer7_mux_p[] __initconst = { "osc32k", "timerclk67", };
+static const char *timer8_mux_p[] __initconst = { "osc32k", "timerclk89", };
+static const char *timer9_mux_p[] __initconst = { "osc32k", "timerclk89", };
+static const char *uart0_mux_p[] __initconst = { "osc26m", "pclk", };
+static const char *uart1_mux_p[] __initconst = { "osc26m", "pclk", };
+static const char *uart2_mux_p[] __initconst = { "osc26m", "pclk", };
+static const char *uart3_mux_p[] __initconst = { "osc26m", "pclk", };
+static const char *uart4_mux_p[] __initconst = { "osc26m", "pclk", };
+static const char *spi0_mux_p[] __initconst = { "osc26m", "rclk_cfgaxi", };
+static const char *spi1_mux_p[] __initconst = { "osc26m", "rclk_cfgaxi", };
+static const char *spi2_mux_p[] __initconst = { "osc26m", "rclk_cfgaxi", };
 /* share axi parent */
-static const char *saxi_mux_p[] __initdata = { "armpll3", "armpll2", };
-static const char *pwm0_mux_p[] __initdata = { "osc32k", "osc26m", };
-static const char *pwm1_mux_p[] __initdata = { "osc32k", "osc26m", };
-static const char *sd_mux_p[] __initdata = { "armpll2", "armpll3", };
-static const char *mmc1_mux_p[] __initdata = { "armpll2", "armpll3", };
-static const char *mmc1_mux2_p[] __initdata = { "osc26m", "mmc1_div", };
-static const char *g2d_mux_p[] __initdata = { "armpll2", "armpll3", };
-static const char *venc_mux_p[] __initdata = { "armpll2", "armpll3", };
-static const char *vdec_mux_p[] __initdata = { "armpll2", "armpll3", };
-static const char *vpp_mux_p[] __initdata = { "armpll2", "armpll3", };
-static const char *edc0_mux_p[] __initdata = { "armpll2", "armpll3", };
-static const char *ldi0_mux_p[] __initdata = { "armpll2", "armpll4",
+static const char *saxi_mux_p[] __initconst = { "armpll3", "armpll2", };
+static const char *pwm0_mux_p[] __initconst = { "osc32k", "osc26m", };
+static const char *pwm1_mux_p[] __initconst = { "osc32k", "osc26m", };
+static const char *sd_mux_p[] __initconst = { "armpll2", "armpll3", };
+static const char *mmc1_mux_p[] __initconst = { "armpll2", "armpll3", };
+static const char *mmc1_mux2_p[] __initconst = { "osc26m", "mmc1_div", };
+static const char *g2d_mux_p[] __initconst = { "armpll2", "armpll3", };
+static const char *venc_mux_p[] __initconst = { "armpll2", "armpll3", };
+static const char *vdec_mux_p[] __initconst = { "armpll2", "armpll3", };
+static const char *vpp_mux_p[] __initconst = { "armpll2", "armpll3", };
+static const char *edc0_mux_p[] __initconst = { "armpll2", "armpll3", };
+static const char *ldi0_mux_p[] __initconst = { "armpll2", "armpll4",
 					     "armpll3", "armpll5", };
-static const char *edc1_mux_p[] __initdata = { "armpll2", "armpll3", };
-static const char *ldi1_mux_p[] __initdata = { "armpll2", "armpll4",
+static const char *edc1_mux_p[] __initconst = { "armpll2", "armpll3", };
+static const char *ldi1_mux_p[] __initconst = { "armpll2", "armpll4",
 					     "armpll3", "armpll5", };
-static const char *rclk_hsic_p[] __initdata = { "armpll3", "armpll2", };
-static const char *mmc2_mux_p[] __initdata = { "armpll2", "armpll3", };
-static const char *mmc3_mux_p[] __initdata = { "armpll2", "armpll3", };
+static const char *rclk_hsic_p[] __initconst = { "armpll3", "armpll2", };
+static const char *mmc2_mux_p[] __initconst = { "armpll2", "armpll3", };
+static const char *mmc3_mux_p[] __initconst = { "armpll2", "armpll3", };
 
 
 /* fixed rate clocks */
-- 
1.9.1


