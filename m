Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaBTNyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:54:18 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13722 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaBTNyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:54:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 20 Feb 2014 05:51:57 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra124: remove gr2d and gr3d clocks
Date: Thu, 20 Feb 2014 15:54:07 +0200
Message-ID: <1392904448-11939-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra124 does not have gr2d and gr3d clocks. They have been replaced by the
vic03 and gpu clocks respectively.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra124.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index b4cf650..166e02f 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -769,10 +769,8 @@ static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_sdmmc4_8] = { .dt_id = TEGRA124_CLK_SDMMC4, .present = true },
 	[tegra_clk_pwm] = { .dt_id = TEGRA124_CLK_PWM, .present = true },
 	[tegra_clk_i2s2] = { .dt_id = TEGRA124_CLK_I2S2, .present = true },
-	[tegra_clk_gr2d] = { .dt_id = TEGRA124_CLK_GR_2D, .present = true },
 	[tegra_clk_usbd] = { .dt_id = TEGRA124_CLK_USBD, .present = true },
 	[tegra_clk_isp_8] = { .dt_id = TEGRA124_CLK_ISP, .present = true },
-	[tegra_clk_gr3d] = { .dt_id = TEGRA124_CLK_GR_3D, .present = true },
 	[tegra_clk_disp2] = { .dt_id = TEGRA124_CLK_DISP2, .present = true },
 	[tegra_clk_disp1] = { .dt_id = TEGRA124_CLK_DISP1, .present = true },
 	[tegra_clk_host1x_8] = { .dt_id = TEGRA124_CLK_HOST1X, .present = true },
-- 
1.7.7.rc0.72.g4b5ea.dirty

