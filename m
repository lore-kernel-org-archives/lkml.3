Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaEDQYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:24:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbaEDPmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3.14 155/158] clk: tegra: remove non-existent clocks
Date: Sun,  4 May 2014 11:41:04 -0400
Message-Id: <20140504154051.068542610@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 9ba71705706aa83bcd7f9b74ae2d167da934c951 upstream.

The Tegra124 clock driver currently provides 3 clocks that don't actually
exist; 2 for NAND and one for UART5/UARTE. Delete these.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/tegra/clk-tegra124.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -764,7 +764,6 @@ static struct tegra_clk tegra124_clks[te
 	[tegra_clk_sdmmc2_8] = { .dt_id = TEGRA124_CLK_SDMMC2, .present = true },
 	[tegra_clk_i2s1] = { .dt_id = TEGRA124_CLK_I2S1, .present = true },
 	[tegra_clk_i2c1] = { .dt_id = TEGRA124_CLK_I2C1, .present = true },
-	[tegra_clk_ndflash] = { .dt_id = TEGRA124_CLK_NDFLASH, .present = true },
 	[tegra_clk_sdmmc1_8] = { .dt_id = TEGRA124_CLK_SDMMC1, .present = true },
 	[tegra_clk_sdmmc4_8] = { .dt_id = TEGRA124_CLK_SDMMC4, .present = true },
 	[tegra_clk_pwm] = { .dt_id = TEGRA124_CLK_PWM, .present = true },
@@ -809,7 +808,6 @@ static struct tegra_clk tegra124_clks[te
 	[tegra_clk_trace] = { .dt_id = TEGRA124_CLK_TRACE, .present = true },
 	[tegra_clk_soc_therm] = { .dt_id = TEGRA124_CLK_SOC_THERM, .present = true },
 	[tegra_clk_dtv] = { .dt_id = TEGRA124_CLK_DTV, .present = true },
-	[tegra_clk_ndspeed] = { .dt_id = TEGRA124_CLK_NDSPEED, .present = true },
 	[tegra_clk_i2cslow] = { .dt_id = TEGRA124_CLK_I2CSLOW, .present = true },
 	[tegra_clk_dsib] = { .dt_id = TEGRA124_CLK_DSIB, .present = true },
 	[tegra_clk_tsec] = { .dt_id = TEGRA124_CLK_TSEC, .present = true },
@@ -952,7 +950,6 @@ static struct tegra_clk tegra124_clks[te
 	[tegra_clk_clk_out_3_mux] = { .dt_id = TEGRA124_CLK_CLK_OUT_3_MUX, .present = true },
 	[tegra_clk_dsia_mux] = { .dt_id = TEGRA124_CLK_DSIA_MUX, .present = true },
 	[tegra_clk_dsib_mux] = { .dt_id = TEGRA124_CLK_DSIB_MUX, .present = true },
-	[tegra_clk_uarte] = { .dt_id = TEGRA124_CLK_UARTE, .present = true },
 };
 
 static struct tegra_devclk devclks[] __initdata = {


