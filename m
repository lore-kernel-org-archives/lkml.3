Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaJJEvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 00:51:09 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39487 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaJJEum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 00:50:42 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de, Mike Turquette <mturquette@linaro.org>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, dkl@rock-chips.com,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] clk: rockchip: add 400MHz and 500MHz for rk3288 clock rate
Date: Thu,  9 Oct 2014 21:50:29 -0700
Message-Id: <1412916630-8256-2-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412916630-8256-1-git-send-email-kever.yang@rock-chips.com>
References: <1412916630-8256-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add 400MHz and 500MHz to clock rate table for rk3288.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v2:
- change the PLL setting of 400M to meet the constraints of TRM

 drivers/clk/rockchip/clk-rk3288.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index d053529..7c30a5a 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -86,8 +86,10 @@ struct rockchip_pll_rate_table rk3288_pll_rates[] = {
 	RK3066_PLL_RATE( 594000000, 2, 198, 4),
 	RK3066_PLL_RATE( 552000000, 1, 46, 2),
 	RK3066_PLL_RATE( 504000000, 1, 84, 4),
+	RK3066_PLL_RATE( 500000000, 3, 125, 2),
 	RK3066_PLL_RATE( 456000000, 1, 76, 4),
 	RK3066_PLL_RATE( 408000000, 1, 68, 4),
+	RK3066_PLL_RATE( 400000000, 3, 100, 2),
 	RK3066_PLL_RATE( 384000000, 2, 128, 4),
 	RK3066_PLL_RATE( 360000000, 1, 60, 4),
 	RK3066_PLL_RATE( 312000000, 1, 52, 4),
-- 
1.9.1

