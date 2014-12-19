Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaLSAOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 19:14:11 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:37234 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaLSANy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 19:13:54 -0500
From: Dmitry Torokhov <dtor@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, hl@rock-chips.com,
        kever.yang@rock-chips.com, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] CHROMIUM: clk: rockchip: add PVTM clocks on rk3288
Date: Thu, 18 Dec 2014 16:13:46 -0800
Message-Id: <1418948026-3463-2-git-send-email-dtor@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1418948026-3463-1-git-send-email-dtor@chromium.org>
References: <1418948026-3463-1-git-send-email-dtor@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: huang lin <hl@rock-chips.com>

Process-Voltage-Temperatiure Monitor block on RK3288 has two clocks:
PVTM_CORE and PVTM_GPU.

Signed-off-by: Huang Lin <hl@rock-chips.com>
Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---
 drivers/clk/rockchip/clk-rk3288.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index ac6be7c..4632bb3 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -704,8 +704,8 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 
 	GATE(SCLK_LCDC_PWM0, "sclk_lcdc_pwm0", "xin24m", 0, RK3288_CLKGATE_CON(13), 10, GFLAGS),
 	GATE(SCLK_LCDC_PWM1, "sclk_lcdc_pwm1", "xin24m", 0, RK3288_CLKGATE_CON(13), 11, GFLAGS),
-	GATE(0, "sclk_pvtm_core", "xin24m", 0, RK3288_CLKGATE_CON(5), 9, GFLAGS),
-	GATE(0, "sclk_pvtm_gpu", "xin24m", 0, RK3288_CLKGATE_CON(5), 10, GFLAGS),
+	GATE(SCLK_PVTM_CORE, "sclk_pvtm_core", "xin24m", 0, RK3288_CLKGATE_CON(5), 9, GFLAGS),
+	GATE(SCLK_PVTM_GPU, "sclk_pvtm_gpu", "xin24m", 0, RK3288_CLKGATE_CON(5), 10, GFLAGS),
 	GATE(0, "sclk_mipidsi_24m", "xin24m", 0, RK3288_CLKGATE_CON(5), 15, GFLAGS),
 
 	/* sclk_gpu gates */
-- 
2.2.0.rc0.207.ga3a616c

